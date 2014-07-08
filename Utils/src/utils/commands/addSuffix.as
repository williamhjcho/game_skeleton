/**
 * Created by William on 7/8/2014.
 */
package utils.commands {
/**
 * returns a new string as: text + [suffix], the string returned will be of length >= length
 * @param text
 * @param suffix
 * @param length
 * @return text + [suffix]
 */
public function addSuffix(text:String, suffix:String, length:uint):String {
    var pad:Vector.<String> = new Vector.<String>();
    var l:int = text.length;
    while(l + pad.length < length) {
        pad.push(suffix);
    }
    return text + pad.join("");
}
}
