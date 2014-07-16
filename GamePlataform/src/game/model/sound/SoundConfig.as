/**
 * Created by William on 6/30/2014.
 */
package game.model.sound {
import utils.commands.toStringArgs;

public class SoundConfig {

    public var name     :String;            //Sound name
    public var type     :String;            //SoundType
    public var id       :String = null;     //Unique ID for individual play/pause/mute/volume

    public var stop     :Boolean = false;
    public var delay    :Number = 0;        //in seconds
    public var fade     :Boolean = false;
    public var fadeTime :Number = 1.0;      //in seconds

    public var loops    :uint = 0;
    public var volume   :Number = 1.0;

    public function toString():String {
        return toStringArgs("{SoundConfig name:$0, type:$1, stop:$2, delay:$3, fade:$4, fadeTime:$5, loops:$6, volume:$7}", [name, type, stop, delay, fade, fadeTime, loops, volume], "$", null);
    }
}
}
