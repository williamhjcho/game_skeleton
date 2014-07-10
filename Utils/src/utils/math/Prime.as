/**
 * Created by William on 1/7/14.
 */
package utils.math {

/**
 * Computes the prime numbers starting from 2 (1 is NOT a prime), and saves it's value for later use
 */
public final class Prime {

    //==================================
    //  Static
    //==================================
    private static var primes:Vector.<uint> = new <uint>[2,3,5,7];

    public static function isPrime(n:uint):Boolean {
        if(n < 2) return false;

        //checking if is divisible by any previously known prime
        for each (var p:uint in primes) {
            if(p == n || p * p > n) return true;
            if(n % p == 0) return false;
        }

        //finding new primes
        //primes can only be odd(except for 2)
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
    public static function factors(n:uint):Vector.<uint> {
        if(n == 0 || n == 1) return new <uint>[1];
        var factors:Vector.<uint> = new Vector.<uint>();

        //finding from known primes
        var prime:uint, i:int = 0;
        while(n > 1) {
            prime = get(i++);
            while(n % prime == 0) {
                factors.push(prime);
                n /= prime;
            }
        }
        return factors;
    }

    public static function clear(length:uint = 0):void {
        if(length < 4)
            primes = new <uint>[2,3,5,7];
        else
            primes.length = length;
    }
}
}
