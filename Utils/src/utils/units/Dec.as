/**
 * Created by William on 8/4/2014.
 */
package utils.units {
public class Dec {

    public static function sum(...numbers):String {
        var n:int = numbers.length;
        var indexes:Vector.<int> = new Vector.<int>(n);
        for (var i:int = 0; i < n; i++) {
            indexes[i] = numbers[i].length;
        }

        var digits:Vector.<String> = new Vector.<String>(), carry:int = 0;
        while(true) {
            var b:Boolean = true;
            for (i = 0; i < n; i++) {
                if(indexes[i] >= 0) {
                    carry += int(numbers[i].charAt(indexes[i]));
                    indexes[i]--;
                    b = false;
                }
            }
            indexes.push(carry % 10);
            carry /= n * 10;
            if(b) break;
        }
        return digits.reverse().join("");
    }

}
}
