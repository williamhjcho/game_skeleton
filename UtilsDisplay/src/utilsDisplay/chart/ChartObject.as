/**
 * Created by William on 8/4/2014.
 */
package utilsDisplay.chart {
import flash.display.Graphics;

public class ChartObject {

    public static const WIDTH:String = "width";
    public static const HEIGHT:String = "height";


    private var _x:Function, _y:Function;
    private var _w:Function, _h:Function;
    private var _g:Graphics;

    public function ChartObject() {
        _g = new Graphics();
        _x = _y = RETURN_0;
        _w = _h = RETURN_0;
    }

    //==================================
    //
    //==================================
    public function attr(prop:String, f:*):ChartObject {
        switch(prop) {
            case WIDTH:
            case HEIGHT:
        }
        return this;
    }

    //==================================
    //
    //==================================
    public function get graphics():Graphics { return _g; }

    public function get x():Number { return _x.apply(this, null); }
    public function set x(n:Number):void { _x = function():Number { return n; }; }

    public function get y():Number { return _y.apply(this, null); }
    public function set y(n:Number):void { _y = function():Number { return n; }; }

    public function get width():Number { return _w.apply(this, null); }
    public function set width(n:Number):void { _w = function():Number { return n; } }

    public function get height():Number { return _h.call(this, null); }
    public function set height(h:Number):void { _h = function():Number { return h; } }


    //==================================
    //
    //==================================
    private static function RETURN_0():Number { return 0; }
}
}
