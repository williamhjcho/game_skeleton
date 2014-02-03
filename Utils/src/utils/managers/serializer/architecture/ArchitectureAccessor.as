/**
 * Created by William on 2/3/14.
 */
package utils.managers.serializer.architecture {
import flash.utils.getDefinitionByName;

public class ArchitectureAccessor {

    public static const WRITE_ONLY:String = "writeonly";
    public static const READ_ONLY:String = "readonly";

    private var _name:String;
    private var _access:String;
    private var _type:Class;

    private var _typeName:String;

    public function ArchitectureAccessor(xml:XML) {
        if(xml == null) throw new ArgumentError("Parameter xml cannot be null.");

        _typeName = xml.@type;

        _name = xml.@name;
        _access = xml.@access;
        _type = (_typeName == null || _typeName == "")? null : getDefinitionByName(_typeName) as Class;
    }

    public function get name():String {
        return _name;
    }

    public function get access():String {
        return _access;
    }

    public function get type():Class {
        return _type;
    }

    public function get isReadOnly():Boolean {
        return _access == READ_ONLY;
    }

    public function get isWriteOnly():Boolean {
        return _access == WRITE_ONLY;
    }

    public function toString():String {
        return "<accessor name=\"" + _name + "\" access=\"" + _access + "\" type=\"" + _typeName + "\"/>";
    }
}
}
