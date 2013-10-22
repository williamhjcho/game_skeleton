/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 22/08/13
 * Time: 18:39
 * To change this template use File | Settings | File Templates.
 */
package utils.errors {
public final class SerializerError extends Error {

    public static const VARIABLE_NOT_FOUND:int = 0;

    public function SerializerError(message:* = "", id:* = 0) {
        super(message, id);
    }
}
}
