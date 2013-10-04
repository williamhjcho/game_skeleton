package com.fraktalo.SCORM.events {

/**
 * @author filipe.pereira
 */
public class ScormEventSave extends ScormEventCustom {

    public static const TYPE:String = "ScormEventSave";
    public var saveData:String;

    public function ScormEventSave(saveData:String = "") {

        super(ScormEventSave.TYPE);

        this.saveData = saveData;
    }
}
}
