/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/9/13
 * Time: 10:36 AM
 * To change this template use File | Settings | File Templates.
 */
package starling.hero.states {
import starling.display.MovieClip;
import starling.hero.states.base.BaseHeroState;

public class Hero_Idle extends BaseHeroState {

    public function Hero_Idle(animation:MovieClip, changeTo:Function) {
        super(HeroStates.IDLE, animation, changeTo, [HeroStates.JUMP, HeroStates.WALK]);
    }

    override protected function onEnter():void {
        super.onEnter();
        this.play();
    }

    override protected function onExit():void {
        super.onExit();
        this.stop();
    }


    override public function onLeftDown  ():void { changeTo.call(this, HeroStates.WALK); }
    override public function onRightDown ():void { changeTo.call(this, HeroStates.WALK); }
    override public function onDownDown  ():void { changeTo.call(this,HeroStates.FRONT); }
    override public function onSpaceDown ():void { changeTo.call(this, HeroStates.JUMP); }
}
}
