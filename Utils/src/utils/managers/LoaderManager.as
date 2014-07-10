/**
 * Created by William on 2/18/14.
 */
package utils.managers {
import com.greensock.events.LoaderEvent;
import com.greensock.loading.DataLoader;
import com.greensock.loading.ImageLoader;
import com.greensock.loading.LoaderMax;
import com.greensock.loading.LoaderStatus;
import com.greensock.loading.MP3Loader;
import com.greensock.loading.SWFLoader;
import com.greensock.loading.VideoLoader;
import com.greensock.loading.XMLLoader;
import com.greensock.loading.core.LoaderCore;

import flash.utils.Dictionary;

import utils.commands.clamp;
import utils.event.SignalDispatcher;

/**
 * This class loads assets in order (not optimal for multi-threading)
 */
public class LoaderManager {

    private static const DEFAULT_GROUP:String = "default";

    private static var _initialized:Boolean = false;

    /**
     * The main queue, it holds all loader as children
     */
    private static var queue:LoaderMax = new LoaderMax({
        name:"mainQueue", maxConnections:1, auditSize:true, autoLoad:false, autoDispose:false, skipFailed: false,
        onProgress          :onProgress             ,
        onComplete          :onComplete             ,
        onError             :onError                ,
        onOpen              :onOpen                 ,
        onCancel            :onCancel               ,
        onIOError           :onIOError              ,
        onHTTPStatus        :onHTTPStatus           ,
        onScriptAccessDenied:onScriptAccessDenied   ,

        onChildOpen         :onChildOpen            ,
        onChildProgress     :onChildProgress        ,
        onChildComplete     :onChildComplete        ,
        onChildCancel       :onChildCancel          ,
        onChildFail         :onChildFail
    });

    /**
     * Dispatches the event from the main queue for external listeners
     * The event names are from LoaderEvent
     */
    public static var dispatcher:SignalDispatcher = new SignalDispatcher(null);

    [ArrayElementType("LoadingGroup")]
    private static var waitingList:Array = []; //Vector.<LoadingGroup> = new Vector.<LoadingGroup>();

    private static var currentLoadingGroup:LoadingGroup = null;

    private static var loadedGroups:Dictionary = new Dictionary();


    //==================================
    //  Main Queue / Load / Loader
    //==================================
    public static function get isLoading():Boolean {
        return queue.status == LoaderStatus.LOADING;
    }

    public static function getLoader(nameOrURL:String):* {
        return queue.getLoader(nameOrURL);
    }

    public static function getContent(nameOrURL:String):* {
        return queue.getContent(nameOrURL);
    }

    //==================================
    //  Single Load
    //==================================
    /**
     * Appends and automatically loads the file (no need to use load())
     * @param urlOrRequest The path or url to where the file is located
     * @param params Parameters for the loader
     */
    public static function loadSWF  (urlOrRequest:*, params:Object):void { loadNow(new SWFLoader(urlOrRequest, params)); }
    /** @copy #loadSWF */
    public static function loadXML  (urlOrRequest:*, params:Object):void { loadNow(new XMLLoader(urlOrRequest, params)); }
    /** @copy #loadSWF */
    public static function loadMP3  (urlOrRequest:*, params:Object):void { loadNow(new MP3Loader(urlOrRequest, params)); }
    /** @copy #loadSWF */
    public static function loadData (urlOrRequest:*, params:Object):void { loadNow(new DataLoader(urlOrRequest, params)); }
    /** @copy #loadSWF */
    public static function loadVideo(urlOrRequest:*, params:Object):void { loadNow(new VideoLoader(urlOrRequest, params)); }
    /** @copy #loadSWF */
    public static function loadImage(urlOrRequest:*, params:Object):void { loadNow(new ImageLoader(urlOrRequest, params)); }

    private static function loadNow(loader:LoaderCore):void {
        initialize();
        queue.append(loader);
        loader.prioritize(true);
    }

    //==================================
    //  Group Load
    //==================================
    /**
     * Appends the request to load to the main queue (it will automatically start loading)
     * (Note: if LoaderManager is already loading, the appended files will be added to the queue in order)
     * @param urlOrRequest The path or url to where the file is located
     * @param params Parameters for the loader
     */
    public static function appendSWF  (urlOrRequest:*, params:Object):void { append(new SWFLoader(urlOrRequest, params)); }
    /** @copy #appendSWF */
    public static function appendXML  (urlOrRequest:*, params:Object):void { append(new XMLLoader(urlOrRequest, params)); }
    /** @copy #appendSWF */
    public static function appendMP3  (urlOrRequest:*, params:Object):void { append(new MP3Loader(urlOrRequest, params)); }
    /** @copy #appendSWF */
    public static function appendData (urlOrRequest:*, params:Object):void { append(new DataLoader(urlOrRequest, params)); }
    /** @copy #appendSWF */
    public static function appendVideo(urlOrRequest:*, params:Object):void { append(new VideoLoader(urlOrRequest, params)); }
    /** @copy #appendSWF */
    public static function appendImage(urlOrRequest:*, params:Object):void { append(new ImageLoader(urlOrRequest, params)); }

    private static function append(loader:LoaderCore):void {
        initialize();
        if(isLoading) {
            //guaranteeing the index won't be -1
            var group:LoadingGroup = waitingList[clamp(waitingList.length-1, 0, uint.MAX_VALUE)] || currentLoadingGroup;
            //finding the last group with id == DEFAULT_GROUP
            if(group == null || group.id != DEFAULT_GROUP) {
                group = new LoadingGroup(DEFAULT_GROUP);
                waitingList.push(group);
            }
            group.loaders.push(loader);
        } else {
            queue.append(loader);
            queue.load();
        }
    }

    /**
     * Loads a list of url or requests (String)
     * @param id String containing the identification of this list, cannot be empty or null
     * @param list Array or Vector.<Object> with the objects as : {name:"assetName", url:"assetUrl", autoPlay:false ...}
     * @param vars Object containing values for this list ex: {onComplete:(function), onCompleteParams:(Array), onProgress:(function) ...}
     */
    public static function loadList(id:String, list:*, vars:Object):void {
        if(id == null || id == "" || id == DEFAULT_GROUP)
            throw new ArgumentError("ID cannot be empty or null.");
        if(list == null || list.length == 0)
            throw new ArgumentError("List cannot be empty or null.");

        initialize();

        var group:LoadingGroup = new LoadingGroup(id);
        group.onComplete        = vars.onComplete;
        group.onCompleteParams  = vars.onCompleteParams;
        group.onProgress        = vars.onProgress;

        for each (var asset:Object in list) {
            //nothing to do if there is no file to load
            if(asset.url == null || asset.url == "")
                continue;

            var loaderVars:Object = { };

            //copying values
            for (var property:String in asset) {
                loaderVars[property] = asset[property];
            }

            //making sure the name property is not empty
            loaderVars.name ||= asset.url;

            switch (getExtension(asset.url)) {
                case null:      break;
                case "swf"  : group.loaders.push(new SWFLoader(asset.url, loaderVars)); break;
                case "mp3"  : group.loaders.push(new MP3Loader(asset.url, loaderVars)); break;
                case "mp4"  :
                case "wmv"  :
                case "mpeg" :
                case "flv"  :
                case "mkv"  : group.loaders.push(new VideoLoader(asset.url, loaderVars)); break;
                case "jpg"  :
                case "png"  :
                case "jpeg" : group.loaders.push(new ImageLoader(asset.url, loaderVars)); break;
                case "xml"  : group.loaders.push(new XMLLoader(asset.url, loaderVars)); break;
                case "txt"  :
                case "json" :
                default : group.loaders.push(new DataLoader(asset.url, loaderVars)); break;
            }
        }

        if(isLoading) {
            waitingList.push(group);
        } else {
            currentLoadingGroup = group;
            for each (var loader:LoaderCore in group.loaders) {
                queue.append(loader);
            }
            queue.load();
        }
    }

    /**
     * Disposes(destroys) the loaders
     * @param unload unloads all the loader's contents as well
     */
    public static function disposeAll(unload:Boolean = false):void {
        queue.dispose(unload);
    }

    /** @copy #disposeAll */
    public static function disposeByID(id:String, unload:Boolean = false):void {
        var group:LoadingGroup = loadedGroups[id];
        if(group == null)
            return;

        for each (var loader:LoaderCore in group.loaders) {
            loader.dispose(unload);
        }
    }

    /**
     * Unloads all content(without disposing of loaders)
     */
    public static function unloadAll():void {
        queue.dispose(true);
    }

    /** @copy #unloadAll */
    public static function unloadByID(id:String):void {
        var group:LoadingGroup = loadedGroups[id];
        if(group == null)
            return;

        for each (var loader:LoaderCore in group.loaders) {
            loader.unload();
        }
    }

    //==================================
    //  Tools
    //==================================
    private static function initialize():void {
        if(_initialized) return;
        _initialized = true;
        LoaderMax.activate([SWFLoader, ImageLoader, DataLoader, VideoLoader]);
    }

    private static function get hasElementsWaiting():Boolean {
        return (waitingList.length > 0);
    }

    private static function getExtension(fileName:String):String {
        const ext_regexp:RegExp = /(?:.*)\.(\w+)$/;
        return fileName.replace(ext_regexp, "$1");
    }

    private static function loadNextGroup():LoadingGroup {
        var group:LoadingGroup = waitingList.shift();
        if(group == null)
            return null;

        for each (var loader:LoaderCore in group.loaders) {
            queue.append(loader);
        }
        queue.load();

        return group;
    }

    //==================================
    //  Main Queue Event Handlers
    //==================================
    private static function onOpen                 (e:LoaderEvent):void { dispatcher.dispatchSignalWith(LoaderEvent.OPEN                ); }
    private static function onError                (e:LoaderEvent):void { dispatcher.dispatchSignalWith(LoaderEvent.ERROR               , e.text); }
    private static function onCancel               (e:LoaderEvent):void { dispatcher.dispatchSignalWith(LoaderEvent.CANCEL              ) }
    private static function onIOError              (e:LoaderEvent):void { dispatcher.dispatchSignalWith(LoaderEvent.IO_ERROR            , e.text); }
    private static function onHTTPStatus           (e:LoaderEvent):void { dispatcher.dispatchSignalWith(LoaderEvent.HTTP_STATUS         ); }
    private static function onScriptAccessDenied   (e:LoaderEvent):void { dispatcher.dispatchSignalWith(LoaderEvent.SCRIPT_ACCESS_DENIED); }
    private static function onProgress             (e:LoaderEvent):void {
        var progress:Number = queue.progress;
        if(currentLoadingGroup != null) {
            currentLoadingGroup.callProgress(progress);
        }
        dispatcher.dispatchSignalWith(LoaderEvent.PROGRESS, progress);
    }
    private static function onComplete             (e:LoaderEvent):void {
        //add to finished groups (if it's not a default group) and callback
        if(currentLoadingGroup != null && currentLoadingGroup.id != DEFAULT_GROUP) {
            loadedGroups[currentLoadingGroup.id] = currentLoadingGroup;
            currentLoadingGroup.callComplete();
        }

        if(hasElementsWaiting) {
            currentLoadingGroup = loadNextGroup();
        } else {
            currentLoadingGroup = null;
            dispatcher.dispatchSignalWith(LoaderEvent.COMPLETE);
        }
    }

    //==================================
    //  Child Event Handlers
    //==================================
    private static function onChildOpen            (e:LoaderEvent):void { dispatcher.dispatchSignalWith(LoaderEvent.CHILD_OPEN      , LoaderCore(e.target).name); }
    private static function onChildProgress        (e:LoaderEvent):void { dispatcher.dispatchSignalWith(LoaderEvent.CHILD_PROGRESS  , LoaderCore(e.target).name); }
    private static function onChildComplete        (e:LoaderEvent):void { dispatcher.dispatchSignalWith(LoaderEvent.CHILD_COMPLETE  , LoaderCore(e.target).name); }
    private static function onChildCancel          (e:LoaderEvent):void { dispatcher.dispatchSignalWith(LoaderEvent.CHILD_CANCEL    , LoaderCore(e.target).name); }
    private static function onChildFail            (e:LoaderEvent):void { dispatcher.dispatchSignalWith(LoaderEvent.CHILD_FAIL      , e.text); }
}
}

import com.greensock.loading.core.LoaderCore;

class LoadingGroup {

    private var _id:String;
    public var onComplete:Function;
    public var onProgress:Function;
    public var onCompleteParams:Array;

    public var loaders:Vector.<LoaderCore> = new Vector.<LoaderCore>();

    public function LoadingGroup(id:String) {
        this._id = id;
    }

    public function callComplete():void {
        if(onComplete != null)
            onComplete.call(this, onCompleteParams);
    }

    public function callProgress(progres:Number):void {
        if(onProgress != null)
            onProgress.call(this, progres);
    }

    public function get id():String {
        return _id;
    }
}