/**
 * Created by aennova on 06/01/14.
 */
package utils.toollib {
public final class Bit {

    /**
     * Shift and rotate to the LEFT
     * @param x target to be shifted
     * @param n number of shifts
     * @return shifted target
     */
    public static function rol(x:uint, n:int):uint {
        return (x << n) | (x >>> (32 - n));
    }

    /**
     * Shift and rotate to the RIGHT
     * @param x target to be shifted
     * @param n number of shifts
     * @return shifted target
     */
    public static function ror(x:uint, n:int):uint {
        return (x << (32 - n)) | (x >>> n);
    }

    /**
     * Sets the bit of a target integer to the value of 0 or 1
     * @param x target integer
     * @param n number of shifts (index 0 based)
     * @param b 0 or 1
     * @return target with the bit set
     */
    public static function setBit(x:uint, n:uint, b:uint):uint {
        return (b & 0x1)? set1(x, n) : set0(x, b);
    }

    /**
     * Sets the bit at the n'th position of a target integer to 0
     * @param x target integer
     * @param n position of the bit (index 0 based)
     * @return target with the bit cleared
     */
    public static function set0(x:uint, n:uint):uint {
        return x & ~(1 << n);
    }

    /**
     * Sets the bit at the n'th position of a target integer to 1
     * @param x target integer
     * @param n position of the bit (index 0 based)
     * @return target with the bit on
     */
    public static function set1(x:uint, n:uint):uint {
        return x | (1 << n);
    }

    /**
     * Toggles the bit as : 0 -> 1 and 1 -> 0
     * @param x target integer
     * @param n position of the bit (index 0 based)
     * @return target with the bit toggled
     */
    public static function toggle(x:uint, n:uint):uint {
        return x ^ (1 << n);
    }

    /**
     * Gets the bit of a target integer
     * @param x target integer
     * @param n position of the bit (index 0 based)
     * @return bit 0 or 1
     */
    public static function getBit(x:uint, n:int):uint {
        return (x >> n) & 0x1;
    }
}
}
