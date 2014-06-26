/**
 * Created by William on 6/30/2014.
 */
package utils.commands {
public function toStringReplace(s:String, pattern:*, arg:String):String {
    return s.replace(
            (pattern is String) ? new RegExp(pattern, "g") : pattern,
            arg
    );
}
}
