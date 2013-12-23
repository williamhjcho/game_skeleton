package utils.fileUtils {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

public class FileUtilsManager {

    //COpyFile
    /**
     * @param src source filesystem path
     * @param target target filesystem path
     * @param onComplete function executed on complete  (onCompleteParams)
     * @param onCompleteParams params past in the onComplete Function
     */
    public static function copyFile(src:String, target:String, onComplete, ...onCompleteParams):void {

        onCompleteParams.unshift(src,target,onComplete);
        CopyFile.copyFile.apply(null,onCompleteParams);
    }

    /**
     *
     * @param fileList  list of files to be copied [{path:"path/original/files.xxx", target: "path/target/file.xxx" }.... ]
     * @param onComplete   calls when copies ends
     */
    public static function copyFiles(fileList:Array,onComplete:Function):void{
        CopyFile.copyFiles(fileList,onComplete);
    }

    /**
     * @param url http file link
     * @param target filesystem path
     * @param onComplete function executed on complete  (success:Boolean)
     * @param onProgress funtion executed on download progress (progress:Number)
     * @param type download mode ( "filestream"|| "urlloader")
     */
    public static function downloadFile(url:String, target:String, onComplete:Function, onProgress:Function,type:String):void {
        switch  (type){
            case "filestream":
                    DownloadFile.downloadFromFileStream(url,target,onComplete,onProgress);
                break;
            case "urlloader":
                DownloadFile.downloadFromURLLoader(url,target,onComplete,onProgress);
                break;
        }
    }

    /**
     *
     * @param src path to file in filesystem
     * @return true if file exists and it is not directory
     */
    public static function checkFileExists(src:String):Boolean {
        return fileExists(src);
    }

    /**
     *
     * @param target filesystem path to save
     * @param data   the text to save
     */
    public static function saveText(target:String, data:String):void{
        FileSave.saveText(target, data);
    }
    /**
     *
     * @param target filesystem path to save
     * @param data   bytes to save
     */
    public static function saveBytes(target:String, data:ByteArray):void{
        FileSave.saveByteArray(target, data);
    }

    /**
     *
     * @param path filesystem path
     * @param onCompleteList function to be executed when list is done. (list:array of string)
     */
    public static function listDir(path:String, onCompleteList:Function):void {
        ListDir.listDir(path, onCompleteList);
    }

    /**
     *
     * @param url path filesystem   ||  web link
     * @param onComplete  function on Complete (bytes:ByteArray)
     * @param onProgress  funtion executed on download progress (progress:Number)
     * @param type   type download mode ( "filestream"|| "urlloader")
     */
    public static function loadBytes(url:String, onComplete:Function, onProgress:Function,type:String):void {
        switch  (type){
            case "filestream":
                Load.loadBytesFromFileStream(url, onComplete, onProgress);
                break;
            case "urlloader":
                Load.loadBytesFromURLLoader(url, onComplete, onProgress);
                break;
        }
    }
    /**
     *
     * @param url path filesystem
     * @param onComplete on Complete Load  (object:DisplayObject)
     * @param onProgress  funtion executed on download progress (progress:Number)
     * @param type   type download mode ( "filestream"|| "urlloader")
     */
    private static var _onCompleteLoadBytesForSWF:Function;
    public static function loadSWFromPath(path:String,onComplete:Function, onProgress:Function,type:String):void {
        _onCompleteLoadBytesForSWF = onComplete;
        loadBytes(path,onLoadBytesForSWF,onProgress,type);
    }
    private static function onLoadBytesForSWF(bytes:ByteArray):void{
          loadSWFromByteArray(bytes,_onCompleteLoadBytesForSWF);
    }

    /**
     *
     * @param bytes  SWF bytes loaded
     * @param onComplete on Complete Load  (object:DisplayObject)
     */
    public static function loadSWFromByteArray(bytes:ByteArray,onComplete:Function):void {
         Load.loadSWFromByteArray(bytes,onComplete)
    }

    /**
     * load text Files
     * @param path filesystem path
     * @return   text content
     */
    public static function loadTextFile(path:String):String{
        var fDataStream:FileStream;
        var textfile:File = getFile(path,false);
        fDataStream = new FileStream();
        fDataStream.open(textfile,FileMode.READ);
        var sContent:String  = fDataStream.readUTFBytes(fDataStream.bytesAvailable);
        fDataStream.close();
        return sContent;
    }
    /**
     * load text Files
     * @param relativePath relative path from application directory
     * @return   text content
     */
    public static  function loadTextFileFromApplicationDirectory(relativePath:String):String{
        return loadTextFile(File.applicationDirectory.nativePath+ "/"+ relativePath);
    }


    /**
     * load text Files
     * @param relativePath relative path from storage directory
     * @return   text content
     */
    public static  function loadTextFileFromStorageDirectory(relativePath:String):String{
        return loadTextFile(File.applicationStorageDirectory.nativePath+ "/"+ relativePath);
    }

    /**
     *
     * @param target path to filesystem
     * @param deleteIfExits delete file in path if exists and create a new one
     * @return the new file object
     *
     */
    public static function getFile(target:String, deleteIfExits:Boolean = true):File {
        var file:File = new File(target);
        if (deleteIfExits && file.exists) {
            // file.addEventListener(Event.COMPLETE, onDeleteFile)
            file.deleteFile();
            file = new File(target);
        }
        return file;
    }






}

}