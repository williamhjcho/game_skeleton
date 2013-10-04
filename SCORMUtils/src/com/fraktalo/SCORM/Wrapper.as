package com.fraktalo.SCORM {
import com.fraktalo.SCORM.events.ScormEventCommit;
import com.fraktalo.SCORM.events.ScormEventMessage;

import flash.events.EventDispatcher;
import flash.utils.setTimeout;

/**
 * @author filipe.pereira
 */
public class Wrapper extends EventDispatcher {

    public static var debugFunctionFn:Function;
    public var core:ICore;
    public var connection:WrapperConnection;

    public static const SEPARATOR:String = "$#";

    public static const INITIALIZED:String = "inicialized";
    public static const TERMINATED:String = "terminated";
    public var  currentCoreStatus:String = "";


    public function Wrapper() {

    }

    public function initWrapper(debugFunction:Function, offlineContentJSON:String):void {

        Wrapper.debugFunctionFn = debugFunction;

        if (!connection) {
            connection = new WrapperConnection(this);
        }

        if (offlineContentJSON == "") {
            core = new CoreSCO(onInitializeEvent,onCommitEvent,onTerminateEvent);

        } else {
            core = new CoreStandAlone(offlineContentJSON,onInitializeEvent,onCommitEvent,onTerminateEvent);
        }


        trace("fffffdas1")
    }

    public function findWrapper():void {
        trace("WRAPPER - onFined")
        connection.sendMethod("onFindWrapper");
    }

    public function initialize():void {

        debug("Initialize 1 avfd", this.core);
        if (currentCoreStatus != INITIALIZED) {
            currentCoreStatus = INITIALIZED;
            this.core.initialize();

        }

    }
    private function onInitializeEvent(typedJson:String):void {

        debug("wrapper onInitializeEvent, ",typedJson);
        connection.sendMethod("onInitialize", typedJson);
    }

    public function commit(typedJSON:String):void {
        debug("COMMIT ", typedJSON);
        if (currentCoreStatus == INITIALIZED) {
            this.core.commit(typedJSON);
        }
    }

    private function onCommitEvent(typedJSON:String):void {
        debug("wrapper onCommitEvent ","");
        this.dispatchEvent(new ScormEventCommit(typedJSON));
        connection.sendMethod("onCommit",typedJSON);
    }

    public function terminate():void {
        debug("terminate 1 a", this.core);
        if (currentCoreStatus == INITIALIZED){
            this.core.terminate();
            currentCoreStatus = TERMINATED;
        }

    }
    private function onTerminateEvent():void {
        debug("wrapper onTerminate ", "onTerminate");
        connection.sendMethod("onTerminate");
        try {
            setTimeout(connection.close,1000);
            trace("wrapper connection close")
        }
        catch (E:Error) {
            debug("on close error", E.message);
        }
    }

    public function sendMessage(msg:String):void {
        connection.sendMethod("onSendMessage", msg);
    }

    public function onSendMessage(msg:String):void {
        debug("onSendMessage", msg);
        this.dispatchEvent(new ScormEventMessage(msg));
    }



    public  function debug(msg:String, obj:Object = null):void {
        staticDebug(msg, obj);


    }
    public static function  staticDebug(msg:String, obj:Object = null):void {
        if (debugFunctionFn != null)
            debugFunctionFn.apply(null, [ msg, obj ]);

    }



}
}
