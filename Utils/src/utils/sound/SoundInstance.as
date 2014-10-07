/**
 * Created by William on 9/25/2014.
 */
package utils.sound {
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

import utils.commands.clamp;
import utils.event.Signal;

import utils.event.SignalDispatcher;

public class SoundInstance extends SignalDispatcher {

    private var _id         :String;
    private var _sound      :Sound;
    private var _channel    :SoundChannel;
    private var _volume     :Number = 1.0;
    private var _pan        :Number = 0;
    private var _loopsLeft  :int = 0;
    private var _pausedPos  :Number = 0;
    private var _isPlaying  :Boolean = false;
    private var _isMuted    :Boolean = false;
    private var transform   :SoundTransform = new SoundTransform(1, 0);

    //fading
    private var _isFading   :Boolean = false;
    private var _volumeStart:Number = 0;
    private var _volumeEnd  :Number = 1.0;
    private var _fadeDuration:uint = 0;
    private var _elapsed    :uint = 0;
    private var _stopAtZero :Boolean = false;

    public function SoundInstance() {
        super();
    }

    //==================================
    //
    //==================================
    public function reset(id:String, sound:Sound):SoundInstance {
        if(id == null)
            throw new ArgumentError("ID cannot be null.");
        if(sound == null)
            throw new ArgumentError("Sound cannot be null.");
        _id         = id;
        _sound      = sound;
        _channel    = null;
        _volume     = 1.0;
        _pan        = 0.0;
        _loopsLeft  = 0;
        _pausedPos  = 0;
        _isPlaying  = false;
        _isMuted    = false;
        transform.volume = 1.0;
        transform.pan = 0;
        return this;
    }

    public function destroy():void {
        _id         = null;
        _sound      = null;
        _channel    = null;
        _volume     = 1.0;
        _pan        = 0.0;
        _loopsLeft  = 0;
        _pausedPos  = 0;
        _isPlaying  = false;
        _isMuted    = false;
        transform.volume = 1.0;
        transform.pan = 0;
    }

    public function play(volume:Number, pan:Number, loops:int, startTime:Number, fadeTo:Number = -1, duration:Number = 0.5, stopAtZero:Boolean = true):SoundInstance {
        _volume     = isNaN(volume)? 1.0 : clamp(volume, 0.0, 1.0);
        _pan        = isNaN(pan)? 0 : clamp(_pan, -1.0, 1.0);
        _loopsLeft  = loops;
        _pausedPos  = 0;
        _isPlaying  = true;
        _isMuted    = _volume == 0;
        _elapsed    = 0;
        _stopAtZero = stopAtZero;
        _isFading   = (!isNaN(fadeTo) && fadeTo >= 0) && (!isNaN(duration) && duration > 0) && (volume != fadeTo);

        if(_isFading) {
            _volumeStart    = volume;
            _volumeEnd      = fadeTo;
            _fadeDuration   = duration * 1000;
        } else {
            _volumeStart    = volume;
            _volumeEnd      = volume;
            _fadeDuration   = 0;
        }

        transform.volume    = _volume;
        transform.pan       = _pan;

        if(_channel != null)
            _channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);

        _channel = _sound.play(startTime, 0, transform);
        _channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
        return this;
    }

    public function pause():SoundInstance {
        _isPlaying = false;
        _pausedPos = this.position;
        _channel.stop();
        return this;
    }

    public function resume():SoundInstance {
        _isPlaying = true;
        if(_channel != null)
            _channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
        _channel = _sound.play(_pausedPos, 0, _channel.soundTransform);
        _channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
        return this;
    }

    public function mute():SoundInstance {
        _isMuted = true;
        transform.volume = 0;
        _channel.soundTransform = transform;
        return this;
    }

    public function unMute():SoundInstance {
        _isMuted = _volume == 0;
        transform.volume = _isMuted? 0 : _volume;
        _channel.soundTransform = transform;
        return this;
    }

    public function fadeTo(end:Number, duration:Number, stopAtZero:Boolean = true):SoundInstance {
        _isFading = (!isNaN(end) && end >= 0) && (!isNaN(duration) && duration > 0) && (_volume != end);
        _stopAtZero = stopAtZero;
        if(_isFading) {
            _volumeStart    = _volume;
            _volumeEnd      = end;
            _fadeDuration   = duration * 1000;
        } else {
            _volumeStart    = -1;
            _volumeEnd      = -1;
            _fadeDuration   = 0;
        }
        return this;
    }

    //==================================
    //  Internal
    //==================================
    internal function update(dt:uint):void {
        if(_isFading) {
            _elapsed += dt;
            if(_elapsed >= _fadeDuration) {
                _elapsed = _fadeDuration;
                _isFading = false;

                this.volume = _volume
                            = _volumeEnd;

                if(_volumeEnd == 0 && _stopAtZero) {
                    onSoundComplete(null);
                }
            } else {
                this.volume = _volume
                            = _volumeStart + (_volumeEnd - _volumeStart) * (_elapsed / _fadeDuration);
            }
        }
    }

    //==================================
    //  Event
    //==================================
    private function onSoundComplete(e:Event):void {
        if(_loopsLeft == -1) { //infinite loop
            play(_volume, _pan, _loopsLeft, 0);
        } else if(_loopsLeft <= 1) {
            _isPlaying = false;
            super.dispatchSignalWith(Signal.COMPLETE, this);
        } else {
            play(_volume, _pan, _loopsLeft - 1, 0);
        }
    }

    //==================================
    //  Get / Set
    //==================================
    public function get id():String { return _id; }

    public function get loopsLeft():int { return _loopsLeft; }
    public function set loopsLeft(v:int):void { _loopsLeft = v; }

    public function get isMuted():Boolean { return _isMuted; }
    public function set isMuted(v:Boolean):void {
        if(v) mute();
        else unMute();
    }

    public function get isPlaying():Boolean { return _isPlaying; }

    public function get position():Number { return _channel.position; }

    public function get volume():Number { return _volume; }
    public function set volume(v:Number):void {
        transform.volume = _volume = isNaN(v)? 1.0 : clamp(v, 0.0, 1.0);
        _channel.soundTransform = transform;
    }

    public function get pan():Number { return _pan; }
    public function set pan(v:Number):void {
        transform.pan = _pan = isNaN(v)? 0.0 : clamp(v, -1.0, 1.0);
        _channel.soundTransform = transform;
    }

    public function get soundTransform():SoundTransform { return transform; }

    public function toString(prefix:String = ""):String {
        return prefix + "{ INSTANCE id:" + _id
        + ", volume:" + _volume.toFixed(2)
        + ", pan:" + _pan.toFixed(2)
        + ", loopLeft:" + _loopsLeft
        + ", isMuted:" + _isMuted
        + ", isPlaying:" + _isPlaying
        + ", pausedPos:" + _pausedPos.toFixed(2)
        + " }";
    }
}
}
