/**
 * Created by William on 7/29/2014.
 */
package utils.systems {
import flash.display.Graphics;

public class TurtleGraphics {

    private var turtle:Graphics;

    private var _x:Number, _y:Number,
                dx:Number, dy:Number,
                a:Number;
    private var saved_position      :Vector.<Number>,
                saved_angle         :Vector.<Number>,
                saved_posAndAngle   :Vector.<Number>;

    public function TurtleGraphics(g:Graphics) {
        if(g == null)
            throw new ArgumentError("Graphics g cannot be null.");
        this.turtle = g;
        clear(false);
    }

    //==================================
    //  Commands
    //==================================
    public function clear(clearGraphics:Boolean):void {
        if(clearGraphics) turtle.clear();
        saved_position    = new Vector.<Number>();
        saved_angle       = new Vector.<Number>();
        saved_posAndAngle = new Vector.<Number>();
        _x = _y = 0;
        angle = 0;
        turtle.moveTo(_x, _y);
    }

    public function moveTo(x:Number, y:Number):TurtleGraphics {
        this._x = x;
        this._y = y;
        turtle.moveTo(x, y);
        return this;
    }

    public function moveForward(length:Number):TurtleGraphics {
        return moveTo(_x + length * dx, _y + length * dy);
    }

    public function moveBackward(length:Number = NaN):TurtleGraphics {
        return moveTo(_x - length * dx, _y - length * dy);
    }

    public function lineTo(x:Number, y:Number):TurtleGraphics {
        this._x = x;
        this._y = y;
        turtle.lineTo(x, y);
        return this;
    }

    public function lineForward(length:Number = NaN):TurtleGraphics {
        return lineTo(_x + length * dx, _y + length * dy);
    }

    public function lineBackward(length:Number = NaN):TurtleGraphics {
        return lineTo(_x - length * dx, _y - length * dy);
    }

    public function turn(deg:Number):TurtleGraphics {
        angle += deg;
        return this;
    }

    //==================================
    //  Get / Set
    //==================================
    public function setPosition(x:Number, y:Number):TurtleGraphics  {
        this._x = x;
        this._y = y;
    }

    public function get x():Number          { return _x; }
    public function set x(n:Number):void    { _x = n; }

    public function get y():Number          { return _y; }
    public function set y(n:Number):void    { _y = n; }

    public function set angle(n:Number):void {
        a = n;
        dx = Math.cos(a);
        dy = Math.sin(a);
    }

    public function get angle():Number {
        return a;
    }

    //==================================
    //  Save / Resume
    //==================================
    public function save():TurtleGraphics {
        saved_posAndAngle.push(_x,_y,a);
        return this;
    }

    public function resume():TurtleGraphics {
        if(saved_posAndAngle.length >= 3) {
            this.angle = saved_posAndAngle.pop();
            this._y = saved_posAndAngle.pop();
            this._x = saved_posAndAngle.pop();
        }
        return this;
    }

    public function saveAngle():TurtleGraphics {
        saved_angle.push(a);
        return this;
    }

    public function resumeAngle():TurtleGraphics {
        if(saved_angle.length > 0)
            this.angle = saved_angle.pop();
        return this;
    }

    public function savePosition():TurtleGraphics {
        saved_position.push(_x, _y);
        return this;
    }

    public function resumePosition():TurtleGraphics {
        if(saved_position.length >= 2) {
            this._y = saved_position.pop();
            this._x = saved_position.pop();
        }
        return this;
    }


}
}