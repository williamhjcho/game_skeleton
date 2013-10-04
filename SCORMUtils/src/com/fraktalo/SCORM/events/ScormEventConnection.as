package com.fraktalo.SCORM.events{

/**
 * @author filipe.pereira
 */
public class ScormEventConnection extends ScormEventCustom {

    public static const TYPE:String = "connectionEvent";
    public static const CONNECTED:String = "connected";

    public var status:String = "";

    public function ScormEventConnection(status:String = ScormEventConnection.CONNECTED) {
        this.status = status;
        super(ScormEventConnection.TYPE);

    }
}
}
