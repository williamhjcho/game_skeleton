/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.demonsters.debugger.MonsterDebugger;

import drawing.Drawer;

import flash.display.Graphics;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.getTimer;

import testing.Curver;

import utils.commands.Benchmark;
import utils.events.UEvent;
import utils.managers.serializer.SerializerManager;
import utils.toollib.Bezier;
import utils.toollib.Binomial;
import utils.toollib.Factorial;
import utils.toollib.Fibonacci;
import utils.toollib.Prime;
import utils.toollib.Sorter;

import utils.toollib.ToolColor;
import utils.toollib.ToolMath;
import utils.toollib.color.RGBA;
import utils.toollib.vector.v2d;
import utils.toollib.vector.vNd;

[SWF(width=1024, height=768, backgroundColor = 0x808080, frameRate=60)]
public class Main extends Sprite {

    private var color0:uint, color1:uint;

    public function Main() {
        MonsterDebugger.initialize(this);

        trace(SerializerManager.encodeAndStringfy(new EventCM()))

        hermite();
    }

    private var points:Array;
    private var velocities:Array;

    private function hermite():void {
        points = [];
        velocities = [];

        for (var i:int = 0; i < 4; i++) {
            points[i] = makeSprite(100 + i * 100, 300, 10);
            velocities[i] = makeSprite(points[i].x, points[i].y + (i%2)? 50 : -50, 7);
        }

         this.addEventListener(Event.ENTER_FRAME, onEF);
    }

    private function makeSprite(x:Number, y:Number, radius:Number):Sprite {
        var s:Sprite = new Sprite();
        s.x = x;
        s.y = y;
        s.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
        s.addEventListener(MouseEvent.MOUSE_UP, onUp);
        var g:Graphics = s.graphics;
        g.beginFill(ToolColor.random());
        g.drawCircle(0, 0, radius);
        g.endFill();
        addChild(s);
        return s;
    }

    private function onDown(e:MouseEvent):void {
        var target:Sprite = e.currentTarget as Sprite;
        target.startDrag(false);
    }

    private function onUp(e:MouseEvent):void {
        var target:Sprite = e.currentTarget as Sprite;
        target.stopDrag();
    }

    private function onEF(e:Event):void {
        var g:Graphics = this.graphics;
        g.clear();
        g.lineStyle(3, 0xff0000);
        g.moveTo(points[0].x, points[0].y);

        for each (var point:Object in Bezier.catmullRom(points, 100)) {
            g.lineTo(point.x, point.y);
        }

        //for (var i:int = 0; i < points.length - 1; i++) {
        //    var A:Sprite = points[i];
        //    var B:Sprite = points[i+1];
        //    var U:Sprite = velocities[i];
        //    var V:Sprite = velocities[i+1];
        //    for (var t:Number = 0; t <= 1.0; t+= 0.02) {
        //        var r:v2d = Curver.hermite(t, A, B, U, V);
        //        g.lineTo(r.x, r.y);
        //    }
        //}
        //
        g.lineStyle(3, 0x00ff00);
        for(var j:int = 0 ; j < points.length; j++) {
            g.moveTo(points[j].x, points[j].y);
            g.lineTo(velocities[j].x, velocities[j].y)
        }
    }
}
}
