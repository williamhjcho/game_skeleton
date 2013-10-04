/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 20/08/13
 * Time: 16:44
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.serializer {
import flash.utils.getDefinitionByName;

public class ClassArchitectureProperty {

    public var name         :String = null;
    public var type         :String = null;
    public var classType    :Class = null;
    public var returnType   :String = null;
    public var optional     :Boolean = false;
    public var parameters   :Vector.<ClassArchitectureProperty>;

    public function apply(xml:XML):void {
        this.name = xml.@name;
        this.type = xml.@type;
        this.returnType = xml.@returnType;
        this.optional = xml.@optional == "true";

        this.classType = (type == null || type == "")? null : getDefinitionByName(type) as Class;

        var list:XMLList = xml..parameters;
        if(list.length() > 0) {
            this.parameters = new Vector.<ClassArchitectureProperty>();
            for each (var subXML:XML in list) {
                var cap:ClassArchitectureProperty = new ClassArchitectureProperty();
                cap.apply(subXML);
                parameters.push(cap);
            }
        }
    }


    public function toString():String {
        return  "<name:\""          + name +
                "\", type:\""       + type +
                "\", returnType:\"" + returnType +
                "\", optional: "    + optional +
                ", parameters: "    + (parameters == null? "0" : parameters.length.toString()) +
                "/>";
    }
}
}
