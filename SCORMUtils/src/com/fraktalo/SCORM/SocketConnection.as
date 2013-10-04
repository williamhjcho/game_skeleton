package com.fraktalo.SCORM {
import flash.events.AsyncErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.StatusEvent;
import flash.events.TimerEvent;
import flash.net.LocalConnection;
import flash.utils.Timer;

/**
 * @author filipe.pereira
 */
public class SocketConnection extends LocalConnection {
    public var connected:Boolean = false;
    private const LINE_IN:String = SCORMChannelKeys.SOCKET_KEY;
    private const LINE_OUT:String =SCORMChannelKeys.WRAPPER_KEY;

    private var _client:Socket;

    private var timer:Timer;

    public function SocketConnection(client:Socket) {
        super();

        this.client = client;
        this._client = client;
        this.allowDomain("*");
        this.allowInsecureDomain("*");

        try {
            this.connect(LINE_IN);
        } catch (e:Error) {
        }
        timer = new Timer(1000, 0);
        timer.addEventListener(TimerEvent.TIMER, onTimer);

        this.addEventListener(StatusEvent.STATUS, onStatus);
        this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
        this.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
    }

    private function onAsyncError(event:AsyncErrorEvent):void {
        debug(" SocketConnection onAsyncError", event);
    }
    private function onSecurityError(event:SecurityErrorEvent):void {
        debug(" SocketConnection onSecurityError", event);
    }

    private function onStatus(event:StatusEvent):void {

        switch (event.level) {
            case "status":
                break;
            case "error":
               // this.close();
                   // trace("passou erro")
                debug(" SocketConnection onStatus", event);
                break;

        }

    }

    private function onTimer(event:TimerEvent):void {
        startFindWrapper();
    }

    public function startFindWrapper():void {
        findWrapper();
        timer.start();
    }

    private function findWrapper():void {

        try {
            this.sendMethod("findWrapper");
        } catch (e:Error) {
            trace(e.message)
            debug(e.message, e);
        }
    }

    public function onFindWrapper():void {
        timer.removeEventListener(TimerEvent.TIMER, onTimer);
        timer.stop();
        this.connected = true;
    }

    public function sendMethod(method:String, ...vars):void {
        var arr:Array =[LINE_OUT,method].concat(vars);

         //trace('sendMethod',arr)
        try {

            this.send.apply(this, arr);
            vars.unshift("Sent from: SocketConnection: ");
            this.send(LINE_OUT, "debug", arr);

        }
        catch (e:Error) {

            vars.unshift("Error from: SocketConnection: ");
            vars.unshift(e.message);
            this.send(LINE_OUT, "debug", arr);

        }
    }

    public function debug(msg:String, obj:* = null):void {
            this.sendMethod("debug", msg, obj);
    }

    public function get serverDomain():String {
        return LINE_OUT;
    }

    public function get socketDomain():String {
        return LINE_IN;
    }
}
}
