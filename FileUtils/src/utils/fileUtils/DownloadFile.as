/**
 * Created with IntelliJ IDEA.
 * User: filiperp
 * Date: 22/10/13
 * Time: 13:21
 * To change this template use File | Settings | File Templates.
 */
package utils.fileUtils {
import flash.events.ProgressEvent;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

internal  class DownloadFile {

    private static var targetURL:String;
    private static var onCompleteLoad:Function;
    private static var onProgressLoad:Function;

    internal static function downloadFromFileStream(url:String, target:String, onComplete:Function, onProgress:Function):void {
        onCompleteLoad =  onComplete
        targetURL = target;
        Load.loadBytesFromFileStream(url, completedFromFileStream, onProgress);
    }

    internal static function completedFromFileStream(bytes:ByteArray):void {
        writeFile(bytes);
    }

    internal static function downloadFromURLLoader(url:String, target:String, onComplete:Function, onProgress:Function):void {
        onCompleteLoad =  onComplete
        targetURL = target;
        Load.loadBytesFromURLLoader(url, urlLoaderCompleteHandler, onProgress)
    }

    internal static function urlLoaderCompleteHandler(bytes:ByteArray):void {
        writeFile(bytes);
    }

    internal static function writeFile(data:ByteArray):void {
        var bytes:ByteArray = data;
        var fileStream:FileStream = new FileStream();
        fileStream.open(FileUtilsManager.getFile(targetURL), FileMode.WRITE);
        fileStream.writeBytes(bytes);
        fileStream.close();
        onCompleteLoad(true)
    }

    internal static function onProgressHandler(e:ProgressEvent):void {
        if (onProgressLoad != null) {
            var p:Number = e.bytesLoaded / e.bytesTotal;
            onProgressLoad(p);
        }
    }
}
}
