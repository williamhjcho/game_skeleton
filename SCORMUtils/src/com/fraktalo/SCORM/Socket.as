package com.fraktalo.SCORM {

import com.fraktalo.SCORM.events.ScormEventCommit;
import com.fraktalo.SCORM.events.ScormEventConnection;
import com.fraktalo.SCORM.events.ScormEventInitialize;
import com.fraktalo.SCORM.events.ScormEventMessage;
import com.fraktalo.SCORM.events.ScormEventTerminate;
import com.fraktalo.SCORM.vo.CMI;

import flash.events.EventDispatcher;

import utils.managers.serializer.SerializerManager;

/**
 * @author filipe.pereira
 * setCommitOnly
 */
public class Socket extends EventDispatcher {
    {
        ScormEventInitialize, ScormEventCommit, ScormEventTerminate
    }

    public var connection:SocketConnection;
    public var lockGameFunction:Function;

    public var cmi:CMI;


    public function Socket(lockGameFunction:Function = null) {
        connection = new SocketConnection(this);
        this.lockGameFunction = lockGameFunction;
        debug("Socket",lockGameFunction);


    }

    public function showLockScreen(visible:Boolean = false):void {
        if (lockGameFunction != null) {
            this.lockGameFunction.apply(this, [visible]);

        }

    }

    //connection

    public function findWrapper():void {
        debug("Socket findWrapper",lockGameFunction);
        showLockScreen(true);

        connection.startFindWrapper();
    }

    public function onFindWrapper():void {
        debug("Socket onFindWrapper",lockGameFunction);
        connection.onFindWrapper();
        this.dispatchEvent(new ScormEventConnection());
    }

    public function sendMessage(msg:String):void {
        connection.sendMethod("onSendMessage", msg);
    }

    public function onSendMessage(msg:String):void {
        debug("Socket onSendMessage",lockGameFunction);
        this.dispatchEvent(new ScormEventMessage(msg));
    }

    public function debug(msg:String, obj:Object = null):void {
        trace(msg, obj)
        connection.debug(msg, obj);
    }

    public function initialize():void {
        debug("Socket initialize",lockGameFunction);
        showLockScreen(true);
        connection.sendMethod("initialize");
    }

    public function onInitialize(typedJSON:String):void {
        debug("chegou no socket", typedJSON);
        trace("chegou no socket", typedJSON);
        //Trava
        var o:Object = SerializerManager.JSONparse(typedJSON)

        cmi = SerializerManager.decode(o) as CMI;
        showLockScreen(false);
        this.dispatchEvent(new ScormEventInitialize());
    }

    public function commit():void {
        debug("chegou no COMMIT ->  ", "");
        var o:Object = SerializerManager.JSONstringfy(cmi);
        var str:String = SerializerManager.encodeAndStringfy(o);
        showLockScreen(true);
        connection.sendMethod("commit",str);
    }

    public function onCommit(typedJSON:String):void {
        debug("Socket onCommit",lockGameFunction);
        showLockScreen(false);
        this.dispatchEvent(new ScormEventCommit(typedJSON));
    }

    public function terminate():void {
        debug("Socket terminate",lockGameFunction);
        showLockScreen(false);
        connection.sendMethod("terminate");
    }

    public function onTerminate():void {
        trace("socker onTerminate 1 a", null);
        this.dispatchEvent(new ScormEventTerminate());
        showLockScreen(false);

        try {
            connection.close();
            trace("SCOKET connection close")
        } catch (e:Error) {
            debug("Error on close connection", e.message);
        }
    }

}
}
