/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 8/24/13
 * Time: 5:43 PM
 * To change this template use File | Settings | File Templates.
 */
package controller {
import utils.managers.state.StateMachine;
import utils.managers.state.StateMachineEvent;

public class GameStates {

    public static const STATE_1:String = "state.1";
    public static const STATE_2:String = "state.2";
    public static const STATE_3:String = "state.3";

    private var stateMachine:StateMachine;
    private var game:GameController;

    public function GameStates() {
    }

    public function initialize(game:GameController):void {
        this.game = game;

        stateMachine = new StateMachine();
        stateMachine.addEventListener(StateMachineEvent.TRANSITION_COMPLETE, onStateMachineComplete);
        stateMachine.addEventListener(StateMachineEvent.TRANSITION_DENIED, onStateMachineDenied);

        stateMachine.add(STATE_1,{onEnter:enState, onExit:exState, from:"*"});
        stateMachine.add(STATE_2,{onEnter:enState, onExit:exState, from:STATE_1});
        stateMachine.add(STATE_3,{onEnter:enState, onExit:exState, from:STATE_2});
    }

    public function set state(s:String):void { stateMachine.changeTo(s); }
    public function get state():String { return stateMachine.currentName; }


    /** States **/
    private function onStateMachineComplete (e:StateMachineEvent):void { trace(e);  }
    private function onStateMachineDenied   (e:StateMachineEvent):void { trace(e);  }

    private function enState(e:StateMachineEvent):void {  }
    private function exState(e:StateMachineEvent):void {  }
}
}
