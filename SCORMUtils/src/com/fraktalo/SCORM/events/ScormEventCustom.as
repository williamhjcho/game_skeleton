package com.fraktalo.SCORM.events {
import flash.events.Event;

/**
 * @author filipe.pereira
 */
public class ScormEventCustom extends Event {
    public function ScormEventCustom(type:String) {
        super(type, true, false);
    }
}
}
