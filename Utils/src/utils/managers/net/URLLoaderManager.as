/**
 * Created by William on 6/3/2014.
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
import utils.commands.execute;

public class URLLoaderManager {

    private var loader:URLLoader;

    private var _dataFormat :String = URLLoaderDataFormat.TEXT;
    private var _method     :String = URLRequestMethod.POST;
    private var _variables  :Object = null;

    private var _onComplete     :Function = null,
                _onOpen         :Function = null,
                _onProgress     :Function = null,
                _onHttpStatus   :Function = null,
                _onIOError      :Function = null,
                _onSecurityError:Function = null;

    private var _queue:Vector.<Queue> = new Vector.<Queue>();

    public function URLLoaderManager() {
        loader = new URLLoader();
        loader.addEventListener(Event.COMPLETE                     , onEventComplete     );
        loader.addEventListener(Event.OPEN                         , onEventOpen         );
        loader.addEventListener(ProgressEvent.PROGRESS             , onEventProgress     );
        loader.addEventListener(HTTPStatusEvent.HTTP_STATUS        , onEventHttpStatus   );
        loader.addEventListener(IOErrorEvent.IO_ERROR              , onEventIOError      );
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR  , onEventSecurityError);
    }

    //==================================
    //  Get/Set
    //==================================
    public function get progress():Number   { return clamp(loader.bytesLoaded / loader.bytesTotal, 0.0, 1.0); }
    public function get data():*            { return loader.data; }

    //Chain methods
    public function setDataFormat   (s:String = null):URLLoaderManager         { _dataFormat = s || URLLoaderDataFormat.TEXT; return this; }
    public function setMethod       (method:String = null):URLLoaderManager    { _method = method || URLRequestMethod.POST; return this; }
    public function setVariables    (o:Object):URLLoaderManager                { _variables = o; return this; }

    public function setOnComplete     (f:Function):URLLoaderManager { _onComplete      = f; return this; }
    public function setOnOpen         (f:Function):URLLoaderManager { _onOpen          = f; return this; }
    public function setOnProgress     (f:Function):URLLoaderManager { _onProgress      = f; return this; }
    public function setOnHttpStatus   (f:Function):URLLoaderManager { _onHttpStatus    = f; return this; }
    public function setOnIOError      (f:Function):URLLoaderManager { _onIOError       = f; return this; }
    public function setOnSecurityError(f:Function):URLLoaderManager { _onSecurityError = f; return this; }

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

        var queue:Queue         = new Queue();
        queue.urlRequest        = urlRequest        ;
        queue.dataFormat        = _dataFormat       ;
        queue.onComplete        = _onComplete       ;
        queue.onOpen            = _onOpen           ;
        queue.onProgress        = _onProgress       ;
        queue.onHttpStatus      = _onHttpStatus     ;
        queue.onIOError         = _onIOError        ;
        queue.onSecurityError   = _onSecurityError  ;

        _queue.push(queue);
        if(_queue.length == 1)
            loadQueue(queue);
    }

    public function close():void {
        loader.close();
    }

    //==================================
    //  Private
    //==================================
    private function loadQueue(queue:Queue):void {
        loader.dataFormat = queue.dataFormat;
        loader.load(queue.urlRequest);
    }

    //==================================
    //  Events
    //==================================
    private function onEventOpen         (e:Event                ):void { execute(_queue[0].onOpen         , [e]);  }
    private function onEventProgress     (e:ProgressEvent        ):void { execute(_queue[0].onProgress     , [e]);  }
    private function onEventHttpStatus   (e:HTTPStatusEvent      ):void { execute(_queue[0].onHttpStatus   , [e]);  }
    private function onEventIOError      (e:IOErrorEvent         ):void { execute(_queue[0].onIOError      , [e]);  }
    private function onEventSecurityError(e:SecurityErrorEvent   ):void { execute(_queue[0].onSecurityError, [e]);  }
    private function onEventComplete     (e:Event                ):void {
        var queue:Queue = _queue.shift();
        execute(queue.onComplete, [loader.data]);
        if(_queue.length > 0) {
            loadQueue(_queue[0]);
        }
    }

}
}

import flash.net.URLRequest;

class Queue {
    public var urlRequest       :URLRequest;
    public var dataFormat       :String;
    public var onOpen           :Function;
    public var onProgress       :Function;
    public var onHttpStatus     :Function;
    public var onIOError        :Function;
    public var onSecurityError  :Function;
    public var onComplete       :Function;
}