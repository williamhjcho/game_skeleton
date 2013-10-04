/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 16/08/13
 * Time: 15:44
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.sounds {
import flash.media.SoundChannel;
import flash.media.SoundTransform;

import utils.toollib.ToolMath;

public class SoundInstance {

    private var _ID             :String = null;
    public var channel          :SoundChannel = null;
    public var soundTransform   :SoundTransform = null;

    public var lastPosition :Number = 0;
    public var paused       :Boolean = true;
    public var loops        :int  = 0;
    public var lastVolume   :Number = 1;
    private var _volume     :Number = 1;
    private var _pan        :Number = 0;


    public function SoundInstance(ID:String, soundTransform:SoundTransform) {
        this._ID = ID;
        this.soundTransform = soundTransform;
    }

    public function get ID():String { return _ID; }

    public function get volume():Number { return _volume; }
    public function set volume(v:Number):void {
        _volume = ToolMath.clamp(v, 0, 1);
        if(soundTransform != null)
            soundTransform.volume = _volume;
        if(channel != null)
            channel.soundTransform = soundTransform;
    }

    public function get pan():Number { return _pan; }
    public function set pan(p:Number):void {
        _pan = ToolMath.clamp(p, -1, 1);
        if(soundTransform != null)
            soundTransform.pan = _pan;
        if(channel != null)
            channel.soundTransform = soundTransform;
    }

    public function mute():void {
        lastVolume = _volume;
        volume = 0;
    }

    public function unMute():void {
        volume = lastVolume;
    }

    public function destroy():void {

    }
}
}
