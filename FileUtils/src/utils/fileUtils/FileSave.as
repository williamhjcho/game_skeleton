/**
 * Created with IntelliJ IDEA.
 * User: filiperp
 * Date: 22/10/13
 * Time: 15:52
 * To change this template use File | Settings | File Templates.
 */
package utils.fileUtils {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

internal class FileSave {

    internal static function saveByteArray(target:String, data:ByteArray):void{
        var file:File= FileUtilsManager.getFile(target);
        var fileStream:FileStream = new FileStream();
        fileStream.open(file, FileMode.WRITE);
        fileStream.writeBytes(data);
        fileStream.close();
    }
    internal static function saveText(target:String, data:String):void{
        var file:File= FileUtilsManager.getFile(target);
        var fileStream:FileStream = new FileStream();
        fileStream.open(file, FileMode.WRITE);
        fileStream.writeUTFBytes(data);
        fileStream.close();
    }




}
}
