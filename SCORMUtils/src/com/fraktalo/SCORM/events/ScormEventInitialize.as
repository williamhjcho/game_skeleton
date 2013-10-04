package com.fraktalo.SCORM.events {

/**
 * @author filipe.pereira
 */
public class ScormEventInitialize extends ScormEventCustom {
    public static const TYPE:String = "ScormEventInitialize";


    public function ScormEventInitialize() {
        super(ScormEventInitialize.TYPE);

    }
}
}
