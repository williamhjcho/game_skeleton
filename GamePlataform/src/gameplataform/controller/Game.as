/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 10:01 AM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.controller {
import gameplataform.constants.States;

import gameplataform.controller.layer.HudController;
import gameplataform.controller.layer.MapController;
import gameplataform.controller.layer.PopUpController;
import gameplataform.controller.state.StateA;
import gameplataform.controller.state.StateB;

import flash.display.Sprite;
import flash.events.Event;

import gameplataform.controller.GameData;

import utils.base.FunctionObject;
import utils.events.StateMachineEvent;
import utils.managers.Pool;
import utils.managers.sounds.SoundManager;
import utils.managers.state.StateMachine;

public class Game {

    public var mapController    :MapController;
    public var hudController    :HudController;
    public var popUpController  :PopUpController;

    private var stateMachine:StateMachine;

    public function Game(mapLayer:Sprite, hudLayer:Sprite, popupLayer:Sprite) {
        mapController   = new MapController     (mapLayer, "MapController");
        hudController   = new HudController     (hudLayer, "HudController");
        popUpController = new PopUpController   (popupLayer, "PopupController");
        stateMachine    = new StateMachine();
    }

    public function initialize():void {
        GameData.stage.addEventListener(Event.ENTER_FRAME, checkJobList);

        SoundManager.volume = GameData.variables.volumeMain;

        initializeStates();
    }

    private function initializeStates():void {
        stateMachine.addEventListener(StateMachineEvent.TRANSITION_COMPLETE, onTransitionComplete);
        stateMachine.addEventListener(StateMachineEvent.TRANSITION_DENIED, onTransitionDenied);

        stateMachine.add(new StateA(this));
        stateMachine.add(new StateB(this));

        stateMachine.changeTo(States.STATE_A);
    }

    /** **/
    private static function onTransitionDenied    (e:StateMachineEvent):void { trace(e); }
    private static function onTransitionComplete  (e:StateMachineEvent):void { trace(e); }

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
