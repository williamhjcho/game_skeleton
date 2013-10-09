/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/9/13
 * Time: 9:34 AM
 * To change this template use File | Settings | File Templates.
 */
package starling.hero.states {
import starling.display.MovieClip;
import starling.hero.states.base.BaseHeroState;

public class Hero_Walk extends BaseHeroState {


    public function Hero_Walk(animation:MovieClip, changeTo:Function) {
        super(HeroStates.WALK,animation, changeTo, [HeroStates.IDLE, HeroStates.RUN]);

    }

    override protected function onEnter():void {
        super.onEnter();
        this.play();
    }

    override protected function onExit():void {
        super.onExit();
        this.stop();
    }

    override public function onLeftUp    ():void { changeTo.call(this, HeroStates.IDLE); }
    override public function onRightUp   ():void { changeTo.call(this, HeroStates.IDLE); }
    override public function onSpaceDown ():void { changeTo.call(this, HeroStates.JUMP); }

}
}
