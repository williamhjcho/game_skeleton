/**
 * Created by William on 2/3/14.
 */
package utils.managers.serializer.architecture {
public class ArchitectureConstructor {

    private var _parameters:Vector.<ArchitectureParameter>;

    public function ArchitectureConstructor(xml:XML) {
        if(xml == null) throw new ArgumentError("Parameter xml cannot be null.");

        var list:XMLList = xml..parameters;
        if(list.length() > 0) {
            _parameters = new Vector.<ArchitectureParameter>();
            for each (var subXML:XML in list) {
                _parameters.push(new ArchitectureParameter(subXML));
            }
        }
    }


    public function get parameters():Vector.<ArchitectureParameter> {
        return _parameters;
    }

    public function get isOptional():Boolean {
        if(_parameters == null) return true;
        for each (var p:ArchitectureParameter in parameters) {
            if(!p.isOptional) return false;
        }
        return true
    }

    public function toString():String {
        var s:String = "<constructor isOptional=" + isOptional + ">";
        for each (var p:ArchitectureParameter in parameters)
            s += p.toString() + '\n'
        return s + "</constructor>";
    }
}
}
