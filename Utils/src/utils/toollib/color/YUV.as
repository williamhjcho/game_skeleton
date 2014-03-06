/**
 * Created by William on 3/6/14.
 */
package utils.toollib.color {
import utils.commands.clamp;

public class YUV {

    private static const W_RED:Number = 0.299;
    private static const W_GREEN:Number = 0.587;
    private static const W_BLUE:Number = 0.114;

    private static const U_MAX:Number = 0.436;
    private static const V_MAX:Number = 0.615;

    private var _Y:Number, _U:Number, _V:Number;

    public function YUV(y:Number, u:Number, v:Number) {
        setTo(y, u, v);
    }

    public function setTo(y:Number, u:Number, v:Number):YUV {
        this.Y = y;
        this.U = u;
        this.V = v;
    }

    public function get Y():Number { return _Y; }
    public function get U():Number { return _U; }
    public function get V():Number { return _V; }

    public function set Y(value:Number):void { _Y = clamp(value, 0, 1); }
    public function set U(value:Number):void { _U = clamp(value, -U_MAX, U_MAX); }
    public function set V(value:Number):void { _V = clamp(value, -V_MAX, V_MAX); }

    public function fromInt(color:uint):void {
        fromRGB((color >> 16) & 0xff, (color >> 8) & 0xff, (color) & 0xff);
    }

    public function fromRGB(r:uint, g:uint, b:uint):void {
        _Y = W_RED * r + W_GREEN * g + W_BLUE * b;
        _U = U_MAX * (b - _Y) / (1 - W_BLUE);
        _V = V_MAX * (r - _Y) / (1 - W_RED);
    }

    public function toRGB(alpha:uint = 0xff):uint {
        var r:uint = _Y + _V / 0.877;
        var g:uint = _Y - 0.395 * _U - 0.581 * _V;
        var b:uint = _Y + _U / 0.492;
        return (alpha << 24) | (r << 16) | (g << 8) | (b);
    }

}
}
