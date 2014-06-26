/**
 * Created by William on 6/18/2014.
 */
package utils.commands {
/**
 * Finds and replaces patterns inside string, according to prefix and suffix given.
 * @param string
 * @param args
 * @param prefix char of length preferably 1
 * @param suffix char of length preferably 1
 * @return string replaced with args
 */
public function toStringArgs(string:String, args:Array, prefix:String = "{", suffix:String = "}"):String {
    const escaped_characters:String = "{}()[]+-$";
    var pf:String = (prefix == null || prefix == "")? "" : (escaped_characters.indexOf(prefix) == -1? prefix : "\\" + prefix);
    var sf:String = (suffix == null || suffix == "")? "" : (escaped_characters.indexOf(suffix) == -1? suffix : "\\" + suffix);
    for (var i:int = 0; i < args.length; i++) {
        string = string.replace(new RegExp(pf + i + sf, "g"), args[i]);
    }
    return string;
}
}
