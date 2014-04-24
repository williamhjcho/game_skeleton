/**
 * Created by William on 2/21/14.
 */
package utils.commands {
public function addLeadingZeroes(num:Number, minLength:uint = 2):String {
    var padded:String = num.toString();
    var length:int = int(num).toString().length;
    var v:Vector.<String> = new Vector.<String>();
    while(length < minLength) {
        v.push("0");
        length++;
    }
    return v.join("") + padded;
}
}
