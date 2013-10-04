/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 25/04/13
 * Time: 14:40
 * To change this template use File | Settings | File Templates.
 */
package utils.base {

public dynamic class CustomObject {
    /** Object to facilitate exchange of run-time variables to other classes **/


    public function CustomObject(initialValues:Object = null) {
        if(initialValues != null) { add(initialValues); }
    }

    public function add(o:Object):CustomObject {
        //add another object's properties to this one (copy & overwrite)
        for(var p:String in o) { this[p] = o[p]; }
        return this;
    }

    public function remove(o:Object):CustomObject {
        for(var p:String in o) { delete this[p]; }
        return this;
    }

    public function deleteProperty(p:String):CustomObject {
        delete this[p];
        return this;
    }

    public function clean():void {
        for(var p:String in this) { delete this[p]; }
    }

    public function toString():String {
        var values:String = "[Custom Object] : {\n";
        for(var p:String in this) {
            values += "\t" + p + " = " + this[p] + "\n";
        }
        values += "}";
        return values;
    }
}
}
