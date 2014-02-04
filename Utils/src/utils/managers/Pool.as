/**
 * william.cho
 */
package utils.managers {
import flash.utils.Dictionary;

import utils.commands.getClass;

/**
 * Simple Pool Manager of Objects
 * This class CANNOT deal with constructors that require parameters
 */
public final class Pool {

    private static var poolList:Dictionary = new Dictionary();
    private static var types:Vector.<Class> = new Vector.<Class>();

    /**
     * Adds a new Class to the Pool
     * @param type Class to be added
     * @param n Number of instances to be created automatically
     */
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

    /**
     * Removes the pool of that Class
     * @param type
     */
    public static function destroy(type:Class):void {
        if(!isRegistered(type)) return;
        delete poolList[type];
        types.splice(types.indexOf(type),1);
    }

    /**
     * Removes all pools
     */
    public static function destroyAll():void {
        for each (var type:Class in poolList)
            delete poolList[type];
        types = new Vector.<Class>();
    }

    /**
     * Retrieves (or instantiates) an item from that class
     * @param type
     */
    public static function getItem(type:Class):* {
        if(!isRegistered(type))
            add(type,1);
        var pool:Array = poolList[type];
        return (pool.length > 0) ? pool.pop() : new type();
    }

    /**
     * Returns an item to the pool
     * @param item Item to be returned
     * @return Returns the pool length
     */
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
        return (type in poolList);
    }

    /**
     * @return Returns the number of Classes registered
     */
    public static function length():int { return types.length; }

    /**
     * @param type Class pool to be altered
     * @param n Number to limit that pool, (it will NOT create new instances)
     */
    public static function setLength(type:Class, n:int = 10):void {
        //splices excess instances
        var pool:Array = poolList[type];
        if(pool == null)    return;
        if(pool.length > n) pool.splice(n, pool.length);
    }

    /**
     * @param type Class pool
     * @return returns the pool length of that Class
     */
    public static function getLength(type:Class):int {
        var pool:Array = poolList[type];
        return (pool == null) ? -1 : pool.length;
    }

    /**
     * @return Returns a new list of all registered classes;
     */
    public static function getAllRegisteredClasses():Vector.<Class> {
        return types.concat();
    }


}
}
