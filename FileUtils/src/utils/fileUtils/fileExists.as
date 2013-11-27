package utils.fileUtils {
import flash.filesystem.File;

internal function fileExists(src:String):Boolean {
    var original:File = FileUtilsManager.getFile(src,false);
    return (original != null && (original.exists) && (!original.isDirectory));
}


}