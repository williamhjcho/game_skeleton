/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/23/13
 * Time: 1:07 PM
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Rectangle;

import utils.toollib.ToolColor;

public class Bar extends Sprite {

    private var _color:uint;
    private var area:Rectangle;

    public function Bar(width:Number, height:Number) {
        _color = ToolColor.random();
        area = new Rectangle(
                0,
                0,
                width,
                height
        );
        draw();
    }

    private function draw():void {
        var g:Graphics = this.graphics;
        g.beginFill(_color);
        g.drawRect(area.x, area.y, area.width, area.height);
        g.endFill();
    }
}
}
