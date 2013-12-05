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

    internal static var onCopyComplete:Function = null;
    internal static var onCopyCompleteParams:Array;

    internal static var onCopyCompleteCopyFiles:Function = null;

    internal static function copyFile(src:String, target:String, onComplete:Function,...onCompleteParams):void {
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
    internal static function copyFiles(fileList:Array,onComplete:Function):void{
        onCopyCompleteCopyFiles = onComplete;
        doCopyFiles(fileList);
    }

    internal static function doCopyFiles(itemsLeft:Array):void {
        if (itemsLeft.length > 0) {
            var item:Object = itemsLeft.shift();
            copyFile(item.path, item.target, doCopyFiles, itemsLeft);
        } else {
            onCopyCompleteCopyFiles();
        }
    }

    internal static function onCopy(event:Event = null):void {
        EventDispatcher(event.target).removeEventListener(Event.COMPLETE, onCopy);
        onCopyComplete.apply(null,onCopyCompleteParams);
    }

    internal static function onCopyError(event:Event = null):void {
        onCopyComplete.apply(null,onCopyCompleteParams);
    }

}

}