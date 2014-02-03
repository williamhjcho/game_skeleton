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

import gameplataform.constants.GameStates;
import gameplataform.controller.layer.HudController;
import gameplataform.controller.layer.MapController;
import gameplataform.controller.layer.PopupController;
import gameplataform.controller.state.StateA;

import utils.events.StateMachineEvent;
import utils.managers.sounds.SoundManager;
import utils.managers.state.StateMachine;

/**
 * This class:
 *  - controls the game pipeline (NOT the individual state mechanics)
 *
 */
public final class Game {

    /**
     * Layer controllers
     */
    public var mapController    :MapController;
    public var hudController    :HudController;
    public var popUpController  :PopupController;

    /**
     * Controls the game flow
     */
    private var stateMachine:StateMachine;

    public function Game(mapLayer:Sprite, hudLayer:Sprite, popupLayer:Sprite) {
        mapController   = new MapController     (mapLayer);
        hudController   = new HudController     (hudLayer);
        popUpController = new PopupController   (popupLayer);
        stateMachine    = new StateMachine();
    }

    public function initialize():void {
        SoundManager.volume = GameData.variables.volumeMain;

        initializeStates();

        _lastTimeStamp = getTimer() / 1000.0;
        GameData.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function initializeStates():void {
        stateMachine.addEventListener(StateMachineEvent.TRANSITION_COMPLETE, onTransitionComplete);
        stateMachine.addEventListener(StateMachineEvent.TRANSITION_DENIED, onTransitionDenied);

        stateMachine.add(new StateA(this));

        stateMachine.changeTo(GameStates.STATE_A);
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
        GameMechanics.checkClock(dt);
    }
}
}
