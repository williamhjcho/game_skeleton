/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 20/08/13
 * Time: 16:40
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.serializer {
import flash.utils.Dictionary;
import flash.utils.describeType;

public class ClassArchitecture {

    private static var architectures:Dictionary = new Dictionary();

    private var _xml                :XML;
    private var _isDynamic          :Boolean = false;
    private var _isFinal            :Boolean = false;
    private var _isStatic           :Boolean = false;
    private var _constructor        :ClassArchitectureProperty = new ClassArchitectureProperty();
    private var _variables          :Dictionary = new Dictionary();
    private var _variablesStatic    :Dictionary = new Dictionary();
    private var _methods            :Dictionary = new Dictionary();
    private var _methodsStatic      :Dictionary = new Dictionary();

    /** Static Methods **/
    public static function getArchitecture(target:Class):ClassArchitecture {
        if(architectures[target] == null || architectures[target] == undefined)
            architectures[target] = new ClassArchitecture(target);
        return architectures[target];
    }

    private static function filter(caller:ClassArchitecture):void {
        var xml:XML, cap:ClassArchitectureProperty;
        caller._isDynamic   = caller._xml.@isDynamic == "true";
        caller._isFinal     = caller._xml.@isFinal == "true";
        caller._isStatic    = caller.xml.@isStatic == "true";

        for each (xml in caller._xml.children()) {
            var name:String = xml.name();
            var property:String = xml.@name;
            switch (name) {
                case "variable": {
                    cap = new ClassArchitectureProperty();
                    cap.apply(xml);
                    caller._variablesStatic[property] = cap;
                    break;
                }
                case "method": {
                    cap = new ClassArchitectureProperty();
                    cap.apply(xml);
                    caller._methodsStatic[property] = cap;
                    break;
                }
                case "factory": {
                    filterFactory(caller, xml);
                    break;
                }
            }
        }
    }

    private static function filterFactory(caller:ClassArchitecture, factory:XML):void {
        var xml:XML,cap:ClassArchitectureProperty;

        for each (xml in factory.children()) {
            var name:String = xml.name();
            var property:String = xml.@name;
            switch (name) {
                case "constructor": {
                    caller._constructor.apply(xml);
                    break;
                }
                case "variable": {
                    cap = new ClassArchitectureProperty();
                    cap.apply(xml);
                    caller._variables[property] = cap;
                    break;
                }
                case "method": {
                    cap = new ClassArchitectureProperty();
                    cap.apply(xml);
                    caller._methods[property] = cap;
                    break;
                }
            }
        }
    }

    /** Instance Methods **/
    public function ClassArchitecture(target:Class) {
        if(architectures[target] == null || architectures[target] == undefined) {
            architectures[target] = this;
        }
        _xml = describeType(target);
        filter(this);
    }

    public function get isConstructorOptional():Boolean {
        if(_constructor == null || _constructor.parameters == null) return true;
        for each (var p:ClassArchitectureProperty in _constructor.parameters) {
            if(p.optional == false) return false;
        }
        return true;
    }

    public function toString():String {
        var s:String = "";
        var cap:ClassArchitectureProperty;
        s += "<Class name=\"" + _xml.@name + "\" isDynamic=\"" + _isDynamic + "\" isFinal=\"" + _isFinal + "\" isStatic=\"" + _isStatic + "\"/>\n";
        s += "<constructor>\n\t" + _constructor.toString() + "\n</constructor>\n";
        s += "<variables>\n";       for each (cap in _variables      ) { s += "\t" + cap.toString() + "\n"; } s += "</variables>\n";
        s += "<variablesStatic>\n"; for each (cap in _variablesStatic) { s += "\t" + cap.toString() + "\n"; } s += "</variablesStatic>\n";
        s += "<methods>\n";         for each (cap in _methods        ) { s += "\t" + cap.toString() + "\n"; } s += "</methods>\n";
        s += "<methodsStatic>\n";   for each (cap in _methodsStatic  ) { s += "\t" + cap.toString() + "\n"; } s += "</methodsStatic>\n";

        return s;
    }

    public function get xml             ():XML { return _xml; }
    public function get isDynamic       ():Boolean { return _isDynamic; }
    public function get isFinal         ():Boolean { return _isFinal; }
    public function get isStatic        ():Boolean { return _isStatic; }
    public function get constructor     ():ClassArchitectureProperty { return _constructor; }
    public function get variables       ():Dictionary { return _variables; }
    public function get variablesStatic ():Dictionary { return _variablesStatic; }
    public function get methods         ():Dictionary { return _methods; }
    public function get methodsStatic   ():Dictionary { return _methodsStatic; }

    public function getVariable         (name:String):ClassArchitectureProperty { return _variables      [name]; }
    public function getStaticVariable   (name:String):ClassArchitectureProperty { return _variablesStatic[name]; }
    public function getMethod           (name:String):ClassArchitectureProperty { return _methods        [name]; }
    public function getStaticMethod     (name:String):ClassArchitectureProperty { return _methodsStatic  [name]; }
}
}
