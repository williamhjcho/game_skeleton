/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/19/13
 * Time: 4:30 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.color {
import utils.toollib.ToolMath;

public class HSL {

    private var h:Number, s:Number, l:Number;

    public function HSL(h:Number = 0, s:Number = 0 , l:Number = 0) {
        this.H = h;
        this.S = s;
        this.L = l;
    }

    public function get H():Number { return h; }
    public function get S():Number { return s; }
    public function get L():Number { return l; }

    public function set H(v:Number):void { this.h = ToolMath.clamp(v,0,360); }
    public function set S(v:Number):void { this.s = ToolMath.clamp(v,0,1);   }
    public function set L(v:Number):void { this.l = ToolMath.clamp(v,0,1);   }

    public function setTo(h:Number, s:Number, l:Number):HSL {
        this.H = h;
        this.S = s;
        this.L = l;
        return this;
    }

    public function fromRGB(red:uint, green:uint, blue:uint):HSL {
        var r:Number = red / 0xff, g:Number = green / 0xff, b:Number = blue / 0xff;
        var max:Number = Math.max(r,g,b), min:Number = Math.min(r,g,b);
        var d:Number = max - min;

        l = (min + max) / 2;

        if(d == 0) {
            h = 0;
            s = 0;
            return this;
        }

        s = d / (1 - Math.abs(2*l - 1));

        if(max == r)
            h = 60 * (((g - b) / d) % 6);
        else if(max == g)
            h = 60 * (((b - r) / d) + 2);
        else
            h = 60 * (((r - g) / d) + 4);

        return this;
    }

    public function toRGB(alpha:int = 0xff):uint {
        var C:Number = (1 - Math.abs(2*l - 1)) * s;
        var X:Number = C * (1 - Math.abs(((h / 60) % 2) - 1));
        var m:Number = l - C/2;
        var r:Number, g:Number, b:Number;
        var h:int = h / 60;
        if(h == 0)  { r = C; g = X; b = 0; } else
        if(h == 1)  { r = X; g = C; b = 0; } else
        if(h == 2)  { r = 0; g = C; b = X; } else
        if(h == 3)  { r = 0; g = X; b = C; } else
        if(h == 4)  { r = X; g = 0; b = C; } else
                    { r = C; g = 0; b = X; }
        return alpha <<24 | (0xff*(r+m)) << 16 | (0xff*(g+m)) << 8 | (0xff*(b+m));
    }

    public function copy(model:HSL):HSL {
        return setTo(model.h,model.s,model.l);
    }

    public function getCopy(output:HSL = null):HSL {
        if(output == null) return new HSL(h,s,l);
        return output.setTo(h,s,l);
    }

    public function toString():String {
        return "(H:"+h+", S:"+s+", L:"+l+")";
    }

    /** Static **/
    public static function fromRGB(red:uint, green:uint, blue:uint):HSL {
        return new HSL().fromRGB(red,green,blue);
    }

    public static function toRGB(h:Number, s:Number, l:Number, alpha:int = 0xff):uint {
        var C:Number = (1 - Math.abs(2*l - 1)) * s;
        var X:Number = C * (1 - Math.abs(((h / 60) % 2) - 1));
        var m:Number = l - C/2;
        var r:Number, g:Number, b:Number;
        var hh:int = h / 60;
        if(hh == 0)  { r = C; g = X; b = 0; } else
        if(hh == 1)  { r = X; g = C; b = 0; } else
        if(hh == 2)  { r = 0; g = C; b = X; } else
        if(hh == 3)  { r = 0; g = X; b = C; } else
        if(hh == 4)  { r = X; g = 0; b = C; } else
        { r = C; g = 0; b = X; }
        return alpha <<24 | (0xff*(r+m)) << 16 | (0xff*(g+m)) << 8 | (0xff*(b+m));
    }
}
}
