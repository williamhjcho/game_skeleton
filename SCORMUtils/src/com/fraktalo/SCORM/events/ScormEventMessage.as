package com.fraktalo.SCORM.events {

/**
 * @author filipe.pereira
 */
public class ScormEventMessage extends ScormEventCustom {
    public static const TYPE:String = "messageEvent";
    public var msg:String = "";

    public function ScormEventMessage(msg:String = "") {
        this.msg = msg;
        super(ScormEventMessage.TYPE);
    }
}
}
