/**
 * Created with IntelliJ IDEA.
 * User: williamwc
 * Date: 11/23/12
 * Time: 11:19 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.crypto {

import flash.net.registerClassAlias;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;

import utils.commands.getClassName;

import utils.managers.serializer.Base64;



public class Obfuscator {
    private static const KEY:String     = "KEY_PROPERTY";
    private static const N_KEYS:String  = "NUMBER_OF_KEYS";
    private static const CLASS:String   = "ITEM_CLASS";

    private static var dictionary:Dictionary = new Dictionary(true);

    private static var classAliases:Vector.<Class> = new Vector.<Class>();
    private static var nKey:int = 3;

    public function Obfuscator() {
    }

    public static function addItem(itemKey:String, value:*):void {
        var keyHolder:Object;
        var key:String;

        if(dictionary[itemKey] == null || dictionary[itemKey] == undefined) {
            keyHolder           = {};
            keyHolder[N_KEYS]   = nKey;
            keyHolder[CLASS]    = getClass(value);
            regClassAlias(keyHolder[CLASS]);

            key = encode(value);
            keyHolder = splitKey(keyHolder,key);

            dictionary[itemKey] = keyHolder;
        } else {
            throw new Error("[Obfuscator.addItem] itemKey:" + itemKey + " is already being used.");
        }
    }

    public static function getItem(itemKey:String):* {
        var keyHolder:Object = dictionary[itemKey];
        var key:String       = joinKey(keyHolder);
        return decode(key);
    }

    public static function setItem(itemKey:String, value:*):void {
        var keyHolder:Object = dictionary[itemKey];
        var key:String;

        if (keyHolder == null)
            throw new Error("[Obfuscator.setItem] itemKey:" + itemKey + " doesn't exist.");

        key         = encode(value);
        keyHolder   = splitKey(keyHolder, key);

        dictionary[itemKey] = keyHolder;
    }

    public static function removeItem(itemKey:String):void {
        delete dictionary[itemKey];
    }

    /** INTERNAL USE    **/
    private static function encode(obj:*):String {
        return Base64.encodeObject(obj);
    }

    private static function decode(encodedString:String):* {
        Base64.decodeObject(encodedString);
    }

    private static function splitKey(keyHolder:Object, key:String):Object {
        var lastIdx:int = 0;

        for (var n:int = 0; n < keyHolder[N_KEYS]; n++) {
            var tidx:int = (n < keyHolder[N_KEYS] - 1) ? lastIdx + Math.random() * (key.length - lastIdx) : key.length;
            keyHolder[KEY + n] = key.substring(lastIdx, tidx);
            lastIdx = tidx;
        }
        return keyHolder;
    }

    private static function joinKey(keyHolder:Object):String {
        var key:String = "";
        for (var k:int = 0; k < keyHolder[N_KEYS]; k++) {
            key += keyHolder[KEY+k];
        }
        return key;
    }

    private static function regClassAlias(cl:Class):void {
        for each(var c:Class in classAliases) {
            if(c == cl) return;
        }
        registerClassAlias(getClassName(cl), cl);
        classAliases.push(cl);
    }

    private static function getClass(obj:Object):Class {
        return Class(getDefinitionByName(getClassName(obj)));
    }
}
}
