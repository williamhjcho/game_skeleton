/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/18/13
 * Time: 8:38 AM
 * To change this template use File | Settings | File Templates.
 */
package serializer {
import com.demonsters.debugger.MonsterDebugger;

import flash.utils.Dictionary;

import utils.commands.getClass;
import utils.commands.getClassByPath;
import utils.commands.getClassName;

public class Serialize {

    private static const CLASSNAME:String = "___className";
    private static const PRIORITY :String = "___priority";

    private static var primitives:Dictionary;

    private static var path:Vector.<String>;
    private static const isInitialized:Boolean = initialize();

    public static function initialize():Boolean {
        primitives = new Dictionary();
        primitives[null   ] = true;
        primitives[Boolean] = true;
        primitives[String ] = true;
        primitives[uint   ] = true;
        primitives[int    ] = true;
        primitives[Number ] = true;
        return true;
    }

    public static function parse(str:String):* {
        path = new <String>["root"];
        var result:Object = JSON.parse(str, d_parse);
        MonsterDebugger.trace("Result", result);
        return result;
    }

    private static function d_parse(property:String, val:Object):Object {
        var clss:Class = getClass(val);
        var result:Object;

        path.push(property);
        trace("path:["+path+ "] -=-=- (" + property + " : " + getClassName(property) + ") (" + val + " : " + getClassName(val) + ")");

        if(isPrimitive(clss)) {
            result = val;
        } else {
            switch(clss) {
                case Object: { result = d_Object(val); break; }
                case Array : { result = val; break; }
            }
        }
        path.pop();
        return result;
    }

    /** Specific de-serializing methods **/
    private static function d_Object(obj:Object):Object {
        var image:Class = Object;

        if(obj.hasOwnProperty(CLASSNAME)) {
            image = getClassByPath(obj[CLASSNAME]);
        }
        if(obj.hasOwnProperty(PRIORITY)) {

        }

        return new image();
    }


    /** Tools **/
    private static function isPrimitive(clss:Class):Boolean {
        return primitives[clss] != null && primitives[clss] != undefined;
    }
}
}
