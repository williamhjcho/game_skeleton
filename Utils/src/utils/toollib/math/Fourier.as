/**
 * Created by aennova on 06/01/14.
 */
package utils.toollib.math {
import utils.toollib.*;

public final class Fourier {

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
                sumC.x += vc.x * cos - vc.y * sin;
                sumC.y += vc.x * sin + vc.y * cos;
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
                sumC.x      += vc.x * cos - vc.y * sin;
                sumC.y += vc.x * sin + vc.y * cos;
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


}
}
