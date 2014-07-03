/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/25/13
 * Time: 7:11 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.color {
import utils.toollib.math.ToolMath;

public class HSV {

    private var h:Number, s:Number, v:Number;

    public function HSV(h:Number = 0, s:Number = 0, v:Number = 0) {
        this.H = h;
        this.S = s;
        this.V = v;
    }

    public function get H():Number { return h; }
    public function get S():Number { return s; }
    public function get V():Number { return v; }

    public function set H(v:Number):void { this.h = ToolMath.clamp(v,0, 360); }
    public function set S(v:Number):void { this.s = ToolMath.clamp(v,0, 1); }
    public function set V(v:Number):void { this.v = ToolMath.clamp(v,0, 1); }

    public function setTo(h:Number, s:Number, v:Number):HSV {
        this.H = h;
        this.S = s;
        this.V = v;
        return this;
    }

    public function fromRGB(red:int, green:int, blue:int):HSV {
        var r:Number = red / 0xff, g:Number = green / 0xff, b:Number = blue / 0xff;
        var max:Number = Math.max(r,g,b), min:Number = Math.min(r,g,b);
        var d:Number = max - min;

        v = max;

        if(d == 0) {
            h = 0;
            s = 0;
            return this;
        }

        s = d / max;

        if(max == r)
            h = 60 * (((g - b) / d) % 6);
        else if(max == g)
            h = 60 * (((b - r) / d) + 2);
        else
            h = 60 * (((r - g) / d) + 4);

        return this;
    }

    public function toRGB(alpha:int = 0xff):uint {
        var C:Number = v * s;
        var X:Number = C * (1 - Math.abs(((h/60)%2)) - 1);
        var m:Number = v - C;
        var r:Number, g:Number, b:Number;
        var h:int = h / 60;
        if(h == 0)  { r = C; g = X; b = 0; } else
        if(h == 1)  { r = X; g = C; b = 0; } else
        if(h == 2)  { r = 0; g = C; b = X; } else
        if(h == 3)  { r = 0; g = X; b = C; } else
        if(h == 4)  { r = X; g = 0; b = C; } else
                    { r = C; g = 0; b = X; }
        return alpha << 24 | (0xff*(r+m)) << 16 | (0xff*(g+m)) << 8 | (0xff*(b+m));
    }

    public function copy(model:HSV):HSV {
        return setTo(model.h,model.s,model.v);
    }

    public function getCopy(output:HSV = null):HSV {
        if(output == null) return new HSV(h,s,v);
        return output.setTo(h,s,v);
    }

    public function toString():String {
        return "(H:"+h+", S:"+s+", V:"+v+")";
    }

    /** Static **/
    public static function fromRGB(red:int, green:int, blue:int):HSV {
        var hsv:HSV = new HSV();
        var r:Number = red / 0xff, g:Number = green / 0xff, b:Number = blue / 0xff;
        var max:Number = Math.max(r,g,b), min:Number = Math.min(r,g,b);
        var d:Number = max - min;

        hsv.v = max;

        if(d == 0) {
            hsv.h = 0;
            hsv.s = 0;
            return hsv;
        }

        hsv.s = d / max;

        if(max == r)
            hsv.h = 60 * (((g - b) / d) % 6);
        else if(max == g)
            hsv.h = 60 * (((b - r) / d) + 2);
        else
            hsv.h = 60 * (((r - g) / d) + 4);

        return hsv;
    }

    public static function toRGB(h:Number, s:Number, v:Number , alpha:int = 0xff):uint {
        var C:Number = v * s;
        var X:Number = C * (1 - Math.abs(((h/60)%2)) - 1);
        var m:Number = v - C;
        var r:Number, g:Number, b:Number;
        var hh:int = h / 60;
        if(hh == 0)  { r = C; g = X; b = 0; } else
        if(hh == 1)  { r = X; g = C; b = 0; } else
        if(hh == 2)  { r = 0; g = C; b = X; } else
        if(hh == 3)  { r = 0; g = X; b = C; } else
        if(hh == 4)  { r = X; g = 0; b = C; } else
        { r = C; g = 0; b = X; }
        return alpha << 24 | (0xff*(r+m)) << 16 | (0xff*(g+m)) << 8 | (0xff*(b+m));
    }

}
}
