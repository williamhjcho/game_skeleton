/**
 * Created with IntelliJ IDEA.
 * User: filipe
 * Date: 30/01/13
 * Time: 17:12
 * To change this template use File | Settings | File Templates.
 */
package utils.managers {
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.Dictionary;

public class HttpRequestManager {

    private var ldr:URLLoader;

    private var onCompleteRequestFunction:Function;
    private var onIOError:Function;
    private var onSecurityError:Function;

    public function HttpRequestManager() {
        ldr = new URLLoader();
        ldr.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
        ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
        ldr.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
    }

    //==================================
    //  Public
    //==================================
    public function request(url:String, onComplete:Function, inVariables:Dictionary = null, method:String = "POST", onIOError:Function= null, onSecurityError:Function=null):void {
        this.onIOError =   onIOError ;
        this.onSecurityError =   onSecurityError ;
        this.onCompleteRequestFunction = onComplete;
        // var parametros:Object = LoaderInfo(Main.instance.getStage().root.loaderInfo).parameters;
        var variables:URLVariables = new URLVariables();
        var request:URLRequest = new URLRequest(url);
        var k:String , key:String, value:*;
        if (method == "POST") {
            if (inVariables != null) {
                for (k in inVariables) {
                    key = String(k);
                    value = inVariables[k];
                    variables[key] = value;
                    // do stuff
                }
            }
            request.method = URLRequestMethod.POST;
            request.data = variables;
        } else {
            var URLadd:String = "?";
            if (inVariables != null) {
                for (k in inVariables) {
                    key = String(k);
                    value = inVariables[k];
                    URLadd = URLadd.concat(key.toString() + "=" + value.toString() + "&");
                    //variables[key]=value;
                    // do stuff
                }
            }
            URLadd = URLadd.substring(0, URLadd.length - 1);
            request.method = URLRequestMethod.GET;
            url = url + URLadd;
            //request.data = variables;
        }

        ldr.dataFormat = URLLoaderDataFormat.TEXT;
        ldr.addEventListener(Event.COMPLETE, onRequestComplete);
        ldr.load(request);
    }

    //==================================
    //  Events
    //==================================
    private function onRequestComplete(e:Event):void {
        DebuggerManager.debug("[HttpRequestManager]saveCompleteHandler", String(e.target.data), "", "", 0xff0000);
        ldr.removeEventListener(Event.COMPLETE, onRequestComplete);
        var result:String = String(e.target.data);
        onCompleteRequestFunction(result);
    }

    private function httpStatusHandler(e:HTTPStatusEvent):void {
        DebuggerManager.debug("[HttpRequestManager]httpStatusHandler", e.toString(), "", "", 0xff0000);
    }

    private function securityErrorHandler(e:SecurityErrorEvent):void {
        if(this.onSecurityError != null) onSecurityError(e.toString());
        DebuggerManager.debug("[HttpRequestManager]securityErrorHandler", e.toString(), "", "", 0xff0000);
        throw new SecurityError("[HttpRequestManager] " + e.toString());
    }

    private function ioErrorHandler(e:IOErrorEvent):void {
        if(this.onIOError != null) onIOError(e.toString());
        DebuggerManager.debug("[HttpRequestManager] ", e.toString(), "", "", 0xff0000);
    }

}
}
