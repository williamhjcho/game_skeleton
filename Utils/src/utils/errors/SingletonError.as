/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/29/13
 * Time: 1:44 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.errors {
public class SingletonError extends Error {
    public function SingletonError(msg:String = "Cannot instantiate this class again.", id:* = 0) {
        super(msg,id);
    }
}
}
