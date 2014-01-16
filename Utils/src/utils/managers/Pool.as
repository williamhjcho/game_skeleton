/**
 * william.cho
 */
package utils.managers {
import flash.utils.Dictionary;

import utils.commands.getClass;

public final class Pool {

    private static var poolList:Dictionary = new Dictionary();
    private static var types:Vector.<Class> = new Vector.<Class>();

    public static function add(type:Class, n:int = 10):void {
        var pool:Array = poolList[type];

        if(pool == null) {
            types.push(type);
            pool = poolList[type] = [];
        }

        for (var i:int = 0; i < n; i++) {
            var o:* = new type();
            pool.push(o);
        }
    }

    public static function destroy(type:Class):void {
        if(!isRegistered(type)) return;
        delete poolList[type];
        types.splice(types.indexOf(type),1);
    }

    public static function destroyAll():void {
        for each (var type:Class in poolList)
            delete poolList[type];
        types = new Vector.<Class>();
    }

    public static function getItem(type:Class):* {
        if(!isRegistered(type))
            add(type,1);
        var pool:Array = poolList[type];
        return (pool.length > 0) ? pool.pop() : new type();
    }

    public static function returnItem(item:*):int {
        var type:Class = getClass(item);
        var pool:Array = poolList[type];

        if(pool == null) {
            add(type);
            pool = poolList[type];
        }

        pool.push(item);
        return pool.length;
    }

    public static function isRegistered(type:Class):Boolean {
        return (poolList[type] != null && poolList[type] != undefined);
    }

    public static function length():int { return types.length; }

    public static function setLength(type:Class, n:int = 10):void {
        //splices excess instances
        var pool:Array = poolList[type];
        if(pool == null)    return;
        if(pool.length > n) pool.splice(n, pool.length);
    }

    public static function getLength(type:Class):int {
        var pool:Array = poolList[type];
        return (pool == null) ? -1 : pool.length;
    }

    public static function getAllRegisteredClasses():Vector.<Class> {
        var copy:Vector.<Class> = new Vector.<Class>();
        for each (var type:Class in types)
            copy.push(type);
        return copy;
    }


}
}
