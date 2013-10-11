/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 3:02 PM
 * To change this template use File | Settings | File Templates.
 */
package starling {

import com.greensock.events.LoaderEvent;

import flash.geom.Point;

import starling.assets.Assets;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.hero.Hero;
import starling.hero.HeroButtonExtended;
import starling.images.MonaLisa;
import starling.minigame.Ball;

import utils.managers.AssetsManager;
import utils.toollib.ToolMath;

public class Game extends Sprite {

    private var hud:Hud;


    public function Game() {
        super();

        this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        AssetsManager.loadSWFAsset("assets/assets.swf",{name:"assets", onComplete:onLoad,autoPlay:false});
        AssetsManager.initialize();

    }

    private function onLoad(l:LoaderEvent):void {
        Assets.initialize();

        hud = new Hud();
        hud.initialize();
        addChild(hud);

        drawHero();
        //drawHeroButton();
      //  drawHeroButtonExtended();
    }

    private static const MAX_N:uint = 300;


    private var hero:Hero;
    private function drawHero():void {
        hero = new Hero();
        hero.x = stage.stageWidth - hero.width >> 1;
        hero.y = stage.stageHeight - hero.height >> 1;
        addChild(hero);

        this.addEventListener(TouchEvent.TOUCH, moveHeroTouch);
        this.addEventListener(KeyboardEvent.KEY_DOWN, moveHeroKeyboardDown);
        this.addEventListener(KeyboardEvent.KEY_UP, moveHeroKeyboardUp);
    }

    private function moveHeroTouch(e:TouchEvent):void {
        //e.getTouch(this, TouchPhase.BEGAN);
    }

    private function moveHeroKeyboardDown(e:KeyboardEvent):void {
        switch(e.keyCode) {
            case 37: { hero.onLeftDown(); break; }
            case 39: { hero.onRightDown(); break; }
            case 38: { hero.onUpDown(); break; }
            case 40: { hero.onDownDown(); break; }
            case 32: { hero.onSpaceDown(); break; }
        }
    }

    private function moveHeroKeyboardUp(e:KeyboardEvent):void {
        switch(e.keyCode) {
            case 37: { hero.onLeftUp(); break; }
            case 39: { hero.onRightUp(); break; }
            case 38: { hero.onUpUp(); break; }
            case 40: { hero.onDownUp(); break; }
            case 32: { hero.onSpaceUp(); break; }
        }
    }


    private var ball1:Ball, ball2:Ball;
    private function drawBall():void {
        ball1 = new Ball(5); addChild(ball1); ball1.x = 50;
        ball2 = new Ball(10); addChild(ball2); ball2.x = 220;
        ball1.y = ball2.y = 420;

        //ball1.addEventListener(TouchEvent.TOUCH, onTouchBall);

        ball1.play();
        ball2.play();
    }

    private function onTouchBall(e:TouchEvent):void {
        var touch:Touch = e.getTouch(ball1);
        if(touch != null) {
            switch (touch.phase) {
                case TouchPhase.BEGAN :
                    ball1.isPressed = true;
                    ball1.isRolledOver = true;
                    break;
                case TouchPhase.ENDED :
                    if(this.hitTest(new Point(touch.globalX, touch.globalY), true) == ball1) {
                        trace("Click");
                    }
                    ball1.isPressed = false;
                    ball1.isRolledOver = false;
                    break;
                case TouchPhase.HOVER :
                    break;
                case TouchPhase.STATIONARY :
                    break;
                case TouchPhase.MOVED :
                    if(this.hitTest(new Point(touch.globalX, touch.globalY), true) != ball1) {
                        ball1.isPressed = false;
                        ball1.isRolledOver = false;
                    }
                    break;
            }
        } else {
            ball1.isPressed = false;

        }
    }


    private var heroButtonExtended:HeroButtonExtended;
    private var countBtnEx:uint = 0;
    private function drawHeroButtonExtended():void {
     //  heroButtonExtended = new HeroButtonExtended(HeroAssets.atlas_front.getTextures(), HeroAssets.atlas_jump.getTextures(), HeroAssets.atlas_walk.getTextures());
        heroButtonExtended.x = 600;
        heroButtonExtended.y = 450;
        addChild(heroButtonExtended);

        heroButtonExtended.addEventListener(Event.TRIGGERED, onTriggerHeroButtonExtended);
    }
    private function onTriggerHeroButtonExtended(e:Event):void {
        countBtnEx++;
    }

    private var monaLisas:Vector.<MonaLisa>;
    private function drawMonalisa():void {
        monaLisas = new Vector.<MonaLisa>(MAX_N);

        for (var i:int = 0; i < MAX_N; i++) {
            var image:MonaLisa = new MonaLisa();
            image.alpha = ToolMath.randomRange(0.1,1);

            image.x = ToolMath.randomRange(0,stage.stageWidth);
            image.y = ToolMath.randomRange(0,stage.stageHeight);
            image.rotation = ToolMath.randomRange(0,ToolMath.TAU);
            image.scaleX = image.scaleY = ToolMath.randomRange(0.1,1);
            image.rot += ToolMath.randomRange(0.1,0.3);

            var theta:Number = ToolMath.randomRadRange(0,ToolMath.TAU);
            var strength:Number = ToolMath.randomRange(1,10);
            image.velocity.setTo(Math.cos(theta) * strength, Math.sin(theta) * strength);

            addChild(image);
            monaLisas[i] = image;
        }

        this.addEventListener(EnterFrameEvent.ENTER_FRAME, onUpdateMonalisa);
    }
    private function onUpdateMonalisa(e:Event):void {
        for each (var img:MonaLisa in monaLisas) {
            img.update();
            if(img.x < 0 || img.x > stage.stageWidth) img.velocity.x *= -1;
            if(img.y < 0 || img.y > stage.stageHeight) img.velocity.y *= -1;
        }
    }

}
}
