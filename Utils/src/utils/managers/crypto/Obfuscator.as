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

import utils.commands.getClassName;

import utils.managers.serializer.Base64;
import utils.toollib.ToolMath;

/**
 * Simple Runtime Obfuscator
 * it breaks down the value of an variable, and saves the encrypted parts in a dictionary
 * the value can be retrieved and altered throught a key
 */
public class Obfuscator {
    //==================================
    //  How it works:
    //  key: "key0", value: "Obfuscate this"
    //  encoded_value = Base64(value)
    //  block_of_keys = splitInRandomPoints(encoded_value, NUMBER_OF_KEYS)
    //  dictionary[key] = block_of_keys
    //
    //  NOTE: block_of_keys = ["a", "b", "c"]
    //        where "a" + "b" + "c" = encoded_value
    //==================================

    private static const NUMBER_OF_KEYS :int = 3;

    private static var dictionary:Dictionary = new Dictionary(true);
    private static var classAliases:Vector.<Class> = new Vector.<Class>();

    //==================================
    //  Public
    //==================================
    public static function add(key:String, value:*):void {
        if(key in dictionary) {
            throw new ArgumentError("Key already in use: \"" + key + "\".")
        }

        //regClassAlias(value);
        dictionary[key] = splitInRandomPoints(encode(value), NUMBER_OF_KEYS);
    }

    public static function retrieve(key:String):* {
        var keyHolder:Vector.<String> = dictionary[key];
        return (keyHolder == null)? null : decode(keyHolder.join(""));
    }

    public static function alter(key:String, value:*):void {
        if(key in dictionary) {
            dictionary[key] = splitInRandomPoints(encode(value), NUMBER_OF_KEYS);
        } else {
            //throw new ArgumentError("Key not registered: \"" + key + "\".");
            add(key, value);
        }
    }

    public static function remove(key:String):void {
        delete dictionary[key];
    }

    public static function removeAll():void {
        for (var key:String in dictionary) {
            remove(key);
        }
    }

    //==================================
    //  Tools
    //==================================
    private static function encode(obj:*):String {
        return Base64.encodeObject(obj);
    }

    private static function decode(encodedString:String):* {
        return Base64.decodeObject(encodedString);
    }

    private static function splitInRandomPoints(value:String, n:uint):Vector.<String> {
        var blocks:Vector.<String> = new Vector.<String>();
        var lastIdx:int = 0;
        for (var i:int = 0; i < n; i++) {
            var t:int = (i == n - 1)? value.length : ToolMath.randomRadRange(lastIdx, value.length);
            blocks.push(value.substring(lastIdx, t));
            lastIdx = t;
        }
        return blocks;
    }

    private static function regClassAlias(cl:Class):void {
        if(cl in classAliases)
            return;
        registerClassAlias(getClassName(cl), cl);
        classAliases.push(cl);
    }
}
}
