/**
 * Created by William on 6/6/2014.
 */
package utils.events {
public class JugglerSignal extends Signal {

    public static const REMOVE:String = "remove";

    public function JugglerSignal(type:String, data:* = null) {
        super(type, data);
    }
}
}
