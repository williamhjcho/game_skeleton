/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 3:02 PM
 * To change this template use File | Settings | File Templates.
 */
package starling {

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.TouchEvent;
import starling.images.Ball;
import starling.images.GifMovieClip;
import starling.hero.Hero;
import starling.images.MonaLisa;

import utils.toollib.ToolColor;
import utils.toollib.ToolMath;

public class Game extends Sprite {

    private var hud:Hud;


    public function Game() {
        super();

        this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);

        hud = new Hud();
        hud.initialize();
        addChild(hud);

        drawHero();
    }

    private static const MAX_N:uint = 300;

    private function drawGifMovieClip(x:Number,y:Number):void {
        var movie:GifMovieClip = new GifMovieClip();
        movie.x = x;
        movie.y = y;
        Starling.juggler.add(movie);
        addChild(movie);
    }


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
        //37, 39, 38, 40
        //left right top down
        switch(e.keyCode) {
            case 37: { hero.walk(Hero.LEFT); break; }
            case 39: { hero.walk(Hero.RIGHT); break; }
            case 38: { }
            case 40: { }
        }
    }

    private function moveHeroKeyboardUp(e:KeyboardEvent):void {
        switch(e.keyCode) {
            case 37:
            case 39: hero.stop(); break;
            case 38: { }
            case 40: { }
        }
    }


    private var balls:Vector.<Ball>;
    private function drawBalls():void {
        balls = new Vector.<Ball>(MAX_N);

        for (var i:int = 0; i < MAX_N; i++) {
            var img:Ball = new Ball();
            img.x = ToolMath.randomRange(0, stage.stageWidth);
            img.y = ToolMath.randomRange(0, stage.stageHeight);
            var rad:Number = ToolMath.randomRange(0,ToolMath.TAU);
            var strength:Number = ToolMath.randomRange(1,5);
            img.velocity.setTo(Math.cos(rad) * strength, Math.sin(rad)*strength);

            img.color = ToolColor.random();
            img.scaleX = img.scaleY = ToolMath.randomRange(0.1,1);

            balls[i] = img;

            addChild(img);
        }

        this.addEventListener(EnterFrameEvent.ENTER_FRAME, onUpdateBalls);
    }
    private function onUpdateBalls(e:Event):void {
        for each (var ball:Ball in balls) {
            ball.update();
            if(ball.x < 0 || ball.x > stage.stageWidth)     ball.velocity.x *= -1;
            if(ball.y < 0 || ball.y > stage.stageHeight)    ball.velocity.y *= -1;
        }
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
