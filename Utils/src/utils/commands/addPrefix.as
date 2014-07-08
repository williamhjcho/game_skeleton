/**
 * Created by William on 7/8/2014.
 */
package utils.commands {
/**
 * returns a new string as: [prefix] + text, the string returned will be of length >= length
 * @param text
 * @param prefix
 * @param length
 * @return
 */
public function addPrefix(text:String, prefix:String, length:uint):String {
    var l:int = text.length;
    var pad:Vector.<String> = new Vector.<String>();
    while(l + pad.length < length) {
        pad.push(prefix);
    }
    return pad.join("") + text;
}
}
