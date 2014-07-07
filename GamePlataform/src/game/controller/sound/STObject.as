/**
 * Created by William on 7/1/2014.
 */
package game.controller.sound {

//==================================
//  Sound Track Object
//==================================
internal class STObject {
    public var sound        :String = null;
    public var timeElapsed  :uint = 0, timeTotal  :uint = 0;
    public var volumeStart:Number = 0, volumeEnd:Number = 0;

    public function STObject() {

    }

    public function get timeProgress():Number {
        if(timeTotal == 0) return 0;
        if(timeElapsed >= timeTotal) return 1.0;
        return timeElapsed / timeTotal;
    }

    public function get isTimeComplete():Boolean {
        return timeElapsed >= timeTotal;
    }


    public static var pool:Vector.<STObject> = new Vector.<STObject>();

    public static function fromPool():STObject {
        return (pool.length > 0)? pool.pop() : new STObject();
    }

    public static function toPool(instance:STObject):void {
        pool.push(instance);
    }
}
}
