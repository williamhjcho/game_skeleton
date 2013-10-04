package com.fraktalo.SCORM {
import com.fraktalo.SCORM.vo.CMI;
import com.fraktalo.SCORM.vo.Objective;

import flash.external.ExternalInterface;
import flash.system.Security;
import flash.system.SecurityDomain;

import utils.managers.serializer.SerializerManager;

/**
 * @author filipe.pereira
 */
public class CoreSCO implements ICore {
    private var typedCMIJSON:String;
    public var onInitializeFn:Function;
    public var onCommitFn:Function;
    public var onTerminateFn:Function;

    public function CoreSCO(onInitialize:Function, onCommit:Function, onTerminate:Function) {
        Security.allowDomain(SecurityDomain.currentDomain);
        Wrapper.staticDebug("CoreSCO",onInitialize)
        ExternalInterface.addCallback("initialized", retrieveInitialized);
        ExternalInterface.addCallback("commited", retrieveCommited);
        ExternalInterface.addCallback("terminated", retrieveTerminated);

        this.onInitializeFn = onInitialize;
        this.onCommitFn = onCommit;
        this.onTerminateFn = onTerminate;

    }

    public function initialize():void {
        Wrapper.staticDebug("CoreSCO initialize","")
        ExternalInterface.call("initialize");

    }

    public function commit(typedJSON:String):void {
        //Core
        Wrapper.staticDebug("CoreSCO commit","")
        this.typedCMIJSON = typedCMIJSON;
        var o:Object = SerializerManager.JSONparse(typedJSON);
        var cmi:CMI = SerializerManager.decode(o) as CMI;
        setLessonLocation(cmi.core.lesson_location);
        setLessonStatus(cmi.core.lesson_status);
        setScoreMax(cmi.core.score.max);
        setScoreMin(cmi.core.score.min);
        setScoreRaw(cmi.core.score.raw);
        setSuspendData(cmi.suspend_data);
        setComments(cmi.comments);
        for (var i:int = 0; i < cmi.objectives.length; i++) {
            setObjectiveId(i, (cmi.objectives[i] as Objective).id);
            setObjectiveScoreMax(i, (cmi.objectives[i] as Objective).score.max);
            setObjectiveScoreMin(i, (cmi.objectives[i] as Objective).score.min);
            setObjectiveScoreRaw(i, (cmi.objectives[i] as Objective).score.raw);
            setObjectiveStatus(i, (cmi.objectives[i] as Objective).status);
        }
        ExternalInterface.call("commit");
    }

    public function terminate():void {
        ExternalInterface.call("exit");
    }

    public function retrieveCommited():void {
        onCommitFn(typedCMIJSON);
    }

    public function retrieveTerminated():void {
        onTerminateFn();
    }

    public function retrieveInitialized(untypedJSON:String):void {
        this.typedCMIJSON = convertUntypedJSONtoTypedJSON(untypedJSON);
        Wrapper.staticDebug("CoreSCO retrieveInitialized","");
        onInitializeFn(typedCMIJSON);
    }

    private static function setLessonLocation(str:String):void {
        ExternalInterface.call("setCoreLessonLocation", str);
    }

    private static function setLessonStatus(str:String):void {
        ExternalInterface.call("setCoreLessonStatus", str);
    }

    private static function setScoreRaw(str:String):void {
        ExternalInterface.call("setCoreScoreRaw", str);
    }

    private static function setScoreMax(str:String):void {
        ExternalInterface.call("setCoreScoreMax", str);
    }

    private static function setScoreMin(str:String):void {
        ExternalInterface.call("setCoreScoreMin", str);
    }

    private static function setSuspendData(str:String):void {
        ExternalInterface.call("setCoreSuspendData", str);
    }

    private static function setComments(str:String):void {
        ExternalInterface.call("setCoreComments", str);
    }

    private static function setObjectiveId(index:int, id:String):void {
        ExternalInterface.call("setCoreObjectiveId", index, id);
    }

    private static function setObjectiveScoreMax(index:int, str:String):void {
        ExternalInterface.call("setCoreObjectiveScoreMax", index, str);
    }

    private static function setObjectiveScoreMin(index:int, str:String):void {
        ExternalInterface.call("setCoreObjectiveScoreMin", index, str);
    }

    private static function setObjectiveScoreRaw(index:int, str:String):void {
        ExternalInterface.call("setCoreObjectiveScoreRaw", index, str);
    }

    private static function setObjectiveStatus(index:int, str:String):void {
        ExternalInterface.call("setCoreObjectiveStatus", index, str);
    }

}
}
