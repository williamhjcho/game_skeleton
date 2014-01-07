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
    private static var memory:Vector.<Vector.<uint>> = new <Vector.<uint>>[
            new <uint>[1],
            new <uint>[1,1],
            new <uint>[1,2,1]
    ];

    public static function get(n:uint, k:uint):uint {
        if(n == 0 || k > n) return 0;
        if(k == 0 || k == n) return 1;

        var f:Number = 1, diff:uint = n - k;
        for (var i:int = 1; i <= k; i++) {
            f *= (diff / i) + 1;
        }
        return f;
    }
}
}
