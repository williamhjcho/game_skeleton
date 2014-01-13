/**
 * Created by William on 1/13/14.
 */
package utils.toollib {
public class DualNumber {

    //Dual number has the form : Z = a + b * e
    private var _a:Number; //real party
    private var _b:Number; //dual part

    public function DualNumber(a:Number = 0, b:Number = 0) {
        this._a = a;
        this._b = b;
    }

    public function get a():Number { return _a; }
    public function get b():Number { return _b; }

    public function sum(z:DualNumber):DualNumber {
        return new DualNumber(
                _a + z._a,
                _b + z._b
        );
    }

    public function subtract(z:DualNumber):DualNumber {
        return new DualNumber(
                _a - z._a,
                _b - z._b
        );
    }

    public function multiply(z:DualNumber):DualNumber {
        return new DualNumber(
                _a * z._a,
                _a * z._b + _b * z._a
        );
    }




}
}
