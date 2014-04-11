/**
 * Created by William on 1/15/14.
 */
package gameplataform.controller {

import utils.base.FunctionObject;
import utils.managers.Pool;

/**
 * Has mechanics accessible to the whole game, controlled by Game
 */
public final class GameMechanics {

    //==================================
    //  Job
    //==================================
    private static var _jobs:Vector.<FunctionObject> = new Vector.<FunctionObject>();
    public static function addJob(f:Function, ...params):void {
        var job:FunctionObject = Pool.getItem(FunctionObject);
        job.func = f;
        job.parameters = params;
        _jobs.push(job);
    }

    internal static function checkJobList():void {
        for each (var job:FunctionObject in _jobs) {
            job.execute();
            job.destroy();
            Pool.returnItem(job);
        }
        _jobs = new Vector.<FunctionObject>();
        Pool.setLength(FunctionObject, 5);
    }

    //==================================
    //  Clock
    //==================================
    private static var _clock:Clock;
    private static var _clocks:Vector.<Function> = new Vector.<Function>();

    public static function startClock(t:uint, onTick:Function, onTickParams:Array = null, repeatCount:uint = 0, onComplete:Function = null, onCompleteParams:Array = null):void {
        _clock ||= new Clock();
        _clock.start(t, repeatCount);
        _clock.setTickFunction(onTick, onTickParams);
        _clock.setCompleteFunction(onComplete, onCompleteParams);
    }

    public static function addToClock(f:Function):void {
        _clocks.push(f);
    }

    public static function removeFromClock(f:Function):void {
        var i:int = _clocks.indexOf(f);
        if(i != -1) _clocks.splice(i, 1);
    }

    internal static function checkClock(...params):void {
        for each (var f:Function in _clocks) {
            f.call(null, params);
        }
    }

}
}

import flash.events.TimerEvent;
import flash.utils.Timer;

import utils.base.interfaces.IDestructible;

final class Clock implements IDestructible {

    private var timer:Timer;
    private var f:Function, fp:Array;
    private var fc:Function, fcp:Array;
    private var lastDelay:int = -1, lastRepeatCount:int = -1;

    public function start(delayInMillis:uint, repeatCount:uint):void {
        //if the values are different from last time
        if(delayInMillis != lastDelay || repeatCount != lastRepeatCount) {
            lastDelay = delayInMillis;
            lastRepeatCount = repeatCount;
            //destroying the last timer
            if(timer != null) {
                timer.removeEventListener(TimerEvent.TIMER, onTick);
                timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
                timer = null;
            }
            timer = new Timer(delayInMillis, repeatCount);
            timer.addEventListener(TimerEvent.TIMER, onTick);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
        } else if(timer == null) {
            timer = new Timer(delayInMillis, repeatCount);
            timer.addEventListener(TimerEvent.TIMER, onTick);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
        }
        timer.start();
    }

    public function reset():void {
        timer.reset();
    }

    public function stop():void {
        timer.stop();
    }

    public function get isActive():Boolean {
        return timer != null && timer.running;
    }

    public function setTickFunction(f:Function, params:Array = null):void {
        this.f = f;
        this.fp = params;
    }

    public function setCompleteFunction(f:Function, params:Array = null):void {
        this.fc = f;
        this.fcp = params;
    }

    public function destroy():void {
        if(timer != null) {
            timer.removeEventListener(TimerEvent.TIMER, onTick);
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
            timer = null;
        }
    }

    //==================================
    //  Events
    //==================================
    private function onTick(e:TimerEvent):void {
        if(f != null)
            f.apply(this, fp);
    }

    private function onTimerComplete(e:TimerEvent):void {
        if(fc != null)
            fc.apply(this, fcp);
    }

}
