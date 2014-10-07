/**
 * Created by William on 9/22/2014.
 */
package utils.sound {
import flash.media.Sound;

import utils.base.I.IUpdatable;

import utils.commands.clamp;
import utils.data.ResourcePool;
import utils.event.Signal;
import utils.event.SignalDispatcher;

public class SoundItem extends SignalDispatcher {

    private static const POOL:ResourcePool = new ResourcePool(SoundInstance);

    private var _name   :String;
    private var _sound  :Sound;
    private var _url    :String;

    private var _volume             :Number = 1.0;
    private var _muted              :Boolean = false;
    private var _allowMultiple      :Boolean = true;
    private var _allowInterruption  :Boolean = true;

    private var _count:uint = 0;
    private var _lastID:String;
    private var _instances:Object;

    public function SoundItem(name:String, sound:Sound, url:String = null, allowMultiple:Boolean = true, allowInterruption:Boolean = true) {
        super();
        if(name == null || name == "") throw new ArgumentError("Name cannot be null.");
        if(sound == null) throw new ArgumentError("Sound cannot be null.");
        this._name  = name;
        this._sound = sound;
        this._url   = url;
        this._allowMultiple = allowMultiple;
        this._allowInterruption = allowInterruption;
        this._instances = {};
    }

    //==================================
    //  Internal
    //==================================
    internal function setSound(sound:Sound):void {
        if(_sound != null)
            throw new ArgumentError("Already have sound property.");
        _sound = sound;
    }

    internal function update(dt:uint):void {
        for each (var instance:SoundInstance in _instances) {
            instance.update(dt);
        }
    }

    //==================================
    //  Public
    //==================================
    public function play(id:String = null, volume:Number = 1.0, pan:Number = 0, startTime:Number = 0, loops:int = 0, fadeTo:Number = -1, duration:Number = 0.5, stopAtZero:Boolean = true):String {
        if(id == null)
            id = (_count).toString();
        if(loops < 0)
            loops = int.MAX_VALUE;

        var instance:SoundInstance;
        if(id == null && _allowMultiple) {
            //new instance
            instance = POOL.getElement();
            instance.reset(id, _sound);
            instance.addSignalListener(Signal.COMPLETE, onInstanceComplete);
            instance.play(volume * _volume, pan, loops, startTime, fadeTo, duration, stopAtZero);
            _instances[id] = instance;
            _count++;
            _lastID = id;
        } else if(_allowInterruption) {
            //stop currently playing instance (if there is one)
            instance = getInstance(_lastID);
            if(instance == null) { //doesn't have any playing instance
                instance = POOL.getElement();
                instance.reset(id, _sound);
                _instances[id] = instance;
                _count++;
                _lastID = id;
            } else { //has currently playing instance
                instance.pause();
            }
            instance.addSignalListener(Signal.COMPLETE, onInstanceComplete);
            instance.play(volume * _volume, pan, loops, startTime, fadeTo, duration, stopAtZero);
        } else {
            //don't stop current instance, but alter it's values
            instance = getInstance(_lastID);
            if(instance == null) { //if no instance is active
                instance = POOL.getElement();
                instance.reset(id, _sound);
                instance.addSignalListener(Signal.COMPLETE, onInstanceComplete);
                instance.play(volume * _volume, pan, loops, startTime, fadeTo, duration, stopAtZero);
                _instances[id] = instance;
                _count++;
                _lastID = id;
            } else {
                instance.volume = volume * _volume;
                instance.pan = pan;
                instance.fadeTo(fadeTo, duration, stopAtZero);
            }
        }

        if(instance != null && _muted) {
            instance.mute();
        }

        return id;
    }

    public function pause(id:String):SoundItem {
        if(hasInstance(id)) {
            getInstance(id).pause();
        }
        return this;
    }

    public function pauseAll():SoundItem {
        for each (var instance:SoundInstance in _instances) {
            instance.pause();
        }
        return this;
    }

    public function resume(id:String):SoundItem {
        if(hasInstance(id)) {
            getInstance(id).resume();
        }
        return this;
    }

    public function resumeAll():SoundItem {
        for each (var instance:SoundInstance in _instances) {
            instance.resume();
        }
        return this;
    }

    public function setMute(m:Boolean):void {
        if(m) muteAll();
        else unMuteAll();
    }

    public function mute(id:String):SoundItem {
        if(hasInstance(id)) {
            getInstance(id).mute();
        }
        return this;
    }

    public function muteAll():SoundItem {
        _muted = true;
        for each (var instance:SoundInstance in _instances) {
            instance.mute();
        }
        return this;
    }

    public function unMute(id:String):SoundItem {
        if(hasInstance(id)) {
            getInstance(id).unMute();
        }
        return this;
    }

    public function unMuteAll():SoundItem {
        _muted = false;
        for each (var instance:SoundInstance in _instances) {
            instance.unMute();
        }
        return this;
    }

    public function fadeTo(id:String, end:Number, duration:Number, stopAtZero:Boolean = true):SoundItem {
        if(hasInstance(id))
            getInstance(id).fadeTo(end * _volume, duration, stopAtZero);
        return this;
    }

    public function fadeAllTo(end:Number, duration:Number, stopAtZero:Boolean = true):SoundItem {
        for each (var instance:SoundInstance in _instances) {
            instance.fadeTo(end * _volume, duration, stopAtZero);
        }
        return this;
    }

    //==================================
    //  Private
    //==================================


    //==================================
    //  Events
    //==================================
    private function onInstanceComplete(e:Signal):void {
        var instance:SoundInstance = e.data as SoundInstance;
        instance.removeAllSignals();
        POOL.returnElement(instance);
        delete _instances[instance.id];
        super.dispatchSignalWith(Signal.COMPLETE, e.data);
    }

    //==================================
    //  Get / Set
    //==================================
    public function get name():String { return _name; }
    public function get url():String { return _url; }
    public function get sound():Sound { return _sound; }

    public function get allowMultiple():Boolean { return _allowMultiple; }
    public function set allowMultiple(v:Boolean):void { _allowMultiple = v; }

    public function get allowInterruption():Boolean { return _allowInterruption; }
    public function set allowInterruption(v:Boolean):void { _allowInterruption = v; }

    public function get volume():Number { return _volume; }
    public function set volume(v:Number):void {
        v = isNaN(v)? 1.0 : clamp(v, 0.0, 1.0);
        var k:Number = v / _volume;
        _volume = v;
        for each (var instance:SoundInstance in _instances) {
            instance.volume *= k;
        }
    }

    public function get isMuted():Boolean { return _muted; }

    public function hasInstance(id:String):Boolean { return id in _instances; }

    public function getInstance(id:String):SoundInstance { return _instances[id]; }

    public function toString(prefix:String = ""):String {
        var debug:String = "{ ITEM name:" + name
        + ", sound:" + _sound.url
        + ", instances: [";
        var count:int = 0;
        for each (var instance:SoundInstance in _instances) {
            debug += "\n" + prefix + "\t" + instance.toString();
            count++;
        }
        debug += (count > 0? "\n" + prefix : "") + "] }";
        return debug;
    }


}
}
