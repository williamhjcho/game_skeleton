/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/8/13
 * Time: 3:00 PM
 * To change this template use File | Settings | File Templates.
 */
package starling.hero {
import starling.core.Starling;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.events.Event;
import starling.hero.states.HeroOrientation;
import starling.hero.states.HeroStates;
import starling.hero.states.Hero_Front;
import starling.hero.states.Hero_Idle;
import starling.hero.states.Hero_Jump;
import starling.hero.states.Hero_Walk;
import starling.hero.states.base.BaseHeroState;
import utils.managers.state.StateMachine;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

import utils.managers.state.StateMachineEvent;

import utils.toollib.vector.v2d;

public class Hero extends Sprite {



    private var stateMachine:StateMachine;

    private var _orientation:uint = -1;

    private var velocity:v2d = new v2d(0,0);

    public function Hero() {
        super();

        stateMachine = new StateMachine();
        stateMachine.addEventListener(StateMachineEvent.TRANSITION_DENIED, onDenied);
        stateMachine.addEventListener(StateMachineEvent.TRANSITION_COMPLETE, onComplete);
        stateMachine.add(new Hero_Idle  (createAnimation(HeroAssets.ATLAS_IDLE.getTextures()   , 12), stateMachine.changeTo));
        stateMachine.add(new Hero_Front (createAnimation(HeroAssets.ATLAS_FRONT.getTextures()  , 12), stateMachine.changeTo));
        stateMachine.add(new Hero_Walk  (createAnimation(HeroAssets.ATLAS_WALK.getTextures()   , 12), stateMachine.changeTo));
        stateMachine.add(new Hero_Jump  (createAnimation(HeroAssets.ATLAS_JUMP.getTextures()   , 12), stateMachine.changeTo));
        stateMachine.changeTo(HeroStates.IDLE);

        orientation = HeroOrientation.LEFT;
    }

    private function onDenied(e:StateMachineEvent):void {
        trace("Denied : " + e.from, e.to);
    }

    private function onComplete(e:StateMachineEvent):void {
        trace("Complete : "+ e.from, e.to);
    }


    private function createAnimation(textures:Vector.<Texture>, fps:uint):MovieClip {
        var animation:MovieClip = new MovieClip(textures, fps);
        Starling.juggler.add(animation);
        animation.x = -animation.width/2;
        animation.y = -animation.height;
        animation.loop = true;
        animation.pause();
        animation.visible = false;
        addChild(animation);
        return animation;
    }


    /** Input Methods **/
    public function onLeftDown  ():void { BaseHeroState(stateMachine.currentState).onLeftDown   (); orientation = HeroOrientation.LEFT; }
    public function onLeftUp    ():void { BaseHeroState(stateMachine.currentState).onLeftUp     (); }
    public function onRightDown ():void { BaseHeroState(stateMachine.currentState).onRightDown  (); orientation = HeroOrientation.RIGHT; }
    public function onRightUp   ():void { BaseHeroState(stateMachine.currentState).onRightUp    (); }
    public function onUpDown    ():void { BaseHeroState(stateMachine.currentState).onUpDown     (); }
    public function onUpUp      ():void { BaseHeroState(stateMachine.currentState).onUpUp       (); }
    public function onDownDown  ():void { BaseHeroState(stateMachine.currentState).onDownDown   (); }
    public function onDownUp    ():void { BaseHeroState(stateMachine.currentState).onDownUp     (); }
    public function onSpaceDown ():void { BaseHeroState(stateMachine.currentState).onSpaceDown  (); }
    public function onSpaceUp   ():void { BaseHeroState(stateMachine.currentState).onSpaceUp    (); }


    /** Animation/Manipulation Methods **/
    public function set orientation(o:uint):void {
        switch (o) {
            case HeroOrientation.LEFT : setLeft(); break;
            case HeroOrientation.RIGHT: setRight(); break;
            case HeroOrientation.UP   :
            case HeroOrientation.DOWN :
            case HeroOrientation.FRONT:
            case HeroOrientation.BACK :
        }
    }

    public function setLeft():void {
        if(_orientation != HeroOrientation.LEFT) {
            scaleX = -1;
            _orientation = HeroOrientation.LEFT;
        }
    }

    public function setRight():void {
        if(_orientation != HeroOrientation.RIGHT) {
            scaleX = 1;
            _orientation = HeroOrientation.RIGHT;
        }
    }
}
}
