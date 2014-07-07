/**
 * Created by William on 2/18/14.
 */
package game.controller.state {
import game.constants.GameStates;
import game.controller.Game;
import game.controller.GameMechanics;

public class StateSplash extends BaseState {

    public function StateSplash(game:Game, from:Array = null) {
        super(game, GameStates.SPLASH, from, onEnter, onExit);
    }

    private function onEnter():void {
        GameMechanics.addJob(super.machine.changeTo, GameStates.GAME);
    }

    private function onExit():void {

    }
}
}
