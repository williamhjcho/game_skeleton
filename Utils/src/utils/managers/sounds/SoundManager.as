/**
 * Created with IntelliJ IDEA.
 * User: williamwc
 * Date: 2/5/13
 * Time: 10:41 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.sounds {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.media.SoundLoaderContext;
import flash.net.URLRequest;
import flash.utils.Dictionary;

import utils.commands.clamp;

public class SoundManager {

    private static var soundItemLibrary :Dictionary = new Dictionary();
    private static var loadingSounds    :Dictionary = new Dictionary();
    private static var _muted           :Boolean = false;
    private static var _volume          :Number = 1;

    public function SoundManager() {}

    //==================================
    //  Sound Management
    //==================================
    private static function add(name:String, customSoundClass:Class, preloadedSound:Sound, path:String, buffer:Number = 1000, checkPolicyFile:Boolean = false, params:Object=null):void {
        if(isRegistered(name))
            throw new ArgumentError("Already registered name: \""+name+"\".");

        var soundItem:SoundItem = new SoundItem();

        if(customSoundClass == null) {
            if(preloadedSound == null) {
                soundItem.sound = new Sound(new URLRequest(path), new SoundLoaderContext(buffer, checkPolicyFile));
                soundItem.sound.addEventListener(IOErrorEvent.IO_ERROR  , onSoundLoadError      );
                soundItem.sound.addEventListener(Event.COMPLETE         , onSoundLoadComplete   );
                loadingSounds[soundItem.sound] = soundItem;
            } else {
                soundItem.sound = preloadedSound;
            }
        } else {
            soundItem.sound = new customSoundClass();
        }

        soundItem.name          = name;
        soundItem.muted         = _muted;
        if(params != null) {
            soundItem.onLoad                ||= params.onLoad          ;
            soundItem.onLoadParams          ||= params.onLoadParams    ;
            soundItem.onPlayComplete        ||= params.onComplete      ;
            soundItem.onPlayCompleteParams  ||= params.onCompleteParams;
        }
        soundItemLibrary[name] = soundItem;
    }

    public static function addCustom(name:String, customSoundClass:Class, params:Object = null):void {
        add(name, customSoundClass, null, "",1000, false, params);
    }

    public static function addPreloaded(name:String, sound:Sound, params:Object = null):void {
        add(name, null, sound, "", 1000, false, params);
    }

    public static function addExternal(name:String, path:String, buffer:Number = 1000, checkPolicyFile:Boolean = false, params:Object = null):void {
        add(name, null, null, path,buffer,checkPolicyFile,params);
    }


    public static function remove(name:String):void {
        if(isRegistered(name)) {
            var soundItem:SoundItem = soundItemLibrary[name] as SoundItem;
            soundItem.sound.removeEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError     );
            soundItem.sound.removeEventListener(Event.COMPLETE       , onSoundLoadComplete  );
            soundItem.destroy();
            delete soundItemLibrary[name];
        }
    }

    public static function removeAll():void {
        for each(var soundItem:SoundItem in soundItemLibrary) {
            soundItem.sound.removeEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError     );
            soundItem.sound.removeEventListener(Event.COMPLETE       , onSoundLoadComplete  );
            soundItem.destroy();
            delete soundItemLibrary[soundItem.name];
        }
        soundItemLibrary = new Dictionary();
    }


    //==================================
    //  Public
    //==================================
    public static function play(name:String, ID:String = null, volume:Number = 1, pan:Number = 0, startTime:Number = 0, loops:int = 0):String {
        var soundItem:SoundItem = soundItemLibrary[name] as SoundItem;
        ID = soundItem.play(ID, startTime, volume * _volume, pan, loops);
        if(_muted) soundItem.mute(ID);
        return ID;
    }

    public static function pause(name:String, ID:String = null):void {
        var soundItem:SoundItem = soundItemLibrary[name] as SoundItem;
        if(ID == null)  soundItem.pauseAll();
        else            soundItem.pause(ID);
    }

    public static function resume(name:String, ID:String = null):void {
        var soundItem:SoundItem = soundItemLibrary[name] as SoundItem;
        if(ID == null)  soundItem.resumeAll();
        else            soundItem.resume(ID);
    }

    public static function stop(name:String, ID:String = null):void {
        var soundItem:SoundItem = soundItemLibrary[name] as SoundItem;
        if(ID == null)  soundItem.stopAll();
        else            soundItem.stop(ID);
    }

    public static function get volume()         :Number { return _volume; }
    public static function set volume(v:Number) :void   {
        if(_muted) return;
        v = clamp(v,0,1);
        for each (var item:SoundItem in soundItemLibrary) {
            item.volume = v * item.volume / _volume;
        }
        _volume = v;
    }

    public static function mute(name:String, ID:String = null):void {
        var soundItem:SoundItem = soundItemLibrary[name];
        if(soundItem == null) return;
        if(ID == null)  soundItem.muteAll();
        else            soundItem.mute(ID);
    }

    public static function unmute(name:String, ID:String = null):void {
        var soundItem:SoundItem = soundItemLibrary[name];
        if(soundItem == null) return;
        if(ID == null)  soundItem.unMuteAll();
        else            soundItem.unMute(ID);
    }

    public static function muteAll():void {
        _muted = true;
        for each(var soundItem:SoundItem in soundItemLibrary) {
            soundItem.muteAll();
        }
    }

    public static function unmuteAll():void {
        _muted = false;
        for each(var soundItem:SoundItem in soundItemLibrary) {
            soundItem.unMuteAll();
        }
    }

    public static function get isMuted():Boolean { return _muted; }


    //==================================
    //  Get / Set
    //==================================
    public static function isRegistered(name:String):Boolean { return (soundItemLibrary[name] != null && soundItemLibrary[name] != undefined); }

    public static function getDuration(name:String):Number                              { return SoundItem(soundItemLibrary[name]).sound.length;       }
    public static function getPosition(name:String,ID:String):Number                    { return SoundItem(soundItemLibrary[name]).getPosition(ID);    }
    public static function setPosition(name:String,ID:String,position:Number):void      { SoundItem(soundItemLibrary[name]).setPosition(ID, position); }
    public static function getVolume(name:String):Number                                { return SoundItem(soundItemLibrary[name]).volume/_volume      }
    public static function setVolume(name:String, volume:Number):void                   { SoundItem(soundItemLibrary[name]).volume = (_muted) ? 0 : clamp(volume,0,1) * _volume;   }
    public static function getPan(name:String):Number                                   { return SoundItem(soundItemLibrary[name]).pan; }
    public static function setPan(name:String, pan:Number):void                         { SoundItem(soundItemLibrary[name]).pan = pan; }

    public static function isPaused(name:String):Boolean                                { return SoundItem(soundItemLibrary[name]).paused;             }
    public static function getSound(name:String):Sound                                  { return SoundItem(soundItemLibrary[name]).sound;              }
    public static function getSoundItem(name:String):SoundItem                          { return SoundItem(soundItemLibrary[name]);                    }


    //==================================
    //  Internal Tools
    //==================================
    private static function onSoundLoadError(e:IOErrorEvent):void {
        throw new Error("[SoundManager] " + e.text);
    }

    private static function onSoundLoadComplete(e:Event):void {
        var sound:Sound = e.target as Sound;
        var soundItem:SoundItem = loadingSounds[sound];
        delete loadingSounds[sound];
        soundItem.executeOnLoad();
    }
}
}
