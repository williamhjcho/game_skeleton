/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 10:01 AM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.controller {
import flash.display.Sprite;

import gameplataform.constants.GameStates;
import gameplataform.controller.data.GameData;
import gameplataform.controller.layer.HudController;
import gameplataform.controller.layer.MapController;
import gameplataform.controller.layer.PopupController;
import gameplataform.controller.state.StateGame;
import gameplataform.controller.state.StateSplash;
import gameplataform.utils.game_internal;

import utils.events.StateMachineEvent;
import utils.managers.sounds.SoundManager;
import utils.managers.state.StateMachine;

use namespace game_internal;

/**
 * This class:
 *  - controls the main game pipeline (NOT the individual state mechanics)
 *  - Does NOT have access to layers directly, use layer controllers instead of this class
 */
public final class Game {

    /**
     * Layer controllers
     */
    public var mapController    :MapController;
    public var hudController    :HudController;
    public var popupController  :PopupController;

    /**
     * Controls the game flow
     */
    private var stateMachine:StateMachine;

    public function Game(mapLayer:Sprite, hudLayer:Sprite, popupLayer:Sprite) {
        mapController   = new MapController     (mapLayer);
        hudController   = new HudController     (hudLayer);
        popupController = new PopupController   (popupLayer);

    }

    public function initialize():void {
        SoundManager.volume = GameData.variables.volumeMain;

        initializeMachine();

        GameMechanics.game_internal::startClock(1000 / GameData.stage.frameRate);

        stateMachine.changeTo(GameStates.SPLASH);
    }

    private function initializeMachine():void {
        stateMachine = new StateMachine();
        stateMachine.addEventListener(StateMachineEvent.TRANSITION_COMPLETE, onTransitionComplete);
        stateMachine.addEventListener(StateMachineEvent.TRANSITION_DENIED, onTransitionDenied);

        stateMachine.add(new StateSplash(this, null));
        stateMachine.add(new StateGame(this, null));
    }

    //==================================
    //  State Management
    //==================================
    private static function onTransitionDenied    (e:StateMachineEvent):void { trace(e); }
    private static function onTransitionComplete  (e:StateMachineEvent):void { trace(e); }

}
}
