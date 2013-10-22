/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/18/13
 * Time: 11:10 AM
 * To change this template use File | Settings | File Templates.
 */
package controller.state {
import constants.States;

import controller.Game;

public class StateB extends BaseState {

    public function StateB(game:Game) {
        super(game, States.STATE_B, [States.STATE_A], onEnter, onExit);
    }

    private function onEnter():void {

    }

    private function onExit():void {

    }
}
}
