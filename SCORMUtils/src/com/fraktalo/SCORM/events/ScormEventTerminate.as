package com.fraktalo.SCORM.events {

/**
 * @author filipe.pereira
 */
public class ScormEventTerminate extends ScormEventCustom {
    public static const TYPE:String = "terminateEvent";

    public function ScormEventTerminate() {
        super(ScormEventTerminate.TYPE);
    }
}
}
