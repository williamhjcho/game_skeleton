/**
 * Created by William on 9/22/2014.
 */
package game.controller.snd {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.media.SoundLoaderContext;
import flash.net.URLRequest;
import flash.utils.Dictionary;
import flash.utils.clearInterval;
import flash.utils.setInterval;

import utils.commands.clamp;

import utils.event.SignalDispatcher;

public class SndManager extends SignalDispatcher {

    protected var items:Vector.<SndItem>;
    protected var itemByName:Dictionary;
    protected var registeredSounds:Vector.<Sound>;

    private var _updateRate :uint;
    private var _volume     :Number = 1.0;
    private var _muted      :Boolean = false;

    private var _intervalID:uint;

    public function SndManager(updateRate:uint = 1000 / 30) {
        items = new Vector.<SndItem>();
        itemByName = new Dictionary();
        registeredSounds = new Vector.<Sound>();
        this.updateRate = updateRate;
    }

    //==================================
    //  Add / Load
    //==================================
    public function add(name:String, sound:Sound, allowMultiple:Boolean = true, allowInterruption:Boolean = true):void {
        var item:SndItem;
        if(isNameRegistered(name)) {
            //overwriting new Sound to already existing instance
            item = getItem(name);
            item.setSound(sound);
            item.allowMultiple = allowMultiple;
            item.allowInterruption = allowInterruption;
        } else {
            //if the sound has already been added, it will create a new instance with the same sound
            item = new SndItem(name, sound, null, allowMultiple, allowInterruption);
        }
        addInstance(item);
    }

    public function load(url:String, name:String, buffer:int = 1000, checkPolicyFile:Boolean = false):void {
        if(isNameRegistered(name)) return;
        var sound:Sound = new Sound(new URLRequest(url), new SoundLoaderContext(buffer, checkPolicyFile));
        sound.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
        sound.addEventListener(Event.COMPLETE, onSoundLoadComplete);
        var item:SndItem = new SndItem(name, sound, url);
        addInstance(item);
    }

    //==================================
    //  Play / Pause / Resume / Mute / UnMute
    //==================================
    public function play(name:String, id:String = null, volume:Number = 1.0, pan:Number = 0.0, startTime:Number = 0, loops:int = 0):String {
        if(!isNameRegistered(name))
            return null;

        var item:SndItem = getItem(name);
        item.play(id, volume, pan, startTime, loops);
        item.setMute(_muted);
        return id;
    }

    public function pause(name:String, id:String):SndItem {
        return isNameRegistered(name)? getItem(name).pause(id) : null;
    }

    public function pauseAll():void {
        for each (var item:SndItem in items) {
            item.pauseAll();
        }
    }

    public function resume(name:String, id:String):SndItem {
        return isNameRegistered(name)? getItem(name).resume(id) : null;
    }

    public function resumeAll():void {
        for each (var item:SndItem in items) {
            item.resumeAll();
        }
    }

    public function mute(name:String, id:String):SndItem {
        return isNameRegistered(name)? getItem(name).mute(id) : null;
    }

    public function muteAll():void {
        _muted = true;
        for each (var item:SndItem in items) {
            item.muteAll();
        }
    }

    public function unMute(name:String, id:String):SndItem {
        return isNameRegistered(name)? getItem(name).unMute(id) : null;
    }

    public function unMuteAll():void {
        _muted = false;
        for each (var item:SndItem in items) {
            item.unMuteAll();
        }
    }


    //==================================
    //  Get / Set
    //==================================
    public function isNameRegistered(name:String):Boolean { return name in itemByName; }
    public function isSoundRegistered(sound:Sound):Boolean { return registeredSounds.indexOf(sound) != -1; }

    public function getItem(name:String):SndItem { return itemByName[name]; }

    public function get updateRate():uint { return _updateRate; }
    public function set updateRate(p:uint):void {
        _updateRate = p;
        clearInterval(_intervalID);
        _intervalID = setInterval(update, _updateRate);
    }

    public function get volume():Number { return _volume; }
    public function set volume(v:Number):void {
        v = clamp(v, 0.0, 1.0);
        var k:Number = v / _volume;
        _volume = v;
        for each (var item:SndItem in items) {
            item.volume *= k;
        }
    }

    public function get isMuted():Boolean { return _muted; }
    public function setMute(m:Boolean):void {
        if(m)   muteAll();
        else    unMuteAll();
    }

    public function isItemMuted(name:String):Boolean { return isNameRegistered(name)? getItem(name).isMuted : false; }
    public function setItemMute(name:String, v:Boolean):void {
        if(isNameRegistered(name))
            getItem(name).setMute(v);
    }

    //==================================
    //  Private
    //==================================
    private function addInstance(si:SndItem):void {
        if(items.indexOf(si) == -1)
            items.push(si);
        if(registeredSounds.indexOf(si.sound) == -1)
            registeredSounds.push(si.sound);
        itemByName[si.name] = si;
    }

    private function update():void {

    }

    //==================================
    //  Events
    //==================================
    private function onSoundLoadError(e:IOErrorEvent):void {
        var sound:Sound = e.target as Sound;
        sound.removeEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
        sound.removeEventListener(Event.COMPLETE, onSoundLoadComplete);
        super.dispatchSignalWith(IOErrorEvent.IO_ERROR, sound);
    }

    private function onSoundLoadComplete(e:Event):void {
        var sound:Sound = e.target as Sound;
        sound.removeEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
        sound.removeEventListener(Event.COMPLETE, onSoundLoadComplete);
        super.dispatchSignalWith(Event.COMPLETE, sound);

    }

}
}
