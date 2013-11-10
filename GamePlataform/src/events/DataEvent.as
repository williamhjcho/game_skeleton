/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 7/24/13
 * Time: 11:45 PM
 * To change this template use File | Settings | File Templates.
 */
package events {
import utils.managers.event.UEvent;

public final class DataEvent extends UEvent {

    public static const DATA_LOADED         :String = "data.loaded";
    public static const XML_LOADED          :String = "xml.loaded";

    public function DataEvent(type:String, data:* = null) {
        super(type, data);
    }
}
}
