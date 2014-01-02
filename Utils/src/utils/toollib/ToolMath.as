/**
 * william.cho
 */
package utils.toollib {
public class ToolMath {

    public static const GOLDEN_RATIO:Number = (1 + Math.sqrt(5))/2;
    public static const TAU:Number = 2*Math.PI;
    public static const e:Number = 2.7182818284590455;
    public static const precision:Number = 0.0000000000000000001;

    private static var _primes:Vector.<uint> = new <uint>[2,3,5,7,9,11,13,17,19,23,27];

    public static function random():Number { return (Math.random() + (1/GOLDEN_RATIO)) % 1; }


    //Common
    public static function abs(n:Number):Number { return (n >> 31)? -n : n; }
    public static function isEven(n:Number):Boolean { return ((n & 1) == 0); }
    public static function sign(n:Number):int { return (n < 0) ? -1 : 1; }

    public static function middle(a:Number, b:Number):Number { return (a + b) / 2; }

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
        if(n % 2 == 0) return pow(x*x, n/2);
        return x*pow(x*x, (n-1)/2);
    }

    public static function factorial(n:int):uint {
        var fat:uint = 1;
        for (var i:int = 2; i <= n; i++)
            fat *= i;
        return fat;
    }

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

    public static function binomialCoefficient(n:int, k:int):int {
        if(n == 0 || k > n ) return 0;
        if(k == 0 || n == k) return 1;

        var top:Number = 1, bottom:Number = 1, i:int = n - k + 1, j:int = k;
        while(i <= n) { top *= i++; }
        while(j > 0) { bottom *= j--; }

        return top / bottom;
    }

    public static function isPrime(n:int):Boolean {
        n = Math.abs(n);
        if(n < 2) return false;
        for(var i:int = 2; i*i <= n; i++) {
            if(n%i == 0) return false;
        }
        return true;
    }

    public static function prime(n:int):uint {
        if(n <= 0) return _primes[0];
        for (var i:int = _primes[_primes.length-1] + 1; _primes.length <= n; i++) {
            if(isPrime(i)) _primes.push(i);
        }
        return _primes[n];
    }

    public static function primeFactors(n:int):Vector.<uint> {
        var factors:Vector.<uint> = new Vector.<uint>();
        for (var i:int = 2; i <= n; i++) {
            while(n % i == 0) {
                factors.push(i);
                n /= i;
            }
        }
        return factors;
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


    //Trigonometry
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

    //Geometry
    public static function getQuadrant(x:Number, y:Number):int {
        var theta:Number = Math.atan2(y,x);
        if(theta < 0)
            return (-theta < Math.PI / 2)? 1 : 2;
        else
            return (theta < Math.PI / 2)? 4 : 3;
    }


    //Calculus
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

    //Bitwise
    public static function rol(x:int, n:int):int {
        //shift and rotate left
        return (x << n) | (x >>> (32 - n));
    }

    public static function ror(x:int, n:int):int {
        //shift and rotate right
        return (x << (32 - n)) | (x >>> n);
    }

    
    //Statistic
    public static function meanArithmetic(numbers:*):Number {
        var sum:Number = 0;
        for each (var n:Number in numbers) { sum += n; }
        return sum / numbers.length;
    }

    public static function meanHarmonic(numbers:*):Number {
        var H:Number = 0;
        for each (var n:Number in numbers) { H += 1/n; }
        return numbers.length / H;
    }

    public static function meanGeometric(numbers:*):Number {
        var G:Number = 0;
        for each (var n:Number in numbers) { G *= n; }
        return Math.pow(G, 1/numbers.length);
    }

    public static function meanRootSquare(numbers:*):Number {
        var RMS:Number = 0;
        for each (var n:Number in numbers) { RMS += n*n; }
        return Math.sqrt(RMS/numbers.length);
    }

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
        return Math.pow(Math.E, -x*x/2) / Math.sqrt(TAU);
    }

    public static function distributionExponential(x:Number, lambda:Number):Number {
        return lambda / Math.pow(Math.E, lambda * x);
    }

    public static function distributionPoisson(k:int, lambda:Number):Number {
        return Math.pow(lambda, k) / ( Math.pow(Math.E, lambda) * factorial(k) );
    }

    public static function distributionBinomial(n:int,k:int,p:Number):Number {
        return binomialCoefficient(n, k) * Math.pow(p, k) * Math.pow(1 - p, n - k);
    }

    //Range
    public static function toPercentage(n:Number, min:Number, max:Number):Number {
        return (n - min) / (max - min);
    }

    public static function toValue(percentage:Number, min:Number, max:Number):Number {
        return min + (max - min) * percentage;
    }

    public static function convertRange(n:Number, min0:Number, max0:Number, min1:Number, max1:Number):Number {
        return min1 + (max1 - min1) * ((n - min0) / (max0 - min0));
    }

    public static function randomRadRange(minNum:Number, maxNum:Number):Number {
        return minNum + Math.random() * (maxNum - minNum);
    }

    public static function randomRange(minNum:Number, range:Number):Number {
        return  minNum + Math.random() * (range);
    }

    public static function isInRange(n:Number, min:Number, max:Number):Boolean {
        return !(n < min || n > max);
    }

    //ROUNDING
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

    public static function floorMult(num:Number, mult:int):Number {
        return num - (num % mult);
    }

    public static function ceilMult(num:Number, mult:int):Number {
        return num + mult - (num % mult);
    }

    public static function clamp(a:Number, min:Number, max:Number):Number {
        //returns a number between [min,max], included
        return (a < min)? min : (a > max)? max : a;
    }

    //COMPARISON
    public static function minLimit(a:Number, b:Number, limit:Number):Number { return (a <= limit || b <= limit) ? limit : Math.min(a,b); }
    public static function maxLimit(a:Number, b:Number, limit:Number):Number { return (a >= limit || b >= limit) ? limit : Math.max(a,b); }

    //MISC
    public static function isEvenlyDivisible(n:int, from:int, to:int, step:int = 1):Boolean {
        for (var i:int = from; i <= to; i+=step)
            if(n % i != 0) return false;
        return true;
    }

    public static function isPalindrome(num:int):Boolean {
        var s:String = num.toString();
        if(s.length <= 1) return true;

        var i:int = 0, j:int = s.length - 1;
        while(i < s.length/2) {
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

    //Interest
    public static function interest(initial:Number, tax:Number, time:Number):Number {
        return initial * tax * time;
    }

    public static function interestCompound(initial:Number, tax:Number, time:Number, precision:Number = 5):Number {
        return (initial * round(Math.pow(1 + tax,time), precision)) - initial;
    }

    //Fourier Transform
    //*
    public static function DFT(XReal:Array, XImg:Array, outReal:Array, outImg:Array):void {
        //Discrete Fourier Transform
        var N:int = XReal.length; //assume XReal.length = XImg.length
        var c:Number = -2 * Math.PI / N;
        for (var k:int = 0; k < N; k++) {
            var sumReal:Number = 0 , sumImg:Number = 0;
            for (var t:int = 0; t < N; t++) {
                //Euler complex number: e^(xi) = cos(x) + sin(x)i  -> cos = real part, sin = imaginary
                //Trigonometric property (not using here): cos(angle) + sin(angle) == cos(-angle) - sin(-angle)
                var sin:Number = Math.sin(c*t*k), cos:Number = Math.cos(c*t*k);
                sumReal += XReal[t] * cos - XImg[t] * sin;
                sumImg  += XReal[t] * sin + XImg[t] * cos;
            }
            outReal[k] = sumReal;
            outImg[k]  = sumImg;
        }
    }

    public static function DFT_Complex(X:Vector.<Complex>):Vector.<Complex> {
        var N:int = X.length;
        var c:Number = -2 * Math.PI / N;
        var y:Vector.<Complex> = new Vector.<Complex>();

        for (var k:int = 0; k < N; k++) {
            var sumC:Complex = new Complex(0,0);
            for (var t:int = 0; t < N; t++) {
                var vc:Complex = X[t];
                var sin:Number = Math.sin(c * t * k), cos:Number = Math.cos(c * t * k);
                sumC.real      += vc.real * cos - vc.imaginary * sin;
                sumC.imaginary += vc.real * sin + vc.imaginary * cos;
            }
            y[k] = sumC;
        }
        return y;
    }

    public static function IDFT(XReal:Array, XImg:Array, outReal:Array, outImg:Array):void {
        //Inverse Discrete Fourier Transform
        var N:int = XReal.length; //assume XReal.length = XImg.length
        var c:Number = 2 * Math.PI / N;
        for (var t:int = 0; t < N; t++) {
            var sumReal:Number = 0, sumImg:Number = 0;
            for (var k:int = 0; k < N; k++) {
                var sin:Number = Math.sin(c*t*k), cos:Number = Math.cos(c*t*k);
                sumReal += XReal[k] * cos - XImg[t] * sin;
                sumImg  += XReal[k] * sin + XImg[t] * cos;
            }
            outReal[t] = sumReal/N;
            outImg[t]  = sumImg/N;
        }
    }

    public static function IDFT_Complex(X:Vector.<Complex>):Vector.<Complex> {
        var N:int = X.length;
        var c:Number = 2 * Math.PI / N;
        var y:Vector.<Complex> = new Vector.<Complex>();

        for (var t:int = 0; t < N; t++) {
            var sumC:Complex = new Complex(0,0);
            for (var k:int = 0; k < N; k++) {
                var vc:Complex = X[k];
                var sin:Number = Math.sin(c * t * k), cos:Number = Math.cos(c * t * k);
                sumC.real      += vc.real * cos - vc.imaginary * sin;
                sumC.imaginary += vc.real * sin + vc.imaginary * cos;
            }
            y[t] = sumC.multiplyScalar(1/N);
        }
        return y;
    }

    public static function FFT_Complex(X:Vector.<Complex>):Vector.<Complex> {
        //invert bit order of indexes, then apply DFT calc on each
        var N:int = X.length, m:int = N / 2, k:int;

        if(N == 1) { return new <Complex>[X[0]]; }
        if(N % 2 != 0) { throw new Error("[FFT] X.length is not a power of 2."); }

        var even:Vector.<Complex> = new Vector.<Complex>();

        for (k = 0; k < m; k++) { even[k] = X[2*k]; }
        var y_top:Vector.<Complex> = FFT_Complex(even);

        var odd:Vector.<Complex> = even; //reusing vector
        for (k = 0; k < m; k++) { odd[k] = X[2*k + 1]; }
        var y_bottom:Vector.<Complex> = FFT_Complex(odd);

        var y:Vector.<Complex> = new Vector.<Complex>();
        var c:Number = -2 * Math.PI / N;
        var wk:Complex = new Complex(0,0);
        for (k = 0; k < m; k++) {
            var top:Complex = y_top[k], bot:Complex = y_bottom[k];
            wk.setTo(Math.cos(c*k), Math.sin(c*k));
            wk.multiply(bot);
            y[k]        = Complex.add(top, wk);
            y[k + N/2]  = Complex.subtract(top, wk);
        }
        return y;
    }
    //*/

}
}
