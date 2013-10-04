/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/19/13
 * Time: 1:35 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.commands {
public function getClass(target:*):Class {
    return Object(target).constructor;
}
}
