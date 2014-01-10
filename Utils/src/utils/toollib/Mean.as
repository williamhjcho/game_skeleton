/**
 * Created by William on 1/10/14.
 */
package utils.toollib {
public class Mean {

    private var _numbers:Vector.<Number> = new Vector.<Number>();

    public function Mean(numbers:Vector.<Number>) {
        this._numbers = numbers;
    }

    public function add(...numbers):void {
        for each (var n:Number in numbers)
            _numbers.push(n);
    }

    public function push(numbers:*):void {
        for each (var n:Number in numbers)
            _numbers.push(n);
    }

    public function arithmetic  ():Number { return Mean.arithmetic(_numbers); }
    public function harmonic    ():Number { return Mean.harmonic(_numbers); }
    public function geometric   ():Number { return Mean.geometric(_numbers); }
    public function rootSquare  ():Number { return Mean.rootSquare(_numbers); }


    public static function arithmetic(numbers:*):Number {
        var sum:Number = 0;
        for each (var n:Number in numbers) { sum += n; }
        return sum / numbers.length;
    }

    public static function harmonic(numbers:*):Number {
        var H:Number = 0;
        for each (var n:Number in numbers) { H += 1/n; }
        return numbers.length / H;
    }

    public static function geometric(numbers:*):Number {
        var G:Number = 0;
        for each (var n:Number in numbers) { G *= n; }
        return Math.pow(G, 1/numbers.length);
    }

    public static function rootSquare(numbers:*):Number {
        var RMS:Number = 0;
        for each (var n:Number in numbers) { RMS += n*n; }
        return Math.sqrt(RMS/numbers.length);
    }

}
}
