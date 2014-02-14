/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/18/13
 * Time: 11:07 AM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.controller.state {
import gameplataform.constants.GameStates;
import gameplataform.controller.Game;

import utilsDisplay.managers.buttons.ButtonManager;

public class StateA extends BaseState {

    public function StateA(game:Game) {
        super(game, GameStates.STATE_A, null, onEnter, onExit);
    }

    private function onEnter():void {

    }

    private function onExit():void {

    }
}
}
