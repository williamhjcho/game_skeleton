/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/9/13
 * Time: 9:32 AM
 * To change this template use File | Settings | File Templates.
 */
package starling.hero.states.base {
import starling.display.MovieClip;
import utils.managers.state.State;

public class BaseHeroState extends State {

    public var animation:MovieClip;
    protected var changeTo:Function;

    public function BaseHeroState(type:String, animation:MovieClip, changeTo:Function, from:* = null) {
        super(type, from, onEnter, onExit);
        this.animation = animation;
        this.changeTo = changeTo;
    }

    protected function onEnter():void {
        animation.visible = true;
    }

    protected function onExit():void {
        animation.visible = false;
    }


    public function set visible(v:Boolean):void {
        if(!v) animation.stop();
        animation.visible = v;
    }

    public function play():void {
        animation.play();
    }

    public function pause():void {
        animation.pause();
    }

    public function stop():void {
        animation.stop();
    }


    /** Input Methods **/
    public function onLeftDown  ():void {}
    public function onLeftUp    ():void {}
    public function onRightDown ():void {}
    public function onRightUp   ():void {}
    public function onUpDown    ():void {}
    public function onUpUp      ():void {}
    public function onDownDown  ():void {}
    public function onDownUp    ():void {}
    public function onSpaceDown ():void {}
    public function onSpaceUp   ():void {}

}
}
