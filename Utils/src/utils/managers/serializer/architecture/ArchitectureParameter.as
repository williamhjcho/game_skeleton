/**
 * Created by William on 2/3/14.
 */
package utils.managers.serializer.architecture {
import flash.utils.getDefinitionByName;

public class ArchitectureParameter {

    private var _type:Class;
    private var _isOptional:Boolean;

    private var _typeName:String;

    public function ArchitectureParameter(xml:XML) {
        if(xml == null) throw new ArgumentError("Parameter xml cannot be null.");

        _typeName = xml.@type;

        _isOptional = xml.@optional == "true";
        _type = (_typeName == null || _typeName == "")? null : getDefinitionByName(_typeName) as Class;
    }


    public function get type():Class {
        return _type;
    }

    public function get isOptional():Boolean {
        return _isOptional;
    }

    public function toString():String {
        return "<parameter type=\"" + _typeName + "\" isOptional=" + _isOptional + "/>";
    }
}
}
