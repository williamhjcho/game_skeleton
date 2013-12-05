/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 22/05/13
 * Time: 08:41
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib {
public class Polynomial {
    /** form: x^0 x^1 x^2 ... x^degree **/

    private var deg:int; //degree
    private var cff:Vector.<Number>; //coefficients

    public function Polynomial(degree:int, a:Number = 1) {
        this.deg = degree;
        this.cff = new Vector.<Number>(degree+1);
        this.cff[deg] = a;
    }

    public function set(...coefficients):Polynomial {
        for (var c:int = 0; c < cff.length && c < coefficients.length; c++)
            cff[c] = coefficients[c];
        deg = degree;
        return this;
    }


    /** OPERATIONS **/
    public function equals(q:Polynomial):Boolean {
        var p:Polynomial = this;
        if(p.deg != q.deg) return false;
        for (var i:int = 0; i <= p.deg; i++) {
            if(p.cff[i] != q.cff[i]) return false;
        }
        return true;
    }

    public function add(q:Polynomial):Polynomial {
        var p:Polynomial = this, r:Polynomial = new Polynomial(Math.max(p.deg, q.deg), 0);
        var c:int;
        for (c = 0; c <= p.deg; c++) { r.cff[c] += p.cff[c]; }
        for (c = 0; c <= q.deg; c++) { r.cff[c] += q.cff[c]; }
        r.deg = r.degree;
        return r;
    }

    public function addToCoefficients(...values):Polynomial {
        for (var c:int = 0; c < cff.length && c < values.length; c++)
            cff[c] += values[c];
        deg = degree;
        return this;
    }

    public function subtract(q:Polynomial):Polynomial {
        var p:Polynomial = this, r:Polynomial = new Polynomial(Math.max(p.deg, q.deg), 0);
        var c:int;
        for (c = 0; c <= p.deg; c++) { r.cff[c] += p.cff[c]; }
        for (c = 0; c <= q.deg; c++) { r.cff[c] -= q.cff[c]; }
        r.deg = r.degree;
        return r;
    }

    public function multiply(q:Polynomial):Polynomial {
        var p:Polynomial = this, r:Polynomial = new Polynomial(p.deg + q.deg, 0);
        for (var i:int = 0; i < p.deg; i++) {
            for (var j:int = 0; j < q.deg; j++) {
                r.cff[i+j] += p.cff[i] * q.cff[j];
            }
        }
        r.deg = r.degree;
        return r;
    }

    public function multiplyBy(n:Number):Polynomial {
        for (var c:int = 0; c < cff.length; c++)
            cff[c] *= n;
        deg = degree;
        return this;
    }

    public function compose(q:Polynomial):Polynomial {
        //Horner's method
        var p:Polynomial = this, r:Polynomial = new Polynomial(0,0);
        for (var i:int = p.deg; i >= 0; i--) {
            var term:Polynomial = new Polynomial(0, p.cff[i]);
            r = term.add(q.multiply(r));
        }
        return r;
    }

    public function evaluate(x:Number):Number {
        //Horner's method
        var r:Number = 0;
        for (var i:int = deg; i >= 0; i--)
            r = cff[i] + (r * x);
        return r;
    }

    public function differentiate():Polynomial {
        if(deg == 0) return new Polynomial(0,0);
        var r:Polynomial = new Polynomial(deg - 1, 0);
        for (var c:int = deg; c > 0; c--)
            r.cff[c-1] = cff[c]*c;
        r.deg = r.degree;
        return r;
    }


    /** GET/SET/MISC **/
    public function get degree():int {
        for (var i:int = cff.length-1; i >= 0; i--)
            if(cff[i] != 0) return i;
        return 0;
    }

    public function get coefficients():Vector.<Number> { return this.cff; }


    public function toString(inverted:Boolean = false, variable:String = "x"):String {
        if(deg == 0) return cff[0].toString();

        var start:int, end:int, dir:int;
        if(inverted) { start = deg; end = 0; dir = -1; }
        else         { start = 0; end = deg; dir =  1; }

        var s:String = "";
        for (var c:int = start; c != end + dir; c+=dir) {
            if(cff[c] == 0) continue;

            if(cff[c] > 0) s += (s.length > 0? " + " : "") +   cff[c].toString();
            else             s += " - " + (-cff[c]).toString();

            if(c == 0)  continue;
            if(c == 1)  s += variable;
            else        s += variable + "^" + c.toString();
        }
        return s;
    }
}
}
