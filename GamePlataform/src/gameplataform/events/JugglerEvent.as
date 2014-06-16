/**
 * Created by William on 6/6/2014.
 */
package gameplataform.events {
import flash.events.Event;

public class JugglerEvent extends Event {

    public static const REMOVE:String = "remove";

    public function JugglerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
    }
}
}
