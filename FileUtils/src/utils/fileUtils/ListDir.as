/**
 * Created with IntelliJ IDEA.
 * User: filiperp
 * Date: 22/10/13
 * Time: 13:11
 * To change this template use File | Settings | File Templates.
 */
package utils.fileUtils {
import flash.events.FileListEvent;
import flash.filesystem.File;

internal class ListDir {

    private static var onCompleteFn:Function;

    internal static function listDir(path:String, onCompleteList:Function):void {
        onCompleteFn = onCompleteList;
        var srcDir:File = File.applicationStorageDirectory.resolvePath("data/assets");
        srcDir.addEventListener(FileListEvent.DIRECTORY_LISTING, listDirHandler);
        srcDir.getDirectoryListingAsync();
    }

    internal static function listDirHandler(event:FileListEvent):void {
        event.target.removeEventListener(FileListEvent.DIRECTORY_LISTING, listDirHandler);
        var contents:Array = event.files;
        var res:Array = [];
        for (var i:uint = 0; i < contents.length; i++) {
            // trace("item z- > ", contents[i].nativePath);
            res.push(contents[i].nativePath)
        }
        onCompleteFn(res);
    }
}
}
