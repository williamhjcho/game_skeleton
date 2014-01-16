/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 10:01 AM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.controller {
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.getTimer;

import gameplataform.constants.States;
import gameplataform.controller.layer.HudController;
import gameplataform.controller.layer.MapController;
import gameplataform.controller.layer.PopUpController;
import gameplataform.controller.state.StateA;
import gameplataform.controller.state.StateB;

import utils.events.StateMachineEvent;
import utils.managers.sounds.SoundManager;
import utils.managers.state.StateMachine;

public final class Game {

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
        GameData.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

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

    //==================================
    //
    //==================================
    private static var _lastTimeStamp:Number = 0;
    private static function onEnterFrame(e:Event):void {
        var t:Number = getTimer() / 1000.0;
        var dt:Number = t - _lastTimeStamp;
        _lastTimeStamp = t;
        GameMechanics.checkJobList();
    }
}
}
