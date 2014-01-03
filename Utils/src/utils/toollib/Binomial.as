/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 03/01/14
 * Time: 10:30
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib {
public final class Binomial {

    //B(n,k) = n! / ((n-k)! * k!)
    //B(n,k) = n(n-1)...(n-k+1)(n-k)! / ((n-k)! * k!)
    //B(n,k) = n(n-1)...(n-k+1) / (k!)
    //B(n,k) = n(n-1)...(n-k+1) / k!
    //[where n >= k >= 0]


    //==================================
    //  Static
    //==================================
    private static var memory:Vector.<uint>;

    public static function get(n:uint, k:uint):uint {
        if(n == 0 || k > n ) return 0;
        if(k == 0 || n == k) return 1;

        var top:Number = 1, bottom:Number = 1, i:int = n - k + 1, j:int = k;
        while(i <= n) { top *= i++; }
        while(j > 0) { bottom *= j--; }

        return top / bottom;
    }
}
}
