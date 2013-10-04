package com.fraktalo.SCORM.events {

/**
 * @author filipe.pereira
 */
public class ScormEventCommit extends ScormEventCustom {
    public static const TYPE:String = "ScormEventCommit";
    public var typedJSON:String;
    public function ScormEventCommit(typedJSON:String):void {
        this.typedJSON= typedJSON;
        super(ScormEventCommit.TYPE);
    }
}
}
