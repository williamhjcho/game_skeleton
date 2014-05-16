/**
 * Created by William on 12/12/13.
 */
package testing {
import flash.display.Graphics;

public class Drawer {

    public static function rectangleRounded(g:Graphics, x:Number, y:Number, width:Number, height:Number, radius:Number):Graphics {
        if(g == null) throw new Error("Graphics [g] cannot be null.");

        //top left
        g.moveTo(x, y + radius);
        g.curveTo(x, y, x + radius, y);

        //top right
        g.lineTo(x + width - radius, y);
        g.curveTo(x + width, y, x + width, y + radius);

        //bottom right
        g.lineTo(x + width, y + height - radius);
        g.curveTo(x + width, y + height, x + width - radius, y + height);

        //bottom left
        g.lineTo(x + radius, y + height);
        g.curveTo(x , y + height, x, y + height - radius);

        //back to top left
        g.lineTo(x, y + radius);

        return g;
    }



}
}
