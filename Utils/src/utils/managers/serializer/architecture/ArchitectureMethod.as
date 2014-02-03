/**
 * Created by William on 2/3/14.
 */
package utils.managers.serializer.architecture {
import flash.utils.getDefinitionByName;

public class ArchitectureMethod {

    private var _name:String;
    private var _returnType:Class;
    private var _parameters:Vector.<ArchitectureParameter>;

    private var _typeName:String;

    public function ArchitectureMethod(xml:XML) {
        if(xml == null) throw new ArgumentError("Parameter xml cannot be null.");

        _typeName = xml.@returnType;

        _name = xml.@name;
        _returnType = (_typeName == null || _typeName == "" || _typeName == "void") ? null : getDefinitionByName(_typeName) as Class;

        var list:XMLList = xml..parameters;
        if(list.length() > 0) {
            _parameters = new Vector.<ArchitectureParameter>();
            for each (var subXML:XML in list) {
                _parameters.push(new ArchitectureParameter(subXML));
            }
        }
    }


    public function get name():String {
        return _name;
    }

    public function get returnType():Class {
        return _returnType;
    }

    public function get parameters():Vector.<ArchitectureParameter> {
        return _parameters;
    }

    public function toString():String {
        var s:String = "<method name=\"" + _name + "\" returnType=\"" + _typeName + "\"" + ">";
        for each (var p:ArchitectureParameter in _parameters) {
            s += p.toString() + '\n';
        }
        return s + "</method>";
    }
}
}
