/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/29/13
 * Time: 9:19 AM
 * To change this template use File | Settings | File Templates.
 */
package menu {
import flash.display.Graphics;
import flash.display.Sprite;


public class ItemCustom extends Sprite {

    private var g:Graphics;
    public function ItemCustom(width:Number, height:Number, color:uint) {
        g = this.graphics;
        g.beginFill(color);
        g.drawRect(0,0,width,height);
        g.endFill();
    }
}
}
