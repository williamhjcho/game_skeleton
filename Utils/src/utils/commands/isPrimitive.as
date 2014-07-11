/**
 * Created by William on 7/11/2014.
 */
package utils.commands {
public function isPrimitive(element:*):Boolean {
    if(element == null) return false;
    var cls:Class = Object(element).constructor;
    switch(cls) {
        case Boolean:
        case String:
        case Number: return true;
    }
    return false;
}
}
