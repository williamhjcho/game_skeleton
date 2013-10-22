/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 5/11/13
 * Time: 4:02 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.color {
public class RGBA {

    private var r:uint;
    private var g:uint;
    private var b:uint;
    private var a:uint;

    public function RGBA(r:uint = 0xff, g:uint = 0xff, b:uint = 0xff, a:uint = 0xff) {
        this.R = r;
        this.G = g;
        this.B = b;
        this.A = a;
    }

    public function setTo(r:uint, g:uint, b:uint, a:uint = 0xff):RGBA {
        this.R = r;
        this.G = g;
        this.B = b;
        this.A = a;
        return this;
    }

    public function getCopy(output:RGBA = null):RGBA {
        if(output == null) return new RGBA(r,g,b,a);
        return output.setTo(r,g,b,a);
    }

    public function copy(model:RGBA):RGBA {
        return setTo(model.r,model.g,model.b,model.a);
    }


    public function get R():uint { return this.r; }
    public function get G():uint { return this.g; }
    public function get B():uint { return this.b; }
    public function get A():uint { return this.a; }

    public function set R(v:uint):void { this.r = v & 0xff; }
    public function set G(v:uint):void { this.g = v & 0xff; }
    public function set B(v:uint):void { this.b = v & 0xff; }
    public function set A(v:uint):void { this.a = v & 0xff; }

    public function fromInt(color:uint):RGBA {
        this.r = color >> 24 & 0xff;
        this.g = color >> 16 & 0xff;
        this.b = color >> 8  & 0xff;
        this.a = color & 0xff;
        return this;
    }

    public function toInt():uint        { return a << 24 | r << 16 | g << 8 | b; }
    public function toString():String   { return "(a:" + a + ", r:" + r + ", g:" + g + ", b:" + b + ")";  }

    public static function fromInt(color:int):RGBA {
        var rgba:RGBA = new RGBA();
        rgba.r = color >> 24 & 0xff;
        rgba.g = color >> 16 & 0xff;
        rgba.b = color >> 8  & 0xff;
        rgba.a = color & 0xff;
        return rgba;
    }

    public static function toInt(r:int, g:int, b:int, a:int = 0xff):uint {
        return a << 24 | r << 16 | g << 8 | b;
    }
}
}
