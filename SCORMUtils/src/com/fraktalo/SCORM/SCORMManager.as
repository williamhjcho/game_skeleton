package com.fraktalo.SCORM {
import com.fraktalo.SCORM.events.ScormEventCommit;
import com.fraktalo.SCORM.events.ScormEventInitialize;
import com.fraktalo.SCORM.events.ScormEventTerminate;
import com.fraktalo.SCORM.vo.CMI;

import flash.events.EventDispatcher;

import utils.managers.serializer.SerializerManager;

/**
 * @author filiperp
 */
public class SCORMManager extends EventDispatcher {
    public static var debugFunctionFn:Function;
    public var lockGameFunction:Function;
    public var core:ICore;

    public static const INITIALIZED:String = "inicialized";
    public static const TERMINATED:String = "terminated";
    public var currentCoreStatus:String = "";

    public var cmi:CMI;


    public function initialize(debugFunction:Function, offlineContentJSON:String, lockScreen:Function):void {
        debugFunctionFn = debugFunction;
        lockGameFunction = lockScreen;
        if (currentCoreStatus != INITIALIZED) {
            currentCoreStatus = INITIALIZED;
            if (offlineContentJSON == "") {
                core = new CoreSCO(onInitializeEvent, onCommitEvent, onTerminateEvent);
            } else {
                core = new CoreStandAlone(offlineContentJSON, onInitializeEvent, onCommitEvent, onTerminateEvent);
            }
            this.core.initialize();
        }
    }

    public function showLockScreen(visible:Boolean = false):void {
        if (lockGameFunction != null) {
            this.lockGameFunction.apply(this, [visible]);
        }
    }

    private function onInitializeEvent(typedJson:String):void {
        debug("wrapper SCORMManager, ", typedJson);
        var o:Object = SerializerManager.JSONparse(typedJson);
        cmi = SerializerManager.decode(o) as CMI;
        showLockScreen(false);
        this.dispatchEvent(new ScormEventInitialize());
    }

    public function commit():void {
        var o:Object = SerializerManager.encode(cmi);
        if (currentCoreStatus == INITIALIZED) {
            debug("COMMIT ");
            this.core.commit(SerializerManager.JSONstringfy(o));
        }
    }

    private function onCommitEvent(typedJSON:String):void {
        debug("wrapper onCommitEvent ", "");
        this.dispatchEvent(new ScormEventCommit(typedJSON));
    }

    public function terminate():void {
        debug("terminate 1 a", this.core);
        if (currentCoreStatus == INITIALIZED) {
            this.core.terminate();
            currentCoreStatus = TERMINATED;
        }
    }

    private function onTerminateEvent():void {
        this.dispatchEvent(new ScormEventTerminate());
        showLockScreen(false);
    }

    public static function debug(msg:String, obj:Object = null):void {
        if (debugFunctionFn != null)
            debugFunctionFn.apply(null, [ msg, obj ]);
    }

}
}
