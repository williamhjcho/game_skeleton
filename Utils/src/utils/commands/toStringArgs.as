/**
 * Created by William on 6/18/2014.
 */
package utils.commands {
public function toStringArgs(string:String, ...args):String {
    for (var i:int = 0; i < args.length; i++) {
        string = string.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
    }
    return string;
}
}
