/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 10:01 AM
 * To change this template use File | Settings | File Templates.
 */
package game.controller {
import flash.display.Sprite;

import game.constants.GameStates;
import game.controller.data.GameData;
import game.controller.layer.HudController;
import game.controller.layer.MapController;
import game.controller.layer.PopupController;
import game.controller.sound.SoundPlayer;
import game.controller.state.StateGame;
import game.controller.state.StateSplash;
import game.game_internal;

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
    public var map    :MapController;
    public var hud    :HudController;
    public var popup  :PopupController;

    /**
     * Controls the game flow
     */
    private var stateMachine:StateMachine;

    public function Game(mapLayer:Sprite, hudLayer:Sprite, popupLayer:Sprite) {
        map   = new MapController     (mapLayer);
        hud   = new HudController     (hudLayer);
        popup = new PopupController   (popupLayer);
    }

    public function initialize():void {
        SoundManager.volume = GameData.variables.volumeMain;

        initializeMachine();

        GameMechanics.game_internal::startClock(1000 / GameData.stage.frameRate);
        GameMechanics.addToClock(updateGameInternalMechanics);

        stateMachine.changeTo(GameStates.SPLASH);
    }

    private function initializeMachine():void {
        stateMachine = new StateMachine();
        stateMachine.addEventListener(StateMachineEvent.TRANSITION_COMPLETE, onTransitionComplete);
        stateMachine.addEventListener(StateMachineEvent.TRANSITION_DENIED, onTransitionDenied);

        stateMachine.add(new StateSplash(this, null));
        stateMachine.add(new StateGame(this, null));
    }

    private function updateGameInternalMechanics(dt:uint):void {
        SoundPlayer.game_internal::updateSounds(dt)
    }

    //==================================
    //  State Management
    //==================================
    private static function onTransitionDenied    (e:StateMachineEvent):void { trace(e); }
    private static function onTransitionComplete  (e:StateMachineEvent):void { trace(e); }

}
}
