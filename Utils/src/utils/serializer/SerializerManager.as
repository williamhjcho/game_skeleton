/**
 * Created with IntelliJ IDEA.
 * User: filiperp
 * Date: 30/11/12
 * Time: 10:30
 * To change this template use File | Settings | File Templates.
 */
package utils.serializer {

import flash.utils.Dictionary;
import flash.xml.XMLNode;

import utils.commands.getClass;
import utils.commands.getClassByPath;
import utils.commands.getClassName;
import utils.errors.SerializerError;
import utils.serializer.architecture.ArchitectureVariable;
import utils.serializer.architecture.ClassArchitecture;
import utils.serializer.json.JSON;

/**
 * This class is used to serialize a common object into a strongly typed object, using it's own tools and methods
 * All it requires is the correct classpath to be defined in the object's property (___className)
 */
public class SerializerManager {

    private static const CLASS_NAME:String = "___className";
    private static const PRIORITY :String = "___priority";
    private static const REFERENCE:String = "___reference";

    private static var reference        :Dictionary;
    private static var priorities       :Dictionary;
    private static var ignoreReference  :Boolean = false;
    private static var onError          :Function = null;

    //==================================
    //     Public
    //==================================
    public static function encode(obj:Object, ignoreSameReference:Boolean = false, onError:Function = null):Object {
        reference = new Dictionary();
        priorities = new Dictionary();
        ignoreReference = ignoreSameReference;
        SerializerManager.onError = onError;

        var encoded:Object = serialize(obj);

        //priority references
        if(!ignoreSameReference) {
            for each (var item:String in priorities) {
                var fatherPath:String   = item.replace(/\.?(.*)\.([^\.]*)$/, "$1");
                var property:String     = item.replace(/.*\.([^\.]*)$/, "$1");
                var father:Object       = navigate(encoded, fatherPath);
                if(!father.hasOwnProperty(PRIORITY))
                    father[PRIORITY] = [];
                (father[PRIORITY] as Array).push(property);
            }
        }

        //resetting variables
        SerializerManager.onError = null;
        reference       = null;
        priorities      = null;
        ignoreReference = false;
        return encoded;
    }

    public static function decode(obj:Object):* {
        reference = new Dictionary();
        var decoded:Object = deSerialize(obj);
        return decoded;
    }

    public static function encodeAndStringfy(obj:Object, ignoreSameReference:Boolean = false, onError:Function = null):String {
        var encoded:Object = encode(obj, ignoreSameReference, onError);
        return utils.serializer.json.JSON.encode(encoded);
    }

    public static function decodeFromString(src:String):* {
        var obj:Object = utils.serializer.json.JSON.decode(src);
        return decode(obj);
    }

    public static function JSONEncode(obj:Object):String {
        return utils.serializer.json.JSON.encode(obj);
    }

    public static function JSONDecode(str:String):Object {
        return utils.serializer.json.JSON.decode(str);
    }


    //==================================
    //     Serialization
    //==================================
    private static function serialize(obj:Object, path:String = ""):Object {
        var classType:Class  = getClass(obj);

        //Primitives
        switch (classType) {
            case null       : { return null; }
            case uint       : { return uint(obj); }
            case int        : { return int(obj); }
            case Number     : { return Number(obj); }
            case String     : { return String(obj); }
            case Boolean    : { return Boolean(obj); }
        }

        //checking for references
        if(!ignoreReference && (reference[obj] != null && reference[obj] != undefined)) {
            priorities[obj] = reference[obj]; // == path
            return { ___reference:reference[obj] };
        }
        reference[obj] = path;

        //Known Classes
        var className:String = getClassName(classType);
        switch (classType) {
            case Object         : { return srlz_Object(obj, path); }
            case XMLList        :
            case XML            :
            case XMLNode        : { return srlz_XML(obj, className); }
            case Date           : { return srlz_Date(obj as Date, className); }
            case Dictionary     : { return srlz_Dictionary(obj as Dictionary, className, path); }
        }

        if(classType == Array || className.indexOf("Vector.<") != -1)
            return srlz_Array(obj, path);

        //Custom Classes
        return srlz_Custom(obj, classType, className, path);
    }

    private static function deSerialize(obj:Object, imageClass:Class = null, path:String = ""):Object {
        var classType:Class = getClass(obj);

        switch (classType) {
            //Primitives
            case null       : //fall-through
            case uint       :
            case int        :
            case Number     :
            case String     :
            case Boolean    : return obj;

            //Advanced Primitives
            case Array      : { return dsrlz_Array(obj as Array, imageClass, path); }
            case Object     : { return dsrlz_Object(obj, imageClass, path); }
        }

        return null;
    }

    //==================================
    //     Function-to-Type Methods
    //==================================
    private static function srlz_Object     (obj:Object, path:String):Object {
        var result:Object = {};
        for (var property:String in obj) {
            result[property] = serialize(obj[property], path + "." + property);
        }
        return result;
    }
    private static function srlz_Date       (obj:Date, className:String):Object {
        return { ___className:className, value:(obj).valueOf() };
    }
    private static function srlz_XML        (obj:Object, className:String):Object {
        return { ___className:className, value:(obj).toString() };
    }
    private static function srlz_Dictionary (obj:Dictionary, className:String, path:String):Object {
        var result:Object = { ___className:className ,value:[] };
        var i:int = 0;
        for (var item:Object in obj) {
            result.value[i] = {
                key     : serialize(item     , path + "." + i.toString() + ".0"),
                value   : serialize(obj[item], path + "." + i.toString() + ".1")
            };
            i++;
        }
        return result;
    }
    private static function srlz_Array      (obj:Object, path:String):Array {
        var result:Array = [];
        for (var i:int = 0; i < obj.length; i++) {
            result[i] = serialize(obj[i], path + "." + i.toString());
        }
        return result;
    }
    private static function srlz_Custom     (obj:Object, classType:Class, className:String, path:String):Object {
        var result:Object = { ___className:className };

        var architecture:ClassArchitecture = ClassArchitecture.getArchitecture(classType);
        //constructor analysis

        //instance variable serialization
        for each (var v:ArchitectureVariable in architecture.variables) {
            result[v.name] = serialize(obj[v.name], path + "." + v.name);
        }

        return result;
    }


    private static function dsrlz_Array         (obj:Array, imageClass:Class, path:String):Object {
        if(imageClass == null) imageClass = Array;
        var className   :String = getClassName(imageClass);
        var result      :Object = reference[path] = new imageClass();
        var subClass    :Class = null;


        if(/Vector\.</.test(className)) { //is Vector
            if(className.match(/Vector\.</g).length > 0) //is multi-dimension Vector
                subClass = getClassByPath(className.replace(/Vector\.<(.*)>$/, "$1")); //get next-dimension's class
        }

        var i:int = 0;
        for each (var subItem:Object in obj) {
            result.push(deSerialize(subItem, subClass, path + "." + i++));
        }

        return result;
    }
    private static function dsrlz_Date          (obj:Object):Date {
        var result:Date = new Date();
        result.setTime(obj.value);
        return result;
    }
    private static function dsrlz_Dictionary    (obj:Object, path:String):Dictionary {
        var result:Dictionary = new Dictionary();
        var i:int = 0;
        for each(var item:Object in obj.value) {
            result[deSerialize(item.key, null, path + '.' + i.toString() + ".0")]
                    = deSerialize(item.value, null, path + '.' + i.toString() + ".1");
            i++;
        }
        return result;
    }
    private static function dsrlz_Object        (obj:Object, expectedClass:Class, path:String):Object {
        var result:Object;
        var imageClass:Class = expectedClass || Object;

        if(obj.hasOwnProperty(REFERENCE)) {
            return reference[obj[REFERENCE]];
        }
        if(obj.hasOwnProperty(CLASS_NAME)) {
            imageClass = getClassByPath(obj[CLASS_NAME]);
        }
        if(obj.hasOwnProperty(PRIORITY)) {
            var priority:Array = obj[PRIORITY];
            result = new imageClass();
            for each (var property:String in priority) {
                result[property] = deSerialize(obj[property], null, path + "." + property);
            }
        }

        //Known Classes
        switch(imageClass) {
            case Object     : { reference[path] = dsrlz_Simple_Object(obj, path, result);   return reference[path]; }
            case Date       : { reference[path] = dsrlz_Date(obj);                          return reference[path]; }
            case Dictionary : { reference[path] = dsrlz_Dictionary(obj,path);               return reference[path]; }
            case XMLList    : { reference[path] = new XMLList(obj.value);                   return reference[path]; }
            case XML        : { reference[path] = new XML(obj.value);                       return reference[path]; }
            case XMLNode    : { reference[path] = new XMLNode(1,obj.value);                 return reference[path]; }
        }

        reference[path] = dsrlz_Custom(obj, imageClass, path, result);
        return reference[path];
    }
    private static function dsrlz_Simple_Object (obj:Object, path:String, result:Object = null):Object {
        if(result == null) result = {};
        for (var property:String in obj) {
            if(property == CLASS_NAME || property == PRIORITY) continue;
            result[property] = deSerialize(obj[property], null, path + "." + property);
        }
        return result;
    }
    private static function dsrlz_Custom        (obj:Object, imageClass:Class, path:String, result:Object = null):Object {
        var architecture:ClassArchitecture = ClassArchitecture.getArchitecture(imageClass);
        var cap:ArchitectureVariable;

        if(result == null) result = new imageClass();

        //Remaining of Variables/Properties
        for (var property:String in obj) {
            if(property == CLASS_NAME || property == PRIORITY) continue;
            cap = architecture.getVariable(property);
            if(cap == null) {
                if(architecture.isDynamic)
                    result[property] = deSerialize(obj[property], null, path + "." + property);
                else
                    throwError("Variable :\"" + property + "\" not found in \"" + imageClass +"\".", SerializerError.VARIABLE_NOT_FOUND);
            } else
                result[property] = deSerialize(obj[property], cap.type, path + "." + property);
        }

        return result;
    }


    //==================================
    //  Internal Tools
    //==================================
    private static function navigate(root:Object, path:String):Object {
        if(path == null) return root;
        var paths:Array = path.split(/\./);
        var target:Object = root;
        for (var i:int = 0; i < paths.length; i++) {
            if(paths[i] == "") return target;
            target = target[paths[i]];
        }
        return target;
    }

    private static function throwError(msg:* = "", id:* = 0):void {
        var e:SerializerError = new SerializerError(msg, id);
        if(onError == null) {
            throw e;
        } else {
            onError.call(null, e);
        }
    }
}

}
