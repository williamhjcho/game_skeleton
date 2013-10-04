package com.fraktalo.SCORM.events {

/**
 * @author filipe.pereira
 */
public class ScormEventError extends ScormEventCustom {

    public static const TYPE:String = "com.aennova.agp.events.ErrorEvent";
    private var _msg:String = "";
    private var _obj:Object = null;

    public function ScormEventError(msg:String, obj:Object = null) {

        super(ScormEventError.TYPE);
        this._msg = msg;
        this._obj = obj;
    }

    public function get msg():String {
        return _msg;
    }

    public function set msg(msg:String):void {
        _msg = msg;
    }

    public function get obj():Object {
        return _obj;
    }

    public function set obj(obj:Object):void {
        _obj = obj;
    }
}
}
