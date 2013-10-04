/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/4/13
 * Time: 12:36 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.commands {
import flash.utils.getDefinitionByName;

public function getClassByPath(path:String):Class {
    return Class(getDefinitionByName(path));
}
}
