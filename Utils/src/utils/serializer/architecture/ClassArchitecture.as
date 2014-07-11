/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 20/08/13
 * Time: 16:40
 * To change this template use File | Settings | File Templates.
 */
package utils.serializer.architecture {
import flash.utils.Dictionary;
import flash.utils.describeType;

public class ClassArchitecture {

    private static var architectures:Dictionary = new Dictionary();

    private var _target             :Class;
    private var _xml                :XML;
    private var _isDynamic          :Boolean = false;
    private var _isFinal            :Boolean = false;
    private var _isStatic           :Boolean = false;
    private var _constructor        :ArchitectureConstructor;
    private var _variables          :Dictionary = new Dictionary();
    private var _accessors          :Dictionary = new Dictionary();
    private var _methods            :Dictionary = new Dictionary();

    /** Static Methods **/
    public static function getArchitecture(target:Class):ClassArchitecture {
        if(!(target in architectures))
            architectures[target] = new ClassArchitecture(target);
        return architectures[target];
    }

    private static function filter(caller:ClassArchitecture):void {
        caller._isDynamic   = caller._xml.@isDynamic == "true";
        caller._isFinal     = caller._xml.@isFinal == "true";
        caller._isStatic    = caller.xml.@isStatic == "true";

        for each (var xml:XML in XML(caller._xml..factory).children()) {
            var name:String = xml.name();
            var property:String = xml.@name;
            switch (name) {
                case "constructor": {
                    caller._constructor = new ArchitectureConstructor(xml);
                    break;
                }
                case "variable": {
                    caller._variables[property] = new ArchitectureVariable(xml);
                    break;
                }
                case "method": {
                    caller._methods[property] = new ArchitectureMethod(xml);
                    break;
                }
                case "accessor": {
                    caller._accessors[property] = new ArchitectureAccessor(xml);
                    break;
                }
            }
        }
    }

    /** Instance Methods **/
    public function ClassArchitecture(target:Class) {
        if(target == null) throw new ArgumentError("Target Class cannot be null.");
        if(!(target in architectures)) {
            architectures[target] = this;
        }
        _target = target;
        _xml = describeType(target);
        filter(this);
    }

    public function get isConstructorOptional():Boolean {
        if(_constructor == null) return true;
        return _constructor.isOptional;
    }

    public function toString():String {
        var s:String = "";
        s += "<Class name=\"" + _xml.@name + "\" isDynamic=\"" + _isDynamic + "\" isFinal=\"" + _isFinal + "\" isStatic=\"" + _isStatic + "\"/>\n";
        s += "\n" + _constructor.toString() + "\n";
        s += "<variables>\n";       for each (var a:ArchitectureVariable in _variables  ) { s += "\t" + a.toString() + "\n"; } s += "</variables>\n";
        s += "<methods>\n";         for each (var b:ArchitectureMethod in _methods      ) { s += "\t" + b.toString() + "\n"; } s += "</methods>\n";
        s += "<accessors>\n";       for each (var c:ArchitectureAccessor in _accessors  ) { s += "\t" + c.toString() + "\n"; } s += "</accessors>\n";
        return s;
    }

    public function get target          ():Class { return _target; }
    public function get xml             ():XML { return _xml; }
    public function get isDynamic       ():Boolean { return _isDynamic; }
    public function get isFinal         ():Boolean { return _isFinal; }
    public function get isStatic        ():Boolean { return _isStatic; }
    public function get constructor     ():ArchitectureConstructor { return _constructor; }
    public function get variables       ():Dictionary { return _variables; }
    public function get methods         ():Dictionary { return _methods; }
    public function get accessors       ():Dictionary { return _accessors; }

    public function getVariable         (name:String):ArchitectureVariable  { return _variables[name]; }
    public function getMethod           (name:String):ArchitectureMethod    { return _methods[name]; }
    public function getAccessor         (name:String):ArchitectureAccessor  { return _accessors[name]; }
}
}
