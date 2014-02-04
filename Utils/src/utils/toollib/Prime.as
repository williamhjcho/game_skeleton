/**
 * Created by William on 1/7/14.
 */
package utils.toollib {

/**
 * Computes the prime numbers starting from 2 (1 is NOT a prime), and saves it's value for later use
 */
public final class Prime {

    //==================================
    //  Static
    //==================================
    private static var primes:Vector.<uint> = new <uint>[2,3,5];

    public static function isPrime(n:uint):Boolean {
        if(n < 2) return false;

        for each (var p:uint in primes) {
            if(p == n || p * p > n) return true;
            if(n % p == 0) return false;
        }

        //primes can only be odd(except 2)
        for (var i:uint = primes[primes.length-1] + 2; i * i <= n; i+=2) {
            if(n % i == 0) return false;
        }

        return true;
    }

    public static function get(n:uint):uint {
        if(n < primes.length)
            return primes[n];

        for (var i:int = primes[primes.length-1] + 1; primes.length <= n; i++) {
            if(isPrime(i)) primes.push(i);
        }
        return primes[n];
    }

    //ex: n = 63 -> returns [3,3,7]
    public static function factors(n:int):Vector.<uint> {
        var factors:Vector.<uint> = new Vector.<uint>();
        for (var i:int = 2; i <= n; i++) {
            while(n % i == 0) {
                factors.push(i);
                n /= i;
            }
        }
        return factors;
    }

    public static function clear(length:uint = 0):void {
        if(length < 4)
            primes = new <uint>[1,2,3,5];
        else
            primes.length = length;
    }
}
}
