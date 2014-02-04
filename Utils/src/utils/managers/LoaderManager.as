package utils.managers {

/**
 * @author filiperp / bona
 */

import com.greensock.events.LoaderEvent;
import com.greensock.loading.*;

import flash.errors.IllegalOperationError;

/**
 * Loads assets and manages it's loaders (greensock)
 */
public class LoaderManager {

    private static var _isInitialized:Boolean = initialize();
    private static var queue:LoaderMax = new LoaderMax({name: "mainQueue", onProgress: progressHandler, onComplete: completeHandler, onError: errorHandler, maxConnections: 1, skipFailed: false, auditSize: true });

    private static var _isGroupOpen :Boolean = false;
    private static var _onProgress  :Function = null;
    private static var _onError     :Function = null;
    private static var _onComplete  :Function = null;

    public static function initialize():Boolean {
        if(_isInitialized) return true;
        _isInitialized = true;
        LoaderMax.activate([ImageLoader, SWFLoader, DataLoader, MP3Loader]);
        //queue.prependURLs(Main.instance.returnPath(), true);
        return true;
    }

    public static function getLoader(nameOrURL:String):* {
        return queue.getLoader(nameOrURL);
    }

    public static function getContent(nameOrURL:String):* {
        return queue.getContent(nameOrURL);
    }

    //==================================
    //  Single Loads
    //==================================
    public static function loadSWF(urlOrRequest:*, params:Object, onComplete:Function = null, onProgress:Function = null, onError:Function = null):void {
        singleLoadCore(SWFLoader, urlOrRequest, params, onComplete, onProgress, onError);
    }

    public static function loadXML(urlOrRequest:*, params:Object, onComplete:Function = null, onProgress:Function = null, onError:Function = null):void {
        singleLoadCore(XMLLoader, urlOrRequest, params, onComplete, onProgress, onError);
    }

    public static function loadData(urlOrRequest:*, params:Object, onComplete:Function = null, onProgress:Function = null, onError:Function = null):void {
        singleLoadCore(DataLoader, urlOrRequest, params, onComplete, onProgress, onError);
    }

    public static function loadMP3(urlOrRequest:*, params:Object, onComplete:Function = null, onProgress:Function = null, onError:Function = null):void {
        singleLoadCore(MP3Loader, urlOrRequest, params, onComplete, onProgress, onError);
    }

    public static function loadImage(urlOrRequest:*, params:Object, onComplete:Function = null, onProgress:Function = null, onError:Function = null):void {
        singleLoadCore(ImageLoader, urlOrRequest, params, onComplete, onProgress, onError);
    }

    public static function loadVideo(urlOrRequest:*, params:Object, onComplete:Function = null, onProgress:Function = null, onError:Function = null):void {
        singleLoadCore(VideoLoader, urlOrRequest, params, onComplete, onProgress, onError);
    }

    private static function singleLoadCore(loaderClass:Class, urlOrRequest:*, params:Object, cf:Function, pf:Function, ef:Function):void {
        initialize();
        _onComplete = cf;
        _onProgress = pf;
        _onError = ef;
        queue.append(new loaderClass(urlOrRequest, params));
        queue.load();
    }

    //==================================
    //  Multiple Loads
    //==================================
    public static function openGroupLoad(onComplete:Function = null, onProgress:Function = null, onError:Function = null):void {
        if(!_isInitialized) initialize();
        _isGroupOpen = true;
        _onComplete = onComplete;
        _onProgress = onProgress;
        _onError = onError;
    }

    public static function closeGroupLoad():void {
        if(!_isInitialized) initialize();
        if(!_isGroupOpen) throw new IllegalOperationError("Use openGroupLoad() first.");
        _isGroupOpen = false;
        queue.load();
    }

    public static function appendSWF    (urlOrRequest:*, params:Object):void { groupLoadCore(SWFLoader, urlOrRequest, params); }
    public static function appendXML    (urlOrRequest:*, params:Object):void { groupLoadCore(XMLLoader, urlOrRequest, params); }
    public static function appendData   (urlOrRequest:*, params:Object):void { groupLoadCore(DataLoader, urlOrRequest, params); }
    public static function appendMP3    (urlOrRequest:*, params:Object):void { groupLoadCore(MP3Loader, urlOrRequest, params); }
    public static function appendImage  (urlOrRequest:*, params:Object):void { groupLoadCore(ImageLoader, urlOrRequest, params); }
    public static function appendVideo  (urlOrRequest:*, params:Object):void { groupLoadCore(VideoLoader, urlOrRequest, params); }

    private static function groupLoadCore(loaderClass:Class, urlOrRequest:*, params:Object):void {
        initialize();
        if(!_isGroupOpen) throw new IllegalOperationError("Use openGroupLoad() first.");
        queue.append(new loaderClass(urlOrRequest, params));
    }

    public static function loadList(list:*, commonPath:String = "", onComplete:Function = null, onProgress:Function = null, onError:Function = null):void {
        if(!_isInitialized) initialize();

        openGroupLoad(onComplete, onProgress, onError);

        for each (var asset:String in list) {
            var matchIndex:int = asset.search(/[^\.]*$/);
            var extension:String = (matchIndex == 0)? null : asset.substring(matchIndex);
            switch (extension) {
                case null:      break;
                case "swf":     appendSWF(commonPath + asset, {name:asset, autoPlay:false}); break;
                case "mp3":     appendMP3(commonPath + asset, {name:asset, autoPlay:false}); break;
                case "mp4":
                case "wmv":
                case "mpeg":
                case "flv":
                case "mkv":     appendVideo(commonPath + asset, {name:asset, autoPlay:false}); break;
                case "jpg":
                case "png":
                case "jpeg":    appendImage(commonPath + asset, {name:asset, autoPlay:false}); break;
                case "xml":     appendXML(commonPath + asset, {name:asset, autoPlay:false}); break;
                case "txt":
                case "json":
                default :       appendData(commonPath + asset, {name:asset, autoPlay:false});
            }
        }

        closeGroupLoad();
    }

    //==================================
    //  Specific Load/Loader
    //==================================
    /**
     * Gets and loader by it's name and loads what else is inside it
     * @param loaderName
     * @param vars
     */
    public static function loadByName(loaderName:String, vars:Object):void {
        var loader:LoaderMax = LoaderMax.getLoader(loaderName);
        if(loader == null)
            throw new ArgumentError("Loader with name \""+loaderName+"\" not found.");
        loader.vars = vars;
        loader.addEventListener(LoaderEvent.COMPLETE, onLoadComplete);
        loader.load();
    }

    private static function onLoadComplete(e:LoaderEvent):void {
        var loader:LoaderMax = e.target as LoaderMax;
        loader.removeEventListener(LoaderEvent.COMPLETE, onLoadComplete);
        var f:Function = loader.vars.onComplete;
        if(f != null) f.call(null,e);
    }


    //==================================
    //  Handlers
    //==================================
    public static function progressHandler(e:LoaderEvent):void {
        if (_onProgress != null) _onProgress(e.target.progress);
    }

    public static function completeHandler(e:LoaderEvent):void {
        var complete:Function = _onComplete; //this is to counter the effects of nested functions
        _onComplete   = null;
        _onProgress   = null;
        _onError      = null;
        if(complete != null) complete(e);
    }

    public static function errorHandler(e:LoaderEvent):void {
        if (_onError != null) _onError(e);
    }

}

}

