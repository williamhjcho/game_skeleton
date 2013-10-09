/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/9/13
 * Time: 10:21 AM
 * To change this template use File | Settings | File Templates.
 */
package starling.hero.states {
import starling.display.MovieClip;
import starling.hero.states.base.BaseHeroState;

public class Hero_Jump extends BaseHeroState {


    public function Hero_Jump(animation:MovieClip, changeTo:Function) {
        super(HeroStates.JUMP,animation, changeTo, [HeroStates.IDLE, HeroStates.WALK, HeroStates.RUN]);
    }

    override public function onSpaceUp   ():void { changeTo.call(this, HeroStates.IDLE); }
}
}
