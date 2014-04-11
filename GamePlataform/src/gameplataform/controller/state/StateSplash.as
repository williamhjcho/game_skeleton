/**
 * Created by William on 2/18/14.
 */
package gameplataform.controller.state {
import gameplataform.constants.GameStates;
import gameplataform.controller.Game;
import gameplataform.controller.GameMechanics;

public class StateSplash extends BaseState {

    public function StateSplash(game:Game) {
        super(game, GameStates.SPLASH, null, onEnter, onExit);
    }

    private function onEnter():void {
        GameMechanics.addJob(super.machine.changeTo, GameStates.GAME);
    }

    private function onExit():void {

    }
}
}
