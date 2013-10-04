/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/6/13
 * Time: 4:05 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.commands {
public function Copy(target:Object):* {
    var Type:Class = getClass(target);

    switch (Type) {
        case null:
        case uint:
        case int:
        case String:
        case Number:
        case Boolean: return target;
    }

    var result:Object = new Type();
    for (var p:String in target) {
        result[p] = Copy(target[p]);
    }
    return result;
}
}
