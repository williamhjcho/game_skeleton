/**
 * Created by William on 1/15/14.
 */
package gameplataform.controller {

import flash.utils.getTimer;

import utils.base.FunctionObject;
import utils.commands.execute;
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

    public static function removeJob(f:Function):void {
        for (var i:int = 0; i < _jobs.length; i++) {
            if(_jobs[i].func == f) {
                _jobs.splice(i, 1);
                return;
            }
        }
    }

    internal static function checkJobList():void {
        if(_jobs.length == 0) return;
        for each (var job:FunctionObject in _jobs) {
            job.execute();
            job.destroy();
            Pool.returnItem(job);
        }
        _jobs.splice(0,_jobs.length);
    }

    //==================================
    //  Clock
    //==================================
    private static var _lastTimeStamp:uint = 0;
    private static var _clock:Clock;
    private static var _clocks:Vector.<Function> = new Vector.<Function>();
    [ArrayElementType("DelayedFunction")]
    private static var _delayed:Array = [];

    internal static function startClock(millis:uint, onTick:Function, onTickParams:Array = null, repeatCount:uint = 0, onComplete:Function = null, onCompleteParams:Array = null):void {
        _clock ||= new Clock();
        _clock.start(millis, repeatCount);
        _clock.setTickFunction(onTick, onTickParams);
        _clock.setCompleteFunction(onComplete, onCompleteParams);
        _lastTimeStamp = getTimer();
    }

    internal static function checkClock():void {
        var t:uint = getTimer();
        var dt:uint = t - _lastTimeStamp;
        var dtSeconds:Number = dt / 1000.0;
        _lastTimeStamp = t;

        for each (var f:Function in _clocks) {
            f.call(null, dtSeconds);
        }

        for (var i:int = 0; i < _delayed.length; i++) {
            _delayed[i].delay -= dt;
            if(_delayed[i].delay <= 0) {
                execute(_delayed[i].f, _delayed[i].fp);
                Pool.returnItem(_delayed[i]);
                _delayed[i].destroy();
                _delayed.splice(i, 1);
                i--;
            }
        }
    }

    public static function addToClock(f:Function):void {
        _clocks.push(f);
    }

    public static function removeFromClock(f:Function):void {
        var i:int = _clocks.indexOf(f);
        if(i != -1) _clocks.splice(i, 1);
    }

    public static function addDelay(seconds:Number, f:Function, params:Array = null):void {
        var d:DelayedFunction = Pool.getItem(DelayedFunction);
        d.setValues(seconds * 1000, f, params);
        _delayed.push(d);
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

    public function setTickFunction(f:Function, params:Array = null):void {
        this.f = f;
        this.fp = params;
    }

    public function setCompleteFunction(f:Function, params:Array = null):void {
        this.fc = f;
        this.fcp = params;
    }

    public function reset():void {
        timer.reset();
    }

    public function stop():void {
        timer.stop();
    }

    public function get isRunning():Boolean {
        return timer != null && timer.running;
    }

    public function destroy():void {
        f = null;
        fp = null;
        fc = null;
        fcp = null;
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

final class DelayedFunction {

    public var delay:int;
    public var f:Function, fp:Array;

    public function setValues(delay:int, f:Function, fp:Array = null):void {
        if(f == null) throw new ArgumentError("Function cannot be null.");
        this.delay = (delay <= 0) ? 0 : delay;
        this.f = f;
        this.fp = fp;
    }


    public function destroy():void {
        this.delay = 0;
        this.f = null;
        this.fp = null;
    }
}
