/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.demonsters.debugger.MonsterDebugger;

import flash.display.MovieClip;

import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import scrl.Scroll;
import scrl.ScrollParams;

[SWF(width=1024, height=768, backgroundColor = 0x808080, frameRate=60)]
public class Main extends Sprite {

    public function Main() {
        MonsterDebugger.initialize(this);

        scrollTest();
    }

    private var scroll:Scroll, sParams:ScrollParams = new ScrollParams();
    private var container:SimpleChild = new SimpleChild(300,200,"rect", 0x00ff0000);
    private var content:SimpleChild = new SimpleChild(200,100,"circle", 0xff00ff00);
    private var tV:SimpleChild = new SimpleChild(30,100), kV:SimpleChild = new SimpleChild(30, 30);
    private var tH:SimpleChild = new SimpleChild(100,30), kH:SimpleChild = new SimpleChild(30, 30);
    private function scrollTest():void {
        container.x = 10;
        container.y = 10;
        addChild(container);
        addChild(tV);
        addChild(kV);
        addChild(tH);
        addChild(kH);
        scroll = new Scroll(container, content, sParams);
        scroll.setVerticalComponents(tV,kV);
        scroll.setHorizontalComponents(tH,kH);

        stage.addEventListener(KeyboardEvent.KEY_UP, press);
    }

    private function press(e:KeyboardEvent):void {
        //trace(e.keyCode);
        switch(e.keyCode) {
            case 87: content.height += 50; break;
            case 65: content.width  -= 50; break;
            case 83: content.height -= 50; break;
            case 68: content.width  += 50; break;
        }
    }




    private var bar:Bar;
    private var drag:Rectangle;
    private function barTest():void {
        bar = new Bar(20, 70);
        bar.x = stage.stageWidth/2;
        bar.y = stage.stageHeight/2;
        drag = new Rectangle(bar.x, bar.y, 0, 100);
        addChild(bar);

        bar.addEventListener(MouseEvent.ROLL_OVER, onOver);
    }

    private function onDown(e:MouseEvent):void {
        trace("down");
        bar.addEventListener(MouseEvent.MOUSE_UP, onUp);
        bar.startDrag(false, drag);
    }
    private function onUp(e:MouseEvent):void {
        trace("up");
        bar.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        bar.stopDrag();
    }

    private function onOver(e:MouseEvent):void {
        trace("over");
        bar.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
        bar.addEventListener(MouseEvent.ROLL_OUT, onOut);
    }
    private function onOut(e:MouseEvent):void {
        trace("out");
        bar.stopDrag();
        bar.removeEventListener(MouseEvent.ROLL_OUT, onOut);
    }
}
}
