/**
 * Created with IntelliJ IDEA.
 * User: filipe
 * Date: 30/01/13
 * Time: 17:12
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.net {
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import utils.commands.clamp;

public class HttpRequestManager {

    private var loader:URLLoader = new URLLoader();

    private var _dataFormat :String = URLLoaderDataFormat.TEXT;
    private var _method     :String = URLRequestMethod.POST;
    private var _variables  :Object = null;

    private var _onComplete :Function = null,
            _onOpen         :Function = null,
            _onProgress     :Function = null,
            _onHttpStatus   :Function = null,
            _onIOError      :Function = null,
            _onSecurityError:Function = null;

    public function HttpRequestManager() {

    }

    //==================================
    //  Get/Set
    //==================================
    public function get progress():Number   { return clamp(loader.bytesLoaded / loader.bytesTotal, 0.0, 1.0); }
    public function get data():*            { return loader.data; }

    //Chain methods
    public function setDataFormat   (s:String = null):HttpRequestManager         { _dataFormat = s || URLLoaderDataFormat.TEXT; return this; }
    public function setMethod       (method:String = null):HttpRequestManager    { _method = method || URLRequestMethod.POST; return this; }
    public function setVariables    (o:Object):HttpRequestManager                { _variables = o; return this; }

    public function setOnComplete     (f:Function):HttpRequestManager { removeThenAdd(Event.COMPLETE                     , _onComplete      , f); _onComplete      = f; return this; }
    public function setOnOpen         (f:Function):HttpRequestManager { removeThenAdd(Event.OPEN                         , _onOpen          , f); _onOpen          = f; return this; }
    public function setOnProgress     (f:Function):HttpRequestManager { removeThenAdd(ProgressEvent.PROGRESS             , _onProgress      , f); _onProgress      = f; return this; }
    public function setOnHttpStatus   (f:Function):HttpRequestManager { removeThenAdd(HTTPStatusEvent.HTTP_STATUS        , _onHttpStatus    , f); _onHttpStatus    = f; return this; }
    public function setOnIOError      (f:Function):HttpRequestManager { removeThenAdd(IOErrorEvent.IO_ERROR              , _onIOError       , f); _onIOError       = f; return this; }
    public function setOnSecurityError(f:Function):HttpRequestManager { removeThenAdd(SecurityErrorEvent.SECURITY_ERROR  , _onSecurityError , f); _onSecurityError = f; return this; }

    //==================================
    //  Public
    //==================================
    public function load(url:String):void {
        var urlVars:URLVariables = new URLVariables();
        var urlRequest:URLRequest = new URLRequest(url);
        urlRequest.method = _method;

        var property:String;
        switch(_method) {
            case URLRequestMethod.POST: {
                //both classes are dynamic
                for (property in _variables) {
                    urlVars[property] = _variables[property];
                }
                urlRequest.data = urlVars;
                break;
            }
            case URLRequestMethod.GET: {
                var suffixes:Vector.<String> = new Vector.<String>();
                for (property in _variables) {
                    suffixes.push(property + '=' + Object(_variables[property]).toString());
                }
                urlRequest.url += suffixes.join('&');
                break;
            }
            case URLRequestMethod.DELETE:
            case URLRequestMethod.HEAD:
            case URLRequestMethod.OPTIONS:
            case URLRequestMethod.PUT:
            case null: throw new ArgumentError("Method not recognized: \"" + _method + "\"."); break;
        }

        loader.dataFormat = _dataFormat;
        loader.load(urlRequest)
    }

    public function close():void {
        loader.close();
    }

    //==================================
    //  Private
    //==================================
    private function removeThenAdd(event:String, fPrev:Function, fNext:Function):void {
        if(fPrev != null) loader.removeEventListener(event, fPrev);
        if(fNext != null) loader.addEventListener(event, fNext);
    }
}
}
