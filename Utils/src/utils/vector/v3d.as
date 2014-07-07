/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 03/01/13
 * Time: 08:14
 * To change this template use File | Settings | File Templates.
 */
package utils.vector {
public class v3d {

    public var x:Number = 0;
    public var y:Number = 0;
    public var z:Number = 0;

    public function v3d(x:Number = 0, y:Number = 0, z:Number = 0) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public function setTo(x:Number, y:Number, z:Number):v3d {
        this.x = x;
        this.y = y;
        this.z = z;
        return this;
    }

    public function get normalize():v3d {
        var l:Number = length;
        if(l == 0) return this;
        return multiply(1/l);
    }

    public function get length()    :Number { return Math.sqrt(x * x + y * y + z * z); }
    public function get length2()   :Number { return x * x + y * y + z * z;            }

    public function equals(v:Object):Boolean { return this.x == v.x && this.y == v.y && this.z == v.z; }

    public function add     (v:Object)                      :v3d { return setTo(this.x + v.x, this.y + v.y, this.z + v.z); }
    public function addN    (n:Number)                      :v3d { return setTo(this.x + n, this.y + n, this.z + n);       }
    public function addXYZ  (x:Number, y:Number, z:Number)  :v3d { return setTo(this.x + x, this.y + y, this.z + z);       }

    public function subtract        (v:Object)                      :v3d { return setTo(this.x - v.x, this.y - v.y, this.z - v.z);  }
    public function subtractScalar  (n:Number)                      :v3d { return setTo(this.x - n, this.y - n, this.z - n);        }
    public function subtractXYZ     (x:Number, y:Number, z:Number)  :v3d { return setTo(this.x - x, this.y - y, this.z - z);        }

    public function multiply    (n:Number)                      :v3d { return setTo(this.x * n, this.y * n, this.z * n); }
    public function multiplyXYZ (x:Number, y:Number, z:Number)  :v3d { return setTo(this.x * x, this.y * y, this.z * z); }

    public function divide      (n:Number)                      :v3d { return setTo(this.x / n, this.y / n, this.z / n); }
    public function divideXYZ   (x:Number, y:Number, z:Number)  :v3d { return setTo(this.x / x, this.y / y, this.z / z); }

    public function get negative():v3d { return multiply(-1); }

    public function get copy():v3d { return new v3d(x,y,z); }

    public function dot     (u:Object)                      :Number { return this.x * u.x + this.y * u.y + this.z * u.z;    }
    public function dotXYZ  (x:Number, y:Number, z:Number)  :Number { return this.x * x + this.y * y + this.z * z;          }

    public function cross(u:Object):v3d {
        return new v3d(
                this.y * u.z - this.z * u.y,
                this.z * u.x - this.x * u.z,
                this.x * u.y - this.y * u.x
        );
    }
    public function crossXYZ(x:Number,y:Number,z:Number):v3d {
        return new v3d(
                this.y * z - this.z * y,
                this.z * x - this.z * x,
                this.x * y - this.y * x
        );
    }

    public function round():v3d { return setTo(Math.round(x), Math.round(y), Math.round(z));    }
    public function floor():v3d { return setTo(Math.floor(x), Math.floor(y), Math.floor(z));    }
    public function ceil ():v3d { return setTo(Math.ceil (x), Math.ceil (y), Math.ceil (z));    }

    public function distanceTo(v:Object):Number {
        var x:Number = v.x - this.x;
        var y:Number = v.y - this.y;
        var z:Number = v.z - this.z;
        return Math.sqrt(x*x + y*y + z*z);
    }

    public function distanceTo2(v:Object):Number {
        var x:Number = v.x - this.x;
        var y:Number = v.y - this.y;
        var z:Number = v.z - this.z;
        return x*x + y*y + z*z;
    }

    public function toString(fixed:int = 4):String {
        return "(x:" + this.x.toFixed(fixed) + ", y:" + this.y.toFixed(fixed) + ",z:" + this.z.toFixed(fixed) + ")";
    }

    //==================================
    //     Static
    //==================================
    public static function setTo(v:Object, x:Number, y:Number, z:Number):Object {
        v.x = x;
        v.y = y;
        v.z = z;
        return v;
    }

    public static function normalize(v:Object):v3d {
        var l:Number = length(v);
        if(l == 0) return new v3d(v.x, v.y, v.z);
        return new v3d(v.x / l, v.y / l, v.z / l);
    }

    public static function length(v:Object)                 :Number { return Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z);  }
    public static function add(v:Object, u:Object)          :v3d    { return new v3d(v.x + u.x, v.y + u.y, v.z + u.z);      }
    public static function subtract(v:Object, u:Object)     :v3d    { return new v3d(v.x - u.x, v.y - u.y, v.z - u.z);      }
    public static function addScalar(v:Object,n:Number)     :v3d    { return new v3d(v.x + n, v.y + n, v.z + n);            }
    public static function multiply(v:Object,scalar:Number) :v3d    { return new v3d(v.x*scalar, v.y*scalar, v.z*scalar);   }
    public static function negative(v:Object)               :Object { return multiply(v,-1);                                }
    public static function getNegative(v:Object)            :v3d    { return new v3d(-v.x, -v.y, -v.z);                     }
    public static function copy(v:Object)                   :v3d    { return new v3d(v.x, v.y, v.z); }
    public static function getCopy(v:Object)                :v3d    { return new v3d(v.x, v.y, v.z);                        }
    public static function equals(v:Object,u:Object)        :Boolean{ return (v.x == u.x && v.y == u.y && v.z == u.z);      }
    public static function dot(u:Object,v:Object)           :Number { return v.x * u.x + v.y * u.y + v.z * u.z;             }

    public static function cross(u:Object, v:Object):v3d {
        return new v3d(u.y * v.z - u.z * v.y, u.z * v.x - u.x * v.z, u.x * v.y - u.y * v.x);
    }
    public static function crossXYZ(ux:Number,uy:Number,uz:Number, vx:Number,vy:Number,vz:Number): v3d {
        return new v3d(uy * vz - uz * vy, uz * vx - uz * vx, ux * vy - uy * vx);
    }

    public static function distanceFromTo(u:Object, v:Object):Number {
        var x:Number = v.x - u.x;
        var y:Number = v.y - u.y;
        var z:Number = v.z - u.z;
        return Math.sqrt(x*x + y*y + z*z);
    }

    public static function distanceFromTo2(u:Object, v:Object):Number {
        var x:Number = v.x - u.x;
        var y:Number = v.y - u.y;
        var z:Number = v.z - u.z;
        return x*x + y*y + z*z;
    }
}
}
