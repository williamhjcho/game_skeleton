package com.fraktalo.SCORM.events {
import com.fraktalo.SCORM.vo.CMI;

/**
 * @author filipe.pereira
 */
public class ScormEventCMI extends ScormEventCustom {
    public static const TYPE:String = "cmi";
    private var _cmi:CMI;

    public function ScormEventCMI(cmi:CMI) {
        super(ScormEventCMI.TYPE);
        this._cmi = cmi;
    }

    public function get cmi():CMI {
        return _cmi;
    }

    public function set cmi(cmi:CMI):void {
        _cmi = cmi;
    }
}
}
