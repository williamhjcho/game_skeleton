/**
 * Created with IntelliJ IDEA.
 * User: williamwc
 * Date: 2/5/13
 * Time: 10:03 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.event {
import flash.events.Event;

import utils.managers.sounds.*;

public class SoundEvent extends Event {
    public static const SOUND_PLAY_COMPLETE :String = "sound.play.complete";
    public static const PLAYLIST_PLAY_COMPLETE:String = "playlist.play.complete";

    public var instanceID       :String;
    public var soundItem        :SoundItem;
    public var duration         :Number;
    public var percent          :Number;
    public var onComplete       :Function;
    public var onCompleteParams :Array;

    public function SoundEvent(type:String, instanceID:String, soundItem:SoundItem, params:Object = null, bubbles:Boolean=false, cancelable:Boolean=false) {
        super(type,bubbles,cancelable);

        this.instanceID = instanceID;
        this.soundItem = soundItem;
        if(params != null) {
            this.duration           = params.duration         || 0  ;
            this.percent            = params.percent          || 0  ;
            this.onComplete         = params.onComplete       || null  ;
            this.onCompleteParams   = params.onCompleteParams || null  ;
        }
    }
}
}
