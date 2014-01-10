/**
 * Created by William on 1/9/14.
 */
package {
import flash.display.Bitmap;
import flash.display.BitmapData;

import utils.toollib.Prime;

import utils.toollib.ToolColor;
import utils.toollib.vector.v2d;

public class UlamSpiral {

    public static var color0:uint = ToolColor.random();
    public static var color1:uint = ToolColor.opposite(color0);

    private var canvas:BitmapData;
    private var spiral:Vector.<Boolean>;

    public function UlamSpiral(width:Number, height:Number) {
        canvas = new BitmapData(width, height);
        spiral = new Vector.<Boolean>();
        spiral.length = width * height;
        spiral.fixed = true;
    }

    public function calculate():void {
        var length:uint = spiral.length;
        var x:uint = canvas.width>>1, y:uint = canvas.height>>1;
        var direction:v2d = new v2d(1,0);
        var d:uint = 1, l:uint = 0;

        for (var i:int = 0; i < length; i++) {
            spiral[i] = Prime.isPrime(i);

            canvas.setPixel(x,y,spiral[i]? color1 : color0);
            x += direction.x;
            y += direction.y;


        }
    }

    public function get image():Bitmap {
        return new Bitmap(canvas);
    }

}
}

import utils.toollib.vector.v2d;

class Turtle {

    private var _position:v2d = new v2d(0,0);
    private var _direction:v2d = new v2d(0,0);

    private function forward():void {
        _position.x += _direction.x;
        _position.y += _direction.y;
    }

    private function turnLeft():void {
        _direction.x
    }

    private function turnRight():void {

    }

    private function get position():v2d {
        return _position;
    }
}
