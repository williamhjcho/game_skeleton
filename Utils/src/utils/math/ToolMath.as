/**
 * william.cho
 */
package utils.math {
import utils.units.Units;

public final class ToolMath {

    public static const PHI:Number = 1.61803398875; //(1 + Math.sqrt(5))/2;
    public static const TAU:Number = 6.28318530718; // 2 * Math.PI
    public static const E:Number = 2.7182818284590455;
    public static const precision:Number = 0.0000000000000000001;

    public static function random():Number { return (Math.random() + (1/PHI)) % 1; }

    //==================================
    //  Common
    //==================================
    public static function abs(n:Number):Number { return (n >> 31)? -n : n; }
    public static function isOdd(n:Number):Boolean { return (n & 1) == 1; }
    public static function sign(n:Number):int { return (n < 0) ? -1 : 1; }

    public static function middle(a:Number, b:Number):Number { return (a + b) / 2; }

    public static function digitalRoot(n:uint, base:uint = 9):uint { return 1 + ((n - 1) % base); }

    public static function euler():Number {
        var sum:Number = 0, fact:Number = 1, nextTerm:Number = 1;
        for (var i:int = 1; nextTerm > precision; i++) {
            sum += nextTerm;
            fact *= i;
            nextTerm = 1/fact;
        }
        return sum;
    }

    public static function exp(x:Number):Number {
        if(x == 0) return 1;
        var sum:Number = 0, fact:Number = 1, term:Number = x, nextTerm:Number = 1;
        for(var i:int = 1; nextTerm > precision; i++) {
            sum += nextTerm;
            fact *= i;
            term *= x;
            nextTerm = term/fact;
        }
        return sum;
    }

    public static function pow(x:Number, n:int):Number {
        if(n <= 1) return x;
        if(n % 2) return x * pow(x * x, (n - 1) / 2);
        return pow(x * x, n / 2);
    }

    public static function squareSum(a:Number, b:Number):Number { return a * a + b * b; }

    public static function squareSub(a:Number, b:Number):Number { return a * a - b * b; }

    public static function hypothenuse(a:Number, b:Number):Number { return Math.sqrt(a*a + b*b); }

    public static function hypot(x:Number, y:Number):Number {
        var r:Number;
        if(Math.abs(x) > Math.abs(y)) {
            r = y / x;
            return Math.abs(y) * Math.sqrt(1 + r*r);
        } else if(y != 0) {
            r = x / y;
            return Math.abs(x) * Math.sqrt(1 + r*r);
        }
        return 0.0;
    }

    public static function delta(a:Number, b:Number, c:Number):Number { return (b*b) - (4*a*c); }

    public static function GCD(u:int, v:int):int {
        //Greatest Common Divisor
        if(u == v) return u;
        if(u == 0) return v;
        if(v == 0) return u;

        if(u & 1) { //u is even
            if(v & 1) //v is odd
                return GCD(u >> 1, v);
            else
                return GCD(u >> 1, v >> 1) << 1;
        }
        //u is odd
        if(v & 1) return GCD(u, v >> 1);

        if(u > v) return GCD((u - v) >> 1, v);

        return GCD((v - u) >> 1, u);
    }

    public static function LCM(a:int, b:int):int {
        //Least Common Multiple
        //ex: LCM(4,6) = 12
        return a*b / GCD(a,b);
    }

    public static function minLimit(a:Number, b:Number, limit:Number):Number { return (a <= limit || b <= limit) ? limit : Math.min(a,b); }
    public static function maxLimit(a:Number, b:Number, limit:Number):Number { return (a >= limit || b >= limit) ? limit : Math.max(a,b); }

    //==================================
    //  Rounding
    //==================================
    public static function round(num:Number, precision:int = 1):Number {
        var pow:Number = Math.pow(10, precision);
        return Math.round(num * pow) / pow;
    }

    public static function roundMult(num:Number, mult:int):Number {
        //example: num = 41, mult = 3  --> 42
        //         num = 55, mult = 10 --> 60
        var div:Number = num % mult;
        if (div >= mult / 2)    num += mult - div;
        else                    num -= div;
        return num;
    }

    public static function floorMult(n:Number, mult:int):Number {
        return n - (n % mult);
    }

    public static function ceilMult(n:Number, mult:int):Number {
        return n + mult - (n % mult);
    }

    public static function clamp(a:Number, min:Number, max:Number):Number {
        //returns a number between [min,max], included
        return (a < min)? min : (a > max)? max : a;
    }

    //==================================
    //  Trigonometry
    //==================================
    public static function sin(x:Number):Number {
        var sum:Number = 0, term:Number = x, fact:Number = 1, nextTerm:Number = x;
        for (var i:int = 1, s:int = 1; nextTerm > precision ; i+=2, s*=-1) {
            sum += s*nextTerm;
            term *= x*x;
            fact *= (i+1)*(i+2);
            nextTerm = term/fact;
        }
        return sum;
    }

    public static function cos(x:Number):Number {
        var sum:Number = 0, term:Number = 1, fact:Number = 1, nextTerm:Number = 1;
        for (var i:int = 0, s:int = 1; nextTerm > precision ; i+=2, s *= -1) {
            sum += s * nextTerm;
            term *= x*x;
            fact *= (i+1)*(i+2);
            nextTerm = term/fact;
        }
        return sum;
    }

    public static function tan(x:Number):Number {
        var sum:Number = 0, term:Number = x, fact:Number = 2, nextTerm:Number = x, k4:Number = 4;
        for (var k:int = 2, s:int = -1; nextTerm > precision; k+=2, s*=-1) {
            sum += nextTerm;
            fact *= (k+1)*(k+2);
            k4 *= 4;
            term *= x*x;
            //nextTerm = (k4) * (1 - k4) * BERNOULLI_20[k+2] * term / fact;
            nextTerm = s * (k4) * (k4 - 1) * Units.BERNOULLI[k+2] * term / fact; //alter on (k4 - 1) to be positive
        }
        return sum;
    }

    public static function sinh(x:Number):Number {
        var sum:Number = 0, term:Number = x, fact:Number = 1, nextTerm:Number = x;
        for (var i:int = 1; nextTerm > precision ; i+=2) {
            sum += nextTerm;
            term *= x*x;
            fact *= (i+1)*(i+2);
            nextTerm = term/fact;
        }
        return sum;
    }

    public static function cosh(x:Number):Number {
        var sum:Number = 0, term:Number = 1, fact:Number = 1, nextTerm:Number = 1;
        for (var i:int = 0; nextTerm > precision ; i+=2) {
            sum += nextTerm;
            term *= x*x;
            fact *= (i+1)*(i+2);
            nextTerm = term/fact;
        }
        return sum;
    }

    public static function asin(x:Number):Number {
        var sum:Number = 0, term:Number = x, nextTerm:Number = x,
                factN:Number = 1, fact2N:Number = 1, p4:Number = 1;
        for (var i:int = 0; nextTerm > precision; i++) {
            sum += nextTerm;
            term *= x*x;
            p4 *= 4;
            factN *= (i+1);
            fact2N *= (2*i+1)*(2*i+2);
            nextTerm = (fact2N * term) / (p4 * factN*factN * (2*(i+1)+1));
        }
        return sum;
    }

    //==================================
    //  Geometry
    //==================================
    public static function getQuadrant(x:Number, y:Number):int {
        var theta:Number = Math.atan2(y,x);
        if(theta < 0)
            return (-theta < Math.PI / 2)? 1 : 2;
        else
            return (theta < Math.PI / 2)? 4 : 3;
    }

    //==================================
    //  Calculus
    //==================================
    public static function integrate_rectangle(f:Function, a:Number, b:Number, divisions:int = 1000):Number {
        var integral:Number = 0, d:Number = (b-a)/divisions;
        for (var x:Number = a; x <= b; x+=d) {
            integral += f(x) * d;
        }
        return integral;
    }

    public static function integrate_trapezoid(f:Function, a:Number, b:Number, divisions:int = 1000):Number {
        var integral:Number = 0, d:Number = (b-a)/divisions, y0:Number = f(a);
        for (var x:Number = a + d; x <= b; x+=d) {
            var y:Number = f(x);
            integral += d*(y+y0)/2;
            y0 = y;
        }
        return integral;
    }

    //==================================
    //  Statistic
    //==================================
    public static function expected(numbers:*, probabilityFunction:Function):Number {
        var sum:Number = 0;
        for each (var x:Number in numbers) {
            sum += x * probabilityFunction(x);
        }
        return sum;
    }
    
    public static function expected_discrete(numbers:*, probabilities:Array):Number {
        var sum:Number = 0;
        for (var i:int = 0; i < numbers.length; i++) {
            sum += numbers[i] * probabilities[i];
        }
        return sum;
    }

    public static function variance(numbers:*, mean:Number):Number {
        var sum:Number = 0;
        for each (var x:Number in numbers) {
            var d:Number = (x - mean);
            sum += d*d;
        }
        return Math.sqrt(sum / numbers.length);
    }

    public static function distributionNormal(x:Number):Number {
        return Math.pow(E, -x*x/2) / Math.sqrt(TAU);
    }

    public static function distributionExponential(x:Number, lambda:Number):Number {
        return lambda / Math.pow(E, lambda * x);
    }

    public static function distributionPoisson(k:int, lambda:Number):Number {
        return Math.pow(lambda, k) / ( Math.pow(E, lambda) * Factorial.get(k) );
    }

    public static function distributionBinomial(n:int,k:int,p:Number):Number {
        return Binomial.get(n, k) * Math.pow(p, k) * Math.pow(1 - p, n - k);
    }

    public static function gaussianKernel(sigma:Number, size:uint):Matrix {
        var m:Matrix = new Matrix(size, size);
        var A:Number = 1 / (2 * Math.PI * sigma * sigma);
        var B:Number = (2 * sigma * sigma);
        var radius:int = size / 2;
        var sum:Number = 0;
        for (var y:int = -radius; y <= radius; y++) {
            for (var x:int = -radius; x <= radius; x++) {
                var k:Number = A * Math.exp(- (x * x + y * y) / B);
                sum += k;
                m.setAt(y + radius, x + radius, k);
            }
        }

        sum = 1 / sum;
        for (y = 0; y < size; y++) {
            for (x = 0; x < size; x++) {
                m.setAt(y, x, m.getAt(y, x) * sum);
            }
        }

        return m;
    }

    public static function interest(initial:Number, tax:Number, time:Number):Number {
        return initial * tax * time;
    }

    public static function interestCompound(initial:Number, tax:Number, time:Number, precision:Number = 5):Number {
        return (initial * round(Math.pow(1 + tax,time), precision)) - initial;
    }

    //==================================
    //  Range
    //==================================
    public static function toPercentage(n:Number, min:Number, max:Number):Number {
        return (n - min) / (max - min);
    }

    public static function toValue(percentage:Number, min:Number, max:Number):Number {
        return min + (max - min) * percentage;
    }

    public static function convertRange(n:Number, min0:Number, max0:Number, min1:Number, max1:Number):Number {
        return min1 + (max1 - min1) * ((n - min0) / (max0 - min0));
    }

    public static function randomRandInt(min:int, max:int):int {
        return min + Math.round(Math.random() * (max - min));
    }

    public static function randomRadRange(min:Number, max:Number):Number {
        return min + Math.random() * (max - min);
    }

    public static function randomRange(start:Number, range:Number):Number {
        return  start + Math.random() * (range);
    }

    public static function isInRange(n:Number, min:Number, max:Number):Boolean {
        return !(n < min || n > max);
    }

    //==================================
    //  Misc
    //==================================
    public static function isEvenlyDivisible(n:int, from:int, to:int, step:int = 1):Boolean {
        for (var i:int = from; i <= to; i+=step)
            if(n % i != 0) return false;
        return true;
    }

    public static function isPalindrome(num:int):Boolean {
        var s:String = num.toString();
        if(s.length <= 1) return true;

        var i:int = 0, j:int = s.length - 1;
        var half:int = s.length / 2;
        while(i < half) {
            if(s.charAt(i++) != s.charAt(j--)) return false;
        }
        return true;
    }

    public static function numberOfDigits(num:int):int {
        var n:int = Math.abs(num);
        for (var i:int = 0; n / 10 >= 1; i++) {
            n /= 10;
        }
        return i + 1 + (num < 0? 1 : 0);
    }

    public static function sumDigits(num:uint):uint {
        var sum:uint = 0;
        while(num != 0) {
            sum += num % 10;
            num /= 10
        }
        return sum;
    }

    public static function addMod(a:uint, b:uint, p:uint):uint {
        return (p - b > a)? (a + b) : (a + b - p);
    }

    public static function subMod(a:uint, b:uint, p:uint):uint {
        return (a >= b)? (a - b) : (p - b + a);
    }

    public static function mulMod(a:uint, b:uint, p:uint):uint {
        var r:uint = 0;
        while(b > 0) {
            if(b & 1) r = addMod(r, a, p);
            b >>= 1;
            a = addMod(a, a, p);
        }
        return r;
    }

    public static function powMod(a:uint, e:uint, p:uint):uint {
        var r:uint = 1;
        while(e > 0) {
            if(e & 1) r = mulMod(r, a, p);
            e >>= 1;
            a = mulMod(a, a, p);
        }
        return r;
    }



}
}
