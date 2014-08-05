/**
 * Created by William on 7/15/2014.
 */
package utilsDisplay.view {
import flash.display.Graphics;

import utils.math.ToolMath;

public class GraphicsEx {

    private var g:Graphics;

    public function GraphicsEx(graphics:Graphics) {
        this.graphics = graphics;
    }

    //==================================
    //
    //==================================
    public function clear():GraphicsEx {
        g.clear();
        return this;
    }

    public function copyFrom(source:*):GraphicsEx {
        var gg:Graphics;
        if(source is GraphicsEx)    gg = GraphicsEx(source).g;
        if(source is Graphics)      gg = source;
        g.copyFrom(gg);
        return this;
    }

    public function beginFill(color:uint, alpha:Number = 1.0):GraphicsEx {
        g.beginFill(color, alpha);
        return this;
    }

    //==================================
    //  Lines / Curves
    //==================================
    public function moveTo(x:Number, y:Number):GraphicsEx {
        g.moveTo(x, y);
        return this;
    }

    public function lineTo(x:Number, y:Number):GraphicsEx {
        g.lineTo(x, y);
        return this;
    }

    public function lineFromTo(x0:Number, y0:Number, x1:Number, y1:Number):GraphicsEx {
        g.moveTo(x0, y0);
        g.lineTo(x1, y1);
        return this;
    }

    public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):GraphicsEx {
        g.curveTo(controlX, controlY, anchorX, anchorY);
        return this;
    }

    public function cubicCurveTo(controlX1:Number, controlY1:Number, controlX2:Number, controlY2:Number, anchorX:Number, anchorY:Number):GraphicsEx {
        g.cubicCurveTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
        return this;
    }

    public function lineToDashed(x0:Number, y0:Number, x1:Number, y1:Number, dashLength:Number, dashSpace:Number):GraphicsEx {
        GraphicsEx.lineDashedTo(g, x0, y0, x1, y1, dashLength, dashSpace);
        return this;
    }

    //==================================
    //  Shapes
    //==================================
    public function drawRectRounded(x:Number, y:Number, width:Number, height:Number, radius:Number):GraphicsEx {
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
        return this;
    }

    //==================================
    //  Get / Set
    //==================================
    public function get graphics():Graphics {
        return g;
    }

    public function set graphics(g:Graphics):void {
        if(g == null) throw new ArgumentError("Graphics cannot be null.");
        this.g = g;
    }

    //==================================
    //  Static
    //==================================
    public static function lineFromTo(g:Graphics, x0:Number, y0:Number, x1:Number, y1:Number):void {
        g.moveTo(x0, y0);
        g.lineTo(x1, y1);
    }

    public static function lineDashedTo(g:Graphics, x0:Number, y0:Number, x1:Number, y1:Number, dashLength:Number, dashSpace:Number):void {
        var d:Number = ToolMath.hypothenuse(x1 - x0, y1 - y0);
        var theta:Number = Math.atan2(y1 - y0, x1 - x0);
        var dx:Number = dashLength * Math.cos(theta), dy:Number = dashLength * Math.sin(theta);
        var sx:Number = dashSpace * Math.cos(theta), sy:Number = dashSpace * Math.sin(theta);
        var n:int = d / (dashLength + dashSpace);
        var x:Number = x0, y:Number = y0;
        for (var i:int = 1; i <= n; i++) {
            g.moveTo(x, y);
            g.lineTo(x + dx, y + dy);
            x = x0 + i * (dx + sx);
            y = y0 + i * (dy + sy);
        }
        //lining to end point(if there is space left)
        g.moveTo(x, y);
        g.lineTo(x1, y1);
    }



}
}
