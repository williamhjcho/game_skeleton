/**
 * Created by William on 2/18/14.
 */
package game.controller.state {
import game.constants.GameState;
import game.controller.Game;
import game.controller.GameMechanics;

public class StateSplash extends BaseState {

    public function StateSplash(game:Game, from:Array = null) {
        super(game, GameState.SPLASH, from);
    }

    override public function onEnter(args:Object = null):void {
        super.onEnter(args);
    }

    override public function onExit(args:Object = null):void {
        super.onExit(args);
    }
}
}
