/**
 * Created with IntelliJ IDEA.
 * User: filiperp
 * Date: 22/10/13
 * Time: 14:33
 * To change this template use File | Settings | File Templates.
 */
package utils.fileUtils {
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.utils.ByteArray;

internal class Load {
    public function Load() {
    }


    private static var onCompleteLoad:Function;
    private static var onProgressLoad:Function;

    public  static function loadBytesFromFileStream(url:String, onComplete:Function/*Byte Array*/, onProgress:Function):void {
        onCompleteLoad = onComplete;
        onProgressLoad = onProgress;
        var inputFile:File = new File(url);
        var fs:FileStream = new FileStream();
        fs.addEventListener(Event.COMPLETE, onLoadFromFileStream);
        fs.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
        fs.openAsync(inputFile, FileMode.READ);
    }

    private static function onLoadFromFileStream(event:Event):void {
        var fs:FileStream = FileStream(event.target);
        fs.removeEventListener(Event.COMPLETE, onLoadFromFileStream);
        fs.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
        var byteArray:ByteArray = new ByteArray();
        fs.readBytes(byteArray, 0, fs.bytesAvailable);
        onCompleteLoad(byteArray);
    }

    public static function loadBytesFromURLLoader(url:String, onComplete:Function/*Byte Array*/, onProgress:Function):void {
        onCompleteLoad = onComplete;
        onProgressLoad = onProgress;
        var urlLoader:URLLoader = new URLLoader();
        urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
        urlLoader.load(new URLRequest(url));
        urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
        urlLoader.addEventListener(Event.COMPLETE, onLoadFromURLLoader);
    }

    private static function onLoadFromURLLoader(e:Event):void {
        var urlLoader:URLLoader = URLLoader(e.target);
        urlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
        urlLoader.removeEventListener(Event.COMPLETE, onLoadFromURLLoader);
        onCompleteLoad(urlLoader.data);
    }

    public static function  loadSWFromByteArray(bytes:ByteArray,onComplete:Function/*Display Object*/):void {
        onCompleteLoad=onComplete;
        // Prepare the loader context to avoid security error
        var loaderContext:LoaderContext = new LoaderContext();
        loaderContext.allowLoadBytesCodeExecution = true;
        loaderContext.applicationDomain = ApplicationDomain.currentDomain;
       // loaderContext.securityDomain = SecurityDomain.currentDomain;
        loaderContext.allowCodeImport = true;
        // Load the SWF file
        var loader:Loader;
        loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onChildComplete);
        loader.loadBytes(bytes, loaderContext);
    }

    private static function onChildComplete(e:Event):void {
        var li:LoaderInfo = LoaderInfo(e.target);
        li.removeEventListener(Event.COMPLETE, onChildComplete);
        onCompleteLoad(li.content);
    }

    private static function onProgressHandler(e:ProgressEvent):void {
        if (onProgressLoad != null) {
            var p:Number = e.bytesLoaded / e.bytesTotal;
            onProgressLoad(p);
        }
    }

}
}
