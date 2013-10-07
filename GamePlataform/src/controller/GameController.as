/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 10:01 AM
 * To change this template use File | Settings | File Templates.
 */
package controller {
import controller.layer.HudController;
import controller.layer.MapController;
import controller.layer.PopUpController;

import flash.display.MovieClip;
import flash.events.Event;

import model.GameData;

import utils.base.FunctionObject;
import utils.managers.Pool;

import utils.managers.sounds.SoundManager;

public class GameController {

    public var mapController    :MapController;
    public var hudController    :HudController;
    public var popUpController  :PopUpController;

    private var states:GameStates;

    public function GameController(mapLayer:MovieClip, hudLayer:MovieClip, popupLayer:MovieClip) {
        mapController   = new MapController(mapLayer, "GC.MapController");
        hudController   = new HudController(hudLayer, "GC.HudController");
        popUpController = new PopUpController(popupLayer, "GC.PopupController");
        states          = new GameStates();
    }

    public function initialize():void {
        GameData.stage.addEventListener(Event.ENTER_FRAME, checkJobList);

        SoundManager.volume = GameData.variables.volumeMain;

        states.initialize(this);
        states.state = GameStates.STATE_1;
    }

    /** **/
    private static var jobs:Vector.<FunctionObject> = new Vector.<FunctionObject>();

    private function checkJobList(e:Event):void {
        if(jobs.length == 0) return;
        var job:FunctionObject = jobs.shift();
        job.execute(this);
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
