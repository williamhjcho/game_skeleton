/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 10:07 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.errors {

public final class InstantiaitonError extends Error {
    public function InstantiaitonError(msg:String = "Cannot instantiate this class.", id:* = 0) {
        super(msg,id);
    }
}
}
