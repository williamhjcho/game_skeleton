package com.fraktalo.SCORM {
import flash.events.AsyncErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.StatusEvent;
import flash.net.LocalConnection;

import utils.managers.DebuggerManager;

/**
 * @author filipe.pereira
 */
public class WrapperConnection extends LocalConnection {
    private const LINE_IN:String = SCORMChannelKeys.WRAPPER_KEY;
    private const LINE_OUT:String =SCORMChannelKeys.SOCKET_KEY;

    public function WrapperConnection(client:Wrapper) {

        super();
        this.client = client;

        this.allowDomain("*");
        this.allowInsecureDomain("*");
        try {
            this.connect(LINE_IN);
        } catch (E:Error) {
        }

        this.addEventListener(StatusEvent.STATUS, onStatus);
        this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
        this.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
    }

    public function sendMethod(method:String, ...vars):void {

        //vars.unshift(method);
        //vars.unshift(LINE_OUT);
        var arr:Array =[LINE_OUT,method].concat(vars);

        try {
            this.send.apply(this, arr);


            vars.unshift("Sent from: WrapperConnetion");
            DebuggerManager.debug("WrapperConnection vars", arr);

        }
        catch (e:Error) {
            DebuggerManager.debug("WrapperConnection error", e);
        }
    }
    public function get serverDomain():String {
        return  LINE_IN;
    }

    private function onAsyncError(event:AsyncErrorEvent):void {


        DebuggerManager.debug(" WrapperConnection onAsyncError", event);
    }

    private function onSecurityError(event:SecurityErrorEvent):void {

        DebuggerManager.debug(" WrapperConnection onSecurityError", event);

    }

    private function onStatus(event:StatusEvent):void {

        switch (event.level) {
            case "status":
                break;
            case "error":
                    trace("ERRORRR")
                DebuggerManager.debug(" WrapperConnection onStatus", event);
                break;
            //
        }

    }
}
}
