package utils {

/**
 * @author filiperp / bona
 */

import com.greensock.events.LoaderEvent;
import com.greensock.loading.*;

import flash.utils.Dictionary;

public class AssetsManager {

    private static var _isInitialized:Boolean = false;
    private static var queue:LoaderMax = new LoaderMax({name: "mainQueue", onProgress: progressHandler, onComplete: completeHandler, onError: errorHandler, maxConnections: 1, skipFailed: false, auditSize: true });

    private static var _showProgress:Function = null;
    private static var _onError     :Function = null;
    private static var _onComplete  :Function = null;

    private static var externalLoaders:Dictionary = new Dictionary();

    public static function initialize():void {
        LoaderMax.activate([ImageLoader, SWFLoader, DataLoader, MP3Loader]);
        //queue.prependURLs(Main.instance.returnPath(), true);
        _isInitialized = true;
    }

    /** Single Load **/
    public static function loadSWFAsset(urlOrRequest:*, params:Object, showProgress:Function = null, onError:Function = null):void {
        singleLoadCore(SWFLoader, urlOrRequest, params, showProgress, onError);
    }

    public static function loadXMLAssets(urlOrRequest:*, params:Object, showProgress:Function = null, onError:Function = null):void {
        singleLoadCore(XMLLoader, urlOrRequest, params, showProgress, onError);
    }

    public static function loadDataAssets(urlOrRequest:*, params:Object, showProgress:Function = null, onError:Function = null):void {
        singleLoadCore(DataLoader, urlOrRequest, params, showProgress, onError);
    }

    public static function loadMP3Assets(urlOrRequest:*, params:Object, showProgress:Function = null, onError:Function = null):void {
        singleLoadCore(MP3Loader, urlOrRequest, params, showProgress, onError);
    }

    public static function loadImageAssets(urlOrRequest:*, params:Object, showProgress:Function = null, onError:Function = null):void {
        singleLoadCore(ImageLoader, urlOrRequest, params, showProgress, onError);
    }

    public static function loadVideoAssets(urlOrRequest:*, params:Object, showProgress:Function = null, onError:Function = null):void {
        singleLoadCore(VideoLoader, urlOrRequest, params, showProgress, onError);
    }

    private static function singleLoadCore(loaderClass:Class, urlOrRequest:*, params:Object, pf:Function, ef:Function):void {
        if(!_isInitialized) initialize();
        _showProgress = pf;
        _onError = ef;
        queue.append(new loaderClass(urlOrRequest, params));
        queue.load()
    }
    
    /** Group Load **/
    public static function openGroupLoad(showProgress:Function = null, onComplete:Function = null, onError:Function = null):void {
        if(!_isInitialized) initialize();
        _showProgress = showProgress;
        _onComplete = onComplete;
        _onError = onError;
    }

    public static function closeGroupLoad():void {
        if(!_isInitialized) initialize();
        queue.load();
    }

    public static function appendSWF    (urlOrRequest:*, params:Object):void { groupLoadCore(SWFLoader, urlOrRequest, params); }
    public static function appendXML    (urlOrRequest:*, params:Object):void { groupLoadCore(XMLLoader, urlOrRequest, params); }
    public static function appendData   (urlOrRequest:*, params:Object):void { groupLoadCore(DataLoader, urlOrRequest, params); }
    public static function appendMP3    (urlOrRequest:*, params:Object):void { groupLoadCore(MP3Loader, urlOrRequest, params); }
    public static function appendImage  (urlOrRequest:*, params:Object):void { groupLoadCore(ImageLoader, urlOrRequest, params); }
    public static function appendVideo  (urlOrRequest:*, params:Object):void { groupLoadCore(VideoLoader, urlOrRequest, params); }

    private static function groupLoadCore(loaderClass:Class, urlOrRequest:*, params:Object):void {
        if(!_isInitialized) initialize();
        queue.append(new loaderClass(urlOrRequest, params));
    }


    public static function loadList(list:Array, commonPath:String = "", showProgress:Function = null, onComplete:Function = null, onError:Function = null):void {
        if(!_isInitialized) initialize();
        openGroupLoad(showProgress, onComplete, onError);

        for (var i:int = 0; i < list.length; i++) {
            var asset:String = list[i];
            var matchIndex:int = asset.search(/[^\.]*$/);
            var matchNameIndex:int;
            var extension:String;
            if(matchIndex == 0) {
                extension = "";
                matchNameIndex = asset.length;
            } else {
                extension = asset.substring(matchIndex);
                matchNameIndex = matchIndex-1;
            }

            var f:Function = null;
            switch (extension) {
                case null:
                    f = null;
                    break;
                case "swf":
                    f = appendSWF;
                    break;
                case "mp3":
                    f = appendMP3;
                    break;
                case "jpg":
                case "png":
                case "jpeg":
                    f = appendImage;
                    break;
                case "xml":
                    f = appendXML;
                    break;
                case "txt":
                case "json":
                default :
                    f = appendData;
            }
            if(f != null)
                f.call(null, commonPath + asset, {name: asset.substring(0,matchNameIndex), autoPlay: false});
        }

        closeGroupLoad();
    }

    /** Specific Load/Loader **/
    public static function loadExternalLoader(loaderName:String, vars:Object):void {
        var loader:LoaderMax = LoaderMax.getLoader(loaderName);
        loader.vars = vars;
        loader.addEventListener(LoaderEvent.COMPLETE, onLoadExternalComplete);
        loader.load();
    }

    private static function onLoadExternalComplete(e:LoaderEvent):void {
        var loader:LoaderMax = e.target as LoaderMax;
        loader.removeEventListener(LoaderEvent.COMPLETE, onLoadExternalComplete);
        var f:Function = loader.vars.onComplete;
        if(f != null) f.call(null,e);
    }
    
    
    /** Handlers **/
    public static function progressHandler(e:LoaderEvent):void {
        if (_showProgress != null) {
            _showProgress(e.target.progress);
        }
        //trace("progress: " + e.target.progress);
    }

    public static function completeHandler(e:LoaderEvent):void {
        if(_onComplete != null) _onComplete(e);
        _showProgress = null;
        _onError      = null;
        _onComplete   = null;
    }

    public static function errorHandler(e:LoaderEvent):void {
        if (_onError != null) _onError(e);
    }

}

}

