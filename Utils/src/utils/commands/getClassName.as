/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/27/13
 * Time: 4:03 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.commands {
import flash.utils.getQualifiedClassName;

/**
 * Gets class name "formatted" to a better extent
 * @param o
 * @return
 */
public function getClassName(o:Object):String {
    return getQualifiedClassName(o).replace(/::/g,".").replace(/__AS3__\.vec\./g, "");
}
}
