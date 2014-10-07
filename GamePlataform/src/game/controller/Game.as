/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 10:01 AM
 * To change this template use File | Settings | File Templates.
 */
package game.controller {
import flash.display.Sprite;

import game.constants.GameState;
import game.controller.data.GameData;
import game.controller.layer.HudController;
import game.controller.layer.MapController;
import game.controller.layer.PopupController;
import game.controller.sound.SoundPlayer;
import game.controller.state.StateGame;
import game.controller.state.StateSplash;
import game.game_internal;

import utils.event.StateMachineEvent;
import utils.sound.SoundUtil;
import utils.sound.SoundManager;
import utils.state.StateMachine;

use namespace SoundUtil;

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
        SoundUtil.volume = GameData.variables.volume_main;

        initializeMachine();

        GameMechanics.game_internal::startClock(1000 / GameData.stage.frameRate);

        stateMachine.changeTo(GameState.SPLASH);
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
