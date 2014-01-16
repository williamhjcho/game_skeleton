/**
 * Created by William on 1/15/14.
 */
package gameplataform.controller {
import utils.base.FunctionObject;
import utils.managers.Pool;

public final class GameMechanics {

    private static var jobs:Vector.<FunctionObject> = new Vector.<FunctionObject>();

    internal static function checkJobList():void {
        if(jobs.length == 0) return;
        var job:FunctionObject = jobs.shift();
        job.execute();
        job.destroy();
        Pool.returnItem(job);
    }

    public static function addJob(f:Function, ...params):void {
        var job:FunctionObject = Pool.getItem(FunctionObject);
        job.func = f;
        job.parameters = params;
        jobs.push(job);
    }

}
}
