/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 5/11/13
 * Time: 4:02 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.color {
public class RGBA {

    private var _color:uint;

    public function RGBA(color:uint) {
        this._color = color;
    }

    public function setRGBA(r:uint, g:uint, b:uint, a:uint = 0xff):RGBA {
        _color = ((a & 0xff) << 24) | ((r & 0xff) << 16) | ((g & 0xff) << 8) | (b & 0xff);
        return this;
    }

    public function setInt(color:uint):RGBA {
        _color = color;
        return this;
    }

    public function copy():RGBA { return new RGBA(_color); }

    public function get R():uint { return (_color >> 16) & 0xff; }
    public function get G():uint { return (_color >>  8) & 0xff; }
    public function get B():uint { return (_color      ) & 0xff; }
    public function get A():uint { return (_color >> 24) & 0xff; }

    public function set R(v:uint):void { _color = (_color & 0xff000000) | ((v & 0xff) << 16) | (_color & 0x0000ffff); }
    public function set G(v:uint):void { _color = (_color & 0xffff0000) | ((v & 0xff) <<  8) | (_color & 0x000000ff); }
    public function set B(v:uint):void { _color = (_color & 0xffffff00) | ((v & 0xff)      )                        ; }
    public function set A(v:uint):void { _color =                         ((v & 0xff) << 24) | (_color & 0x00ffffff); }

    public function get color():uint { return _color; }
    public function toString():String { return "(a:" + A + ", r:" + R + ", g:" + G + ", b:" + B + ", value:" + _color + ")"; }


    public static function fromInt(color:int):RGBA {
        return new RGBA(color);
    }

    public static function toInt(r:int, g:int, b:int, a:int = 0xff):uint {
        return a << 24 | r << 16 | g << 8 | b;
    }
}
}
