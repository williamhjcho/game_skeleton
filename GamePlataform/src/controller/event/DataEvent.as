/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 7/24/13
 * Time: 11:45 PM
 * To change this template use File | Settings | File Templates.
 */
package controller.event {
import flash.events.Event;

public final class DataEvent extends Event {

    public static const DATA_LOADED     :String = "customEvent.data.loaded";
    public static const XML_LOADED      :String = "customEvent.xml.loaded";
    public static const FROM_XML_FINISHED:String = "customEvent.from.xml.finished";

    public var data:*;

    public function DataEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.data = data;
    }
}
}
