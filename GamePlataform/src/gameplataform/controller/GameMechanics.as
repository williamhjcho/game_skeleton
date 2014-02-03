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
    private static var _clocks:Vector.<Function> = new Vector.<Function>();
    public static function addToClock(f:Function):void {
        _clocks.push(f);
    }

    public static function removeFromClock(f:Function):void {
        var i:int = _clocks.indexOf(f);
        if(i != -1) _clocks.splice(i, 1);
    }

    internal static function checkClock(t:Number):void {
        for each (var f:Function in _clocks) {
            f.call(null, t);
        }
    }

}
}
