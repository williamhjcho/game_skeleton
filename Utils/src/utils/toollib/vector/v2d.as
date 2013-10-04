/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 03/01/13
 * Time: 08:14
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.vector {

public class v2d {

    public var x:Number = 0;
    public var y:Number = 0;

    public function v2d(x:Number = 0, y:Number = 0) {
        this.x = x;
        this.y = y;
    }

    public function setTo(x:Number, y:Number):v2d {
        this.x = x;
        this.y = y;
        return this;
    }

    public function equals(v:Object):Boolean { return (this.x == v.x && this.y == v.y);  }

    public function get length  ():Number { return Math.sqrt(x * x + y * y); }
    public function get length2 ():Number { return x * x + y * y;            }

    public function get normalize():v2d {
        var l:Number = this.length;
        l = (l == 0) ? 1 : l;
        return multiply(1/l);
    }

    public function add         (v:Object)          :v2d { return setTo(this.x + v.x, this.y + v.y); }
    public function addN        (n:Number)          :v2d { return setTo(this.x + n, this.y + n);     }
    public function addXY       (x:Number,y:Number) :v2d { return setTo(this.x + x, this.y + y);     }

    public function subtract    (v:Object)          :v2d { return setTo(this.x - v.x, this.y - v.y); }
    public function subtractN   (n:Number)          :v2d { return setTo(this.x - n, this.y - n);     }
    public function subtractXY  (x:Number,y:Number) :v2d { return setTo(this.x - x, this.y - y);     }

    public function multiply    (n:Number)          :v2d { return setTo(this.x * n, this.y * n);   }
    public function multiplyXY  (x:Number, y:Number):v2d { return setTo(this.x * x, this.y * y);   }

    public function divide    (n:Number)          :v2d { return setTo(this.x / n, this.y / n);   }
    public function divideXY  (x:Number, y:Number):v2d { return setTo(this.x / x, this.y / y);   }

    public function get negative():v2d { return setTo(-x, -y); }

    public function get copy():v2d { return new v2d(this.x, this.y);  }

    public function dot     (u:Object)          :Number { return this.x * u.x + this.y * u.y;      }
    public function dotXY   (x:Number,y:Number) :Number { return this.x * x + this.y * y;       }

    public function angle(u:Object):Number { return Math.acos(dot(u) / (length * v2d.length(u))); }

    public function perpendicularRight   ():v2d { return setTo(this.y, -this.x);    }
    public function perpendicularLeft    ():v2d { return setTo(-this.x, this.y);    }
    public function getPerpendicularRight():v2d { return new v2d(this.y, -this.x);  }
    public function getPerpendicularLeft ():v2d { return new v2d(-this.y, this.x);  }

    public function round():v2d { return setTo(Math.round(x),Math.round(y)); }
    public function floor():v2d { return setTo(Math.floor(x),Math.floor(y)); }
    public function ceil ():v2d { return setTo(Math.ceil (x),Math.ceil (y)); }

    public function distanceTo(v:Object):Number {
        var x:Number = v.x - this.x;
        var y:Number = v.y - this.y;
        return Math.sqrt(x*x + y*y);
    }
    public function distanceToXY(x:Number, y:Number):Number {
        x -= this.x;
        y -= this.y;
        return Math.sqrt(x*x + y*y);
    }
    public function distanceTo2(v:Object):Number {
        var x:Number = v.x - this.x;
        var y:Number = v.y - this.y;
        return x*x + y*y;
    }
    public function distanceToXY2(x:Number, y:Number):Number {
        x -= this.x;
        y -= this.y;
        return x*x + y*y;
    }

    //Projections -> (a.b/b.b) * b
    public function projectOn(v:Object):v2d {
        var scalar:Number = dot(v) / v2d.dot(v, v);
        return setTo(scalar * v.x, scalar * v.y);
    }

    /************************
     *      STATICS
     ************************/
    public static function setTo(v:Object, x:Number, y:Number):Object {
        v.x = x;
        v.y = y;
        return v;
    }

    public static function normalize(v:Object):Object {
        var l:Number = length(v);
        l = (l == 0) ? 1 : l;
        return multiply(v, 1/l);
    }

    public static function getNormalized(v:Object):v2d {
        var l:Number = length(v);
        l = (l == 0) ? 1 : l;
        return new v2d(v.x/l, v.y/l);
    }

    public static function length   (v:Object) :Number { return Math.sqrt(v.x * v.x + v.y * v.y);      }
    public static function length2  (v:Object) :Number { return v.x * v.x + v.y * v.y;                 }

    public static function add      (u:Object, v:Object)            :v2d { return new v2d(u.x+v.x, u.y+v.y); }
    public static function addN     (u:Object, n:Number)            :v2d { return new v2d(u.x + n, u.y + n); }
    public static function addXY    (u:Object, x:Number, y:Number)  :v2d { return new v2d(u.x + x, u.y + y); }

    public static function subtract     (u:Object, v:Object)            :v2d { return new v2d(u.x - v.x, u.y - v.y);    }
    public static function subtractN    (u:Object, n:Number)            :v2d { return new v2d(u.x - n, u.y - n);        }
    public static function subtractXY   (u:Object, x:Number, y:Number)  :v2d { return new v2d(u.x - x, u.y - y);        }

    public static function multiply     (v:Object, n:Number)            :v2d { return new v2d(v.x * n, v.y * n); }
    public static function multiplyXY   (v:Object, x:Number, y:Number)  :v2d { return new v2d(v.x * x, v.y * y); }

    public static function negative     (v:Object)  :v2d { return new v2d(-v.x,-v.y);  }
    public static function getNegative  (v:Object)  :v2d { return new v2d(-v.x, -v.y); }

    public static function equals(u:Object, v:Object):Boolean { return (u.x == v.x && u.y == v.y); }

    public static function dot(u:Object, v:Object):Number {
        return u.x * v.x + u.y * v.y;
    }
    public static function dotXY(ux:Number, uy:Number, vx:Number, vy:Number):Number {
        return ux * vx + uy * vy;
    }

    public static function perpendicularRight(v:Object)     :Object { return setTo(v, v.y, -v.x);   }
    public static function perpendicularLeft(v:Object)      :Object { return setTo(v, -v.x, v.y);   }
    public static function getPerpendicularRight(v:Object)  :v2d    { return new v2d(v.y, -v.x);    }
    public static function getPerpendicularLeft(v:Object)   :v2d    { return new v2d(-v.y, v.x);    }

    public static function distanceFromTo(u:Object, v:Object):Number {
        var x:Number = v.x - u.x;
        var y:Number = v.y - u.y;
        return Math.sqrt(x*x + y*y);
    }

    public static function distanceFromTo2(u:Object, v:Object):Number {
        var x:Number = v.x - u.x;
        var y:Number = v.y - u.y;
        return x*x + y*y;
    }

    public static function project(projected:Object, projectedOnto:Object):Object {
        var scalar:Number = dot(projected, projectedOnto) / dot(projectedOnto, projectedOnto);
        return setTo(projected, scalar * projectedOnto.x, scalar * projectedOnto.y);
    }
    public static function getProjection(projected:Object, projectedOnto:Object):v2d {
        //FORMULA: (a.b_n)*b_n   or   ((a.b)/b.length^2) * b
        var scalar:Number = dot(projected, projectedOnto)/dot(projectedOnto, projectedOnto);
        return new v2d(scalar * projectedOnto.x, scalar * projectedOnto.y);
    }

    /************************
     *          MISC
     ************************/
    public function toString(fixed:int = 4):String {
        return "(x:" + this.x.toFixed(fixed) + ", y:" + this.y.toFixed(fixed) + ")";
    }
}
}
