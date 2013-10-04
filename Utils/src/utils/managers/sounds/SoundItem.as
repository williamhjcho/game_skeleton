/**
 * Created with IntelliJ IDEA.
 * User: williamwc
 * Date: 2/5/13
 * Time: 10:47 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.sounds {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.utils.Dictionary;

import utils.managers.Pool;
import utils.toollib.ToolMath;

public class SoundItem extends EventDispatcher {

    private static const ERROR_PREFIX:String = "[SoundItem] ";

    private var _paused             :Boolean        = true;
    private var _volume             :Number         = 1;
    private var _pan                :Number         = 0;

    public var name                 :String         = "unnamed";
    public var sound                :Sound          = null;
    public var muted                :Boolean        = false;

    public var onLoad               :Function       = null;
    public var onLoadParams         :Array          = null;
    public var onPlayComplete       :Function       = null;
    public var onPlayCompleteParams :Array          = null;

    private var counter         :uint = 0;
    private var _instances      :Dictionary = new Dictionary();
    private var _counterInstance:Dictionary = new Dictionary();

    public function SoundItem() {
        super();
    }


    /** MANAGEMENT **/
    public function play(ID:String = null, startTime:Number = 0, volume:Number = 1, pan:Number = 0, loops:int = 0):String {
        var ins:SoundInstance = _instances[ID];

        try {
            if(ins == null) {
                if(ID == null)
                    ID = name + "_" + counter++;
                ins                 = new SoundInstance(ID, Pool.getItem(SoundTransform));
                _instances[ins.ID]  = ins;
            } else {
                if(!ins.paused) return ins.ID; //already playing
                ins.channel = null; //removing reference to old channel
            }

            this._paused    = false;
            ins.paused      = false;
            ins.lastVolume  = _volume * volume;
            ins.volume      = (muted)? 0 : ins.lastVolume;
            ins.pan         = pan;
            ins.loops       = loops;
            ins.channel     = sound.play(startTime, 0, ins.soundTransform);
            ins.channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
            _counterInstance[ins.channel] = ins;
        } catch(e:Error) {
            trace(ERROR_PREFIX, e.errorID, e.message);
        }

        return ins.ID;
    }

    public function pause(ID:String):void {
        var ins:SoundInstance = _instances[ID];
        if(ins == null || ins.paused) return;
        ins.paused = true;
        ins.lastPosition = ins.channel.position;
        ins.channel.stop();
        ins.channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
    }

    public function pauseAll():void {
        if(_paused) return;
        _paused = true;
        for (var ID:String in _instances) {
            pause(ID);
        }
    }

    public function resume(ID:String):void {
        var ins:SoundInstance = _instances[ID];
        if(ins == null || !ins.paused) return;
        ins.paused = false;
        ins.channel = sound.play(ins.lastPosition, ins.loops, ins.soundTransform);
        ins.channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
        _counterInstance[ins.channel] = ins;
    }

    public function resumeAll():void {
        if(!_paused) return;
        _paused = false;

        for (var ID:String in _instances) {
            resume(ID);
        }
    }

    public function stop(ID:String):void {
        var ins:SoundInstance = _instances[ID];
        if(ins == null || ins.paused) return;
        ins.paused = true;
        ins.lastPosition = 0;
        ins.channel.stop();
        ins.channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
    }

    public function stopAll():void {
        _paused = true;
        for (var ID:String in _instances) {
            stop(ID);
        }
    }

    public function mute(ID:String):void {
        var ins:SoundInstance = _instances[ID];
        if(ins == null) return;
        ins.mute();
    }

    public function muteAll():void {
        muted = true;
        for (var ID:String in _instances) {
            mute(ID);
        }
    }

    public function unMute(ID:String):void {
        var ins:SoundInstance = _instances[ID];
        if(ins == null) return;
        ins.unMute();
    }

    public function unMuteAll():void {
        muted = false;
        for (var ID:String in _instances) {
            unMute(ID);
        }
    }

    public function executeOnLoad():void {
        if(onLoad != null)  onLoad.apply(this, onLoadParams);
    }



    /** EVENTS  **/
    private function onSoundComplete(e:Event):void {
        var channel:SoundChannel = e.currentTarget as SoundChannel;
        var ins:SoundInstance = _counterInstance[channel];
        ins.paused = true;
        if(ins.loops > 1) {
            play(ins.ID, 0, ins.volume, ins.pan, ins.loops - 1);
        } else {
            channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
            Pool.returnItem(ins.soundTransform);
            ins.destroy();
            delete _instances[ins.ID];
            delete _counterInstance[channel];
            dispatchEvent(new SoundEvent(SoundEvent.SOUND_PLAY_COMPLETE, ins.ID, this, null));
            if(onPlayComplete != null)
                onPlayComplete.apply(this, onPlayCompleteParams);
        }
    }


    /** GET & SET**/
    public function get paused():Boolean { return _paused; }

    public function get volume():Number { return _volume; }

    public function set volume(v:Number):void {
        _volume = (muted)? 0 : ToolMath.clamp(v,0,1);
        for each(var ins:SoundInstance in _instances) {
            ins.volume = _volume;
        }
    }

    public function get pan():Number { return _pan; }

    public function set pan(p:Number):void {
        _pan = ToolMath.clamp(p, -1, 1);
        for each(var ins:SoundInstance in _instances) {
            ins.pan = _pan;
        }
    }

    public function getPosition(ID:String):Number {
        //return channel.position;
        var ins:SoundInstance = _instances[ID];
        return (ins == null) ? 0 : ins.channel.position;
    }

    public function setPosition(ID:String, pos:Number):void {
        //lastPosition = val;
        var ins:SoundInstance = _instances[ID];
        if(ins == null) return;

        ins.lastPosition = pos;
        if(!ins.paused) {
            pause(ID);
            ins.lastPosition = pos;
            resume(ID);
        }
    }


    public function destroy():void {
        onLoad               = null;
        onLoadParams         = null;
        onPlayComplete       = null;
        onPlayCompleteParams = null;
        for each (var ins:SoundInstance in _instances) {
            ins.channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
            ins.destroy();
        }
    }
}
}
