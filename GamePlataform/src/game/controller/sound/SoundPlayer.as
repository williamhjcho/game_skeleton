/**
 * Created by William on 5/9/2014.
 */
package game.controller.sound {
import game.constants.SoundType;
import game.controller.GameMechanics;
import game.controller.data.GameData;
import game.controller.data.SaveController;
import game.game_internal;
import game.model.sound.SoundConfig;

import utils.commands.lerp;
import utils.commands.toStringArgs;
import utils.list.ArrayEx;
import utils.sound.SoundManager;

public class SoundPlayer {

    public static const UNIQUE:String = "+unique";

    //==================================
    //  Background
    //==================================
    private static var _FADING:ArrayEx = new ArrayEx();

    public static function playBackground(sound:String, loops:int, fade:Boolean = false, fadeTime:Number = 0, volumePercentage:Number = 1.0):void {
        if(fade) {
            var o:STObject = STObject.fromPool();
            o.sound = sound;
            o.timeElapsed = 0;
            o.timeTotal = fadeTime;
            o.volumeStart = SoundManager.getVolume(sound);
            o.volumeEnd = volumeBackground * volumePercentage;
            _FADING.push(o);
            SoundManager.play(sound, UNIQUE, 0, 0, 0, loops);
        } else {
            SoundManager.play(sound, UNIQUE, volumeBackground, 0, 0, loops);
        }
    }

    public static function stopBackground(sound:String, fade:Boolean = false, fadeTime:Number = 0):void {
        if(fade) {
            var o:STObject = STObject.fromPool();
            o.sound = sound;
            o.timeElapsed = 0;
            o.timeTotal = fadeTime * 1000;
            o.volumeStart = SoundManager.getVolume(sound);
            o.volumeEnd = 0;
            _FADING.push(o);
        } else {
            SoundManager.stop(sound, UNIQUE);
        }
    }

    //==================================
    //  SFX
    //==================================
    public static function playSFX(sound:String, id:String = null, loops:uint = 0, volume:Number = 1.0, pan:Number = 0, start:Number = 0):String  {
        return SoundManager.play(sound, id, volumeSFX * volume, pan, start, loops);
    }
    public static function stopSFX(sound:String, id:String = null):void {
        SoundManager.stop(sound, id);
    }

    //==================================
    //  AMBIENT
    //==================================
    public static function playAmbient(sound:String, id:String = null, loops:uint = 0, volume:Number = 1.0, pan:Number = 0, start:Number = 0):String {
        return SoundManager.play(sound, id, volumeAmbient * volume, pan, start, loops); }
    public static function stopAmbient(sound:String, id:String = null):void  {
        SoundManager.stop(sound, id);
    }

    //==================================
    //  Public
    //==================================
    public static function mute_unmute():void {
        if(SoundManager.isMuted)    SoundManager.unmuteAll();
        else                        SoundManager.muteAll();
    }

    public static function get isMuted():Boolean {
        return SoundManager.isMuted;
    }

    public static function get volumeBackground ():Number { return GameData.variables.volume_main * GameData.variables.volume_background * SaveController.data.volumeMain * SaveController.data.volumeBackground; }
    public static function get volumeAmbient    ():Number { return GameData.variables.volume_main * GameData.variables.volume_ambient    * SaveController.data.volumeMain * SaveController.data.volumeAmbient; }
    public static function get volumeSFX        ():Number { return GameData.variables.volume_main * GameData.variables.volume_SFX        * SaveController.data.volumeMain * SaveController.data.volumeSFX; }

    //==================================
    //  Specific
    //==================================
    public static function playConfig(config:SoundConfig):void {
        if(config == null || config.name == null || config.type == null) return;

        switch(config.type) {
            case SoundType.BACKGROUND: {
                if(config.stop) {
                    if(config.delay <= 0)   stopBackground(config.name, config.fade, config.fadeTime);
                    else                    GameMechanics.addDelay(config.delay, stopBackground, [config.name, config.fade, config.fadeTime]);
                } else {
                    if(config.delay <= 0)   playBackground(config.name, config.loops, config.fade, config.fadeTime, config.volume);
                    else                    GameMechanics.addDelay(config.delay, playBackground, [config.name, config.loops, config.fade, config.fadeTime, config.volume]);
                }
                break;
            }
            case SoundType.AMBIENT: {
                if(config.stop) {
                    if(config.delay <= 0)   stopAmbient(config.name, config.id);
                    else                    GameMechanics.addDelay(config.delay, stopAmbient, [config.name, config.id]);
                } else {
                    if(config.delay <= 0)   playAmbient(config.name, null, config.loops, config.volume, config.pan, config.start);
                    else                    GameMechanics.addDelay(config.delay, playAmbient, [config.name, config.id, config.loops, config.volume, config.pan, config.start]);
                }
                break;
            }
            case SoundType.SFX: {
                if(config.stop) {
                    //do nothing
                } else {
                    if(config.delay <= 0)   playSFX(config.name, null, config.loops, config.volume, config.pan, config.start);
                    else                    GameMechanics.addDelay(config.delay, playSFX, [config.name, null, config.loops, config.volume, config.pan, config.start]);
                }
                break;
            }
            default: throw new ArgumentError(toStringArgs("Invalid sound config type found : {0}", [config.type]));
        }
    }

    game_internal static function updateSounds(dt:uint):void {
        const f:Function = function(e:STObject, i:int, father:ArrayEx):void {
            e.timeElapsed += dt;
            SoundManager.setVolume(e.sound, lerp(e.volumeStart, e.volumeEnd, e.timeProgress));
            if(e.isTimeComplete) {
                if(e.volumeEnd == 0) {
                    SoundManager.stop(e.sound, UNIQUE);
                }
                _FADING[i] = null;
                STObject.toPool(e);
            }
        };
        _FADING.removeNulls(f);
    }
}
}

