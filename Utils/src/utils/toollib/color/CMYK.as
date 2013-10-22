/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 07/05/13
 * Time: 14:02
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.color {
import utils.toollib.ToolMath;

public class CMYK {

    private var c:Number, m:Number, y:Number, k:Number;

    public function CMYK(c:Number = 0, m:Number = 0, y:Number = 0, k:Number = 0) {
        this.C = c;
        this.M = m;
        this.Y = y;
        this.K = k;
    }

    public function get C():Number { return this.c; }
    public function get M():Number { return this.m; }
    public function get Y():Number { return this.y; }
    public function get K():Number { return this.k; }

    public function set C(v:Number):void { this.c = ToolMath.clamp(v,0,1); }
    public function set M(v:Number):void { this.m = ToolMath.clamp(v,0,1); }
    public function set Y(v:Number):void { this.y = ToolMath.clamp(v,0,1); }
    public function set K(v:Number):void { this.k = ToolMath.clamp(v,0,1); }

    public function setTo(c:Number = 0, m:Number = 0, y:Number = 0, k:Number = 0):CMYK {
        this.C = c;
        this.M = m;
        this.Y = y;
        this.K = k;
        return this;
    }

    public function fromRGB(red:uint, green:uint, blue:uint):CMYK {
        var r:Number = red / 0xff, g:Number = green / 0xff, b:Number = blue / 0xff;
        k = 1 - Math.max(r,g,b);
        var k1:Number = 1 - k;
        c = (k1 - r) / k1;
        m = (k1 - g) / k1;
        y = (k1 - b) / k1;
        return this;
    }

    public function toRGB(alpha:uint = 0xff):uint {
        var kMinus:Number = 1-k;
        return (alpha << 24) | (0xff*(1-c)*kMinus) << 16 | (0xff*(1-m)*kMinus) << 8 | (0xff*(1-y)*kMinus);
    }

    public function copy(model:CMYK):CMYK {
        return setTo(model.c,model.m,model.y,model.k);
    }

    public function getCopy(output:CMYK):CMYK {
        if(output == null) return new CMYK(c,m,y,k);
        return output.setTo(c,m,y,k);
    }

    public function toString():String {
        return "(C:" + c + ", M:" + m + ", Y:" + y + ", K:" + k +")";
    }

    /** Static **/
    public static function fromRGB(red:uint, green:uint, blue:uint):CMYK {
        return new CMYK().fromRGB(red,green,blue);
    }

    public static function toRGB(c:Number = 0, m:Number = 0, y:Number = 0, k:Number = 0, alpha:uint = 0xff):uint {
        var kMinus:Number = 1-k;
        return (alpha << 24) | (0xff*(1-c)*kMinus) << 16 | (0xff*(1-m)*kMinus) << 8 | (0xff*(1-y)*kMinus);
    }
}
}
