package com.fraktalo.SCORM {
/**
 * @author filipe.pereira
 */
public class CoreStandAlone implements ICore {

    private var typedCMIJSON:String;

    public var onInitializeFn:Function;
    public var onCommitFn:Function;
    public var onTerminateFn:Function;

    public function CoreStandAlone(typedCMIJSON:String, onInitialize:Function, onCommit:Function, onTerminate:Function):void {


        this.typedCMIJSON = typedCMIJSON;

        this.onInitializeFn = onInitialize;
        this.onCommitFn = onCommit;
        this.onTerminateFn = onTerminate;
    }

    public function initialize():void {
        retrieveInitialized(typedCMIJSON);
    }

    public function terminate():void {
        this.retrieveTerminated();
    }

    public function commit(typedJSON:String):void {
        this.typedCMIJSON = typedJSON;
        this.retrieveCommited();
    }

    public function retrieveCommited():void {
        onCommitFn(typedCMIJSON);
    }

    public function retrieveTerminated():void {
        onTerminateFn();
    }

    public function retrieveInitialized(typedJSON:String):void {
        onInitializeFn(typedJSON);
    }
}
}
