/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.demonsters.debugger.MonsterDebugger;

import flash.display.Graphics;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import utils.toollib.ToolMath;
import utils.toollib.color.Colors;
import utils.toollib.geometry.Triangle;
import utils.toollib.vector.v2d;

[SWF(width=960, height=600, backgroundColor=0x808080, frameRate=30)]
public class Main extends MovieClip {

    [Embed(source="../output/mona_lisa.jpg")]
    private static const MONA_LISA:Class;

    public function Main() {
        MonsterDebugger.initialize(this);
        testTriangle();
    }

    private var data:Triangle;
    private var vertices:Vector.<Sprite> = new Vector.<Sprite>();
    private var g:Graphics;

    private function testTriangle():void {
        g = this.graphics;
        data = new Triangle(new v2d(), new v2d(), new v2d());

        for (var i:int = 0; i < 3; i++) {
            vertices.push(new Sprite());
            with(vertices[i].graphics) {
                beginFill(Colors.random());
                drawCircle(0, 0, 5);
                endFill();
            }
            vertices[i].x = ToolMath.randomRadRange(100, 500);
            vertices[i].y = ToolMath.randomRadRange(100, 500);
            vertices[i].addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            vertices[i].addEventListener(MouseEvent.MOUSE_UP, onUp);
            addChild(vertices[i]);
        }

        this.addEventListener(Event.ENTER_FRAME, update);
    }

    private function update(e:Event):void {
        g.clear();
        g.lineStyle(3, 0xff0000);

        data.a.setTo(vertices[0].x, vertices[0].y);
        data.b.setTo(vertices[1].x, vertices[1].y);
        data.c.setTo(vertices[2].x, vertices[2].y);

        g.moveTo(data.a.x, data.a.y);
        g.lineTo(data.b.x, data.b.y);
        g.lineTo(data.c.x, data.c.y);
        g.lineTo(data.a.x, data.a.y);

        var v:v2d;
        //centroid
        v = data.centroid;
        g.lineStyle(0);
        g.beginFill(0x550f00);
        g.drawCircle(v.x, v.y, 5);

        //median
        g.beginFill(0x13f012);
        v = data.medianAB;
        g.drawCircle(v.x, v.y, 3);

        v = data.medianBC;
        g.drawCircle(v.x, v.y, 3);

        v = data.medianCA;
        g.drawCircle(v.x, v.y, 3);
    }

    private function onDown(e:MouseEvent):void {
        var target:Sprite = e.currentTarget as Sprite;
        target.startDrag(true);
    }

    private function onUp(e:MouseEvent):void {
        var target:Sprite = e.currentTarget as Sprite;
        target.stopDrag();
    }



}
}
