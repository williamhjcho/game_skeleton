/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/23/13
 * Time: 1:28 PM
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.display.Graphics;
import flash.display.Sprite;

import utils.toollib.ToolColor;

public class SimpleChild extends Sprite {

    public function SimpleChild(width:Number, height:Number, type:String = "rect", color:uint = NaN) {
        draw(width, height, type, isNaN(color)? ToolColor.random() : color);
    }

    public function draw(width:Number, height:Number, type:String, color:uint):void {
        var g:Graphics = this.graphics;
        g.beginFill(color, 0.5);
        switch(type) {
            case "rect":    g.drawRect(0,0,width,height);     break;
            case "circle":  g.drawCircle(width,width,width);  break;
        }
        g.endFill();
    }

    override public function toString():String {
        return "("+this.width + ", " + this.height+")";
    }
}
}
