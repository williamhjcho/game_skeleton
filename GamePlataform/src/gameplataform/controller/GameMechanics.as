/**
 * Created by William on 1/15/14.
 */
package gameplataform.controller {

import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.getTimer;

import utils.base.interfaces.IUpdatable;

import utils.managers.Juggler;
import gameplataform.utils.game_internal;

import utils.base.FunctionObject;
import utils.managers.Pool;

/**
 * Has mechanics accessible to the whole game, controlled by Game
 */
public final class GameMechanics {

    //==================================
    //  Timer
    //==================================
    private static var _timer:Timer;
    private static var _lastTimeStamp:uint = 0;

    game_internal static function startClock(millis:uint):void {
        if(_timer != null) {
            _timer.removeEventListener(TimerEvent.TIMER, _onTick);
        }
        _timer = new Timer(millis);
        _timer.addEventListener(TimerEvent.TIMER, _onTick);
        _timer.start();
        _lastTimeStamp = getTimer();
    }

    private static function _onTick(e:TimerEvent):void {
        var t:uint = getTimer();
        var dt:uint = t - _lastTimeStamp;
        _lastTimeStamp = t;
        checkJobList();
        checkClock(dt);
        checkJuggler(dt);
    }

    //==================================
    //  Job
    //==================================
    private static var _jobs:Vector.<FunctionObject> = new Vector.<FunctionObject>();

    public static function addJob(f:Function, ...params):void {
        var job:FunctionObject = Pool.getItem(FunctionObject);
        job.reset(f, params);
        _jobs.push(job);
    }

    public static function removeJob(f:Function):void {
        var index:int = _jobs.indexOf(f);
        if(index != -1) _jobs[index] = null;
    }

    private static function checkJobList():void {
        var len:int = _jobs.length;
        for (var i:int = 0; i < len; i++) {
            if(_jobs[i] != null) {
                _jobs[i].execute().destroy();
                Pool.returnItem(_jobs[i]);
                _jobs[i] = null;
            }
        }
        _jobs.splice(0, len);
    }

    //==================================
    //  Clock
    //==================================
    private static var _clocks:Vector.<Function> = new Vector.<Function>();

    public static function addToClock(f:Function):void {
        _clocks.push(f);
    }

    public static function removeFromClock(f:Function):void {
        var i:int = _clocks.indexOf(f);
        if(i != -1) _clocks[i] = null;
    }

    private static function checkClock(dt:uint):void {
        var len:int = _clocks.length;
        var currentIndex:int = 0;
        for (var i:int = 0; i < len; i++) {
            if(_clocks[i] != null) {
                //pushing down through gaps
                if(currentIndex != i) {
                    _clocks[currentIndex] = _clocks[i];
                    _clocks[i] = null;
                }

                _clocks[currentIndex].call(null, dt);

                currentIndex++;
            }
        }

        if(currentIndex != i) {
            len = _clocks.length;
            while(i < len) {
                _clocks[currentIndex++] = _clocks[i++];
            }
            _clocks.length = currentIndex;
        }
    }

    //==================================
    //  Juggler
    //==================================
    private static var _juggler:Juggler = new Juggler();

    public static function addToJuggler(element:IUpdatable):void { _juggler.add(element); }
    public static function removeFromJuggler(element:IUpdatable):void { _juggler.remove(element); }

    public static function addDelay(seconds:Number, f:Function, params:Array = null):void {
        _juggler.delayCall(f, seconds * 1000, params);
    }

    private static function checkJuggler(dt:uint):void {
        _juggler.update(dt);
    }


}
}