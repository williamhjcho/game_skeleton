package com.fraktalo.SCORM {


/**
 * @author Aennova
 */

/**
 * @author Aennova
 */
public interface ICore {

    //initialized commit e terminate
    function initialize():void;

    function commit(typedJSON:String):void;

    function terminate():void;

    function retrieveCommited():void;

    function retrieveTerminated():void;

    function retrieveInitialized(scormFromAPI:String):void;

}
}

