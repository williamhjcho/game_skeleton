/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 3/9/13
 * Time: 7:33 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.math {
public class Complex {

    public var x:Number;
    public var y:Number;

    public function Complex(real:Number = 0, imaginary:Number = 0) {
        this.x = real;
        this.y = imaginary;
    }

    public function setTo(real:Number, imaginary:Number):Complex {
        this.x = real;
        this.y = imaginary;
        return this;
    }

    public function copy(z:Complex) :Complex { return setTo(z.x,z.y); }
    public function getCopy()       :Complex { return new Complex(this.x,this.y); }

    public function get length()    :Number { return Math.sqrt(x*x + y*y);  }
    public function get length2()   :Number { return x*x + y*y;             }

    public function get phase()     :Number { return Math.atan2(this.y,this.x);    }

    public function get conjugate() :Complex { return setTo(this.x, -this.y);    }
    public function getConjugate()  :Complex { return new Complex(this.x,-this.y);    }

    public function get reciprocal():Complex {
        var scale:Number = x*x + y*y;
        return setTo(this.x / scale, this.y / scale);
    }

    public function getReciprocal():Complex {
        var scale:Number = x*x + y*y;
        return new Complex(this.x / scale, this.y / scale);
    }

    public function add(z:Complex)        :Complex { return setTo(this.x + z.x, this.y + z.y); }
    public function addXY(real:Number, imaginary:Number):Complex { return setTo(this.x + real, this.y + imaginary); }
    public function subtract(z:Complex)   :Complex { return setTo(this.x + z.x, this.y + z.y); }
    public function subtractXY(real:Number, imaginary:Number):Complex { return setTo(this.x - real, this.y - imaginary); }

    public function multiplyN(n:Number):Complex { return setTo(this.x * n, this.y * n); }
    public function multiply(z:Complex):Complex {
        return setTo((this.x * z.x) - (this.y * z.y),(this.x * z.y) + (this.y * z.x));
    }

    public function divideN(n:Number):Complex { return setTo(this.x / n, this.y / n); }
    public function divide(z:Complex):Complex {
        var div:Number = z.x * z.x + z.y * z.y;
        return setTo((this.x * z.x + this.y * z.y) / div, (this.y * z.x - this.x * z.y) / div);
    }

    public function addScalar(scalar:Number)        :Complex { return setTo(this.x + scalar, this.y + scalar); }
    public function multiplyScalar(scalar:Number)   :Complex { return setTo(this.x * scalar, this.y * scalar); }

    public function exp():Complex { return new Complex(Math.exp(this.x) * Math.cos(this.y), Math.exp(this.x) * Math.sin(this.y)); }

    public function powerBy(n:int):Complex {
        if(n == 0) return setTo(1,0);
        if(n == 1) return this;
        var sumReal:Number = 0, sumImg:Number = 0;
        var signal:int = 1;
        var k:int;
        for (k = 1; k <= n; k+=2) {
            sumReal += signal * Binomial.get(n, k-1) * Math.pow(x, n - k-1) * Math.pow(y, k-1);
            sumImg  += signal * Binomial.get(n, k  ) * Math.pow(x, n - k  ) * Math.pow(y, k  );
            signal *= -1;
        }
        if(n%2 == 0) {
            sumReal += signal * Math.pow(y, n);
        }
        return setTo(sumReal, sumImg);
    }

    public function toString():String {
        if(this.y < 0)  return "("+this.x + " - " + -this.y + "i)";
        else            return "("+this.x + " + " + this.y  + "i)";
    }


    /** STATICS **/
    public static function add(z1:Complex, z2:Complex):Complex {
        return new Complex(z1.x + z2.x, z1.y + z2.y);
    }

    public static function subtract(z1:Complex, z2:Complex):Complex {
        return new Complex(z1.x - z2.x, z1.y - z2.y);
    }

    public static function multiply(z1:Complex, z2:Complex):Complex {
        return new Complex((z1.x * z2.x) - (z1.y * z2.y), (z1.x * z2.y) + (z1.y * z2.x));
    }

    public static function divide(z1:Complex, z2:Complex):Complex {
        var div:Number = z2.x * z2.x + z2.y * z2.y;
        return new Complex((z1.x * z2.x + z1.y * z2.y)/ div, (z1.y * z2.x - z1.x * z2.y) / div);
    }


}
}
