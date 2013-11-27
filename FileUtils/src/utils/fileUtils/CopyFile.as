/**
 * Created with IntelliJ IDEA.
 * User: filiperp
 * Date: 22/10/13
 * Time: 13:08
 * To change this template use File | Settings | File Templates.
 */
package utils.fileUtils {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;

internal  class CopyFile {

    private static var onCopyComplete:Function = null;
    private static var onCopyCompleteParams:Array;

    private static var onCopyCompleteCopyFiles:Function = null;

    public static function copyFile(src:String, target:String, onComplete:Function,...onCompleteParams):void {
        onCopyComplete = onComplete;
        onCopyCompleteParams = onCompleteParams;
        //File.applicationStorageDirectory.resolvePath(item.destinationPath);
        var original:File = FileUtilsManager.getFile(src,false);
        var destination:File = FileUtilsManager.getFile(target);

        if (original.exists) {
            original.addEventListener(Event.COMPLETE, onCopy);
            original.copyToAsync(destination, true);
        } else {
            trace("copyFile File original :\"" + original.nativePath + "\" does not exist.");
            onCopyError();
        }
    }
    public static function copyFiles(fileList:Array,onComplete:Function):void{
        onCopyCompleteCopyFiles = onComplete;
        doCopyFiles(fileList);
    }

    private static function doCopyFiles(itemsLeft:Array):void {
        if (itemsLeft.length > 0) {
            var item:Object = itemsLeft.shift();
            copyFile(item.path, item.target, doCopyFiles, itemsLeft);
        } else {
            onCopyCompleteCopyFiles();
        }
    }

    private static function onCopy(event:Event = null):void {
        EventDispatcher(event.target).removeEventListener(Event.COMPLETE, onCopy);
        onCopyComplete.apply(null,onCopyCompleteParams);
    }

    private static function onCopyError(event:Event = null):void {
        onCopyComplete.apply(null,onCopyCompleteParams);
    }

}

}