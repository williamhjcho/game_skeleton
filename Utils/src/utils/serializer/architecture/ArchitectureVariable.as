/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 20/08/13
 * Time: 16:44
 * To change this template use File | Settings | File Templates.
 */
package utils.serializer.architecture {
import flash.utils.getDefinitionByName;

public class ArchitectureVariable {

    private var _name:String;
    private var _type:Class;

    private var _typeName:String;

    public function ArchitectureVariable(xml:XML) {
        if(xml == null) throw new ArgumentError("Parameter xml cannot be null.");

        var t:String = _typeName = xml.@type;
        _name = xml.@name;

        switch(t) {
            case null:
            case "":
            case "*": _type = null; break;
            default: _type = getDefinitionByName(t) as Class; break;
        }
    }

    public function get name():String {
        return _name;
    }

    public function get type():Class {
        return _type;
    }

    public function toString():String {
        return  "<variable name=\""      + _name +
                "\" type=\""   + _typeName +
                "\"/>";
    }
}
}
