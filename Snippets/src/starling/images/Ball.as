/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/8/13
 * Time: 12:07 PM
 * To change this template use File | Settings | File Templates.
 */
package starling.images {
import flash.display.BitmapData;
import flash.display.Shape;

import starling.display.Image;
import starling.textures.Texture;

import utils.toollib.ToolColor;

import utils.toollib.vector.v2d;

public class Ball extends Image {

    private static const TEXTURE:Texture = getTexture();

    public var velocity:v2d = new v2d(0,0);

    private static function getTexture():Texture {
        var shape:Shape = new Shape();
        var radius:Number = 20;
        var color:uint = ToolColor.random();

        shape.graphics.beginFill(color);
        shape.graphics.drawCircle(radius,radius,radius);
        shape.graphics.endFill();

        var bmd:BitmapData = new BitmapData(radius*2, radius*2, true, 0);
        bmd.draw(shape);
        return Texture.fromBitmapData(bmd);
    }

    public function Ball() {
        super(TEXTURE);
    }

    public function update():void {
        this.x += velocity.x;
        this.y += velocity.y;
    }
}
}
