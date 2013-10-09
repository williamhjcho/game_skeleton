/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/9/13
 * Time: 10:38 AM
 * To change this template use File | Settings | File Templates.
 */
package starling.hero.states {
import starling.display.MovieClip;
import starling.hero.states.base.BaseHeroState;

public class Hero_Front extends BaseHeroState {

    public function Hero_Front(animation:MovieClip, changeTo:Function) {
        super(HeroStates.FRONT, animation, changeTo, [HeroStates.IDLE]);
    }
}
}
