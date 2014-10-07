/**
 * Created by William on 5/9/2014.
 */
package game.controller.sound {
import game.constants.SoundType;
import game.controller.GameMechanics;
import game.controller.data.GameData;
import game.controller.data.SaveController;
import game.model.sound.SoundConfig;

import utils.commands.toStringArgs;
import utils.sound.SoundUtil;

public class SoundPlayer {

    public static const UNIQUE:String = "+unique";

    //==================================
    //  Background
    //==================================
    public static function playBGM(sound:String, volume:Number = 1.0):void {
        SoundUtil.play(sound, UNIQUE, volume * volumeBGM, 0.0, 0, -1);
    }

    public static function stopBGM(sound:String, fadeTo:Number = 0, fadeTime:Number = 0):void {
        SoundUtil.fadeTo(sound, UNIQUE, fadeTo, fadeTime, true);
    }

    //==================================
    //  SFX
    //==================================
    public static function playSFX(sound:String, id:String = null, loops:uint = 0, volume:Number = 1.0, pan:Number = 0, start:Number = 0):String  {
        return SoundUtil.play(sound, id, volume * volumeSFX, pan, start, loops);
    }
    public static function stopSFX(sound:String, id:String = null):void {
        SoundUtil.pause(sound, id);
    }

    //==================================
    //  AMBIENT
    //==================================
    public static function playAmbient(sound:String, id:String = null, loops:uint = 0, volume:Number = 1.0, pan:Number = 0, start:Number = 0):String {
        return SoundUtil.play(sound, id, volume * volumeAmbient, pan, start, loops); }
    public static function stopAmbient(sound:String, id:String = null):void  {
        SoundUtil.pause(sound, id);
    }

    //==================================
    //  Public
    //==================================
    public static function flipMute():void {
        if(SoundUtil.isMuted)    SoundUtil.unMuteAll();
        else                     SoundUtil.muteAll();
    }

    public static function get volumeBGM    ():Number { return GameData.variables.volume_main * GameData.variables.volume_BGM       * SaveController.data.volumeMain * SaveController.data.volumeBGM; }
    public static function get volumeAmbient():Number { return GameData.variables.volume_main * GameData.variables.volume_ambient   * SaveController.data.volumeMain * SaveController.data.volumeAmbient; }
    public static function get volumeSFX    ():Number { return GameData.variables.volume_main * GameData.variables.volume_SFX       * SaveController.data.volumeMain * SaveController.data.volumeSFX; }

    //==================================
    //  Specific
    //==================================
    public static function playConfig(config:SoundConfig):void {
        if(config == null || config.name == null || config.type == null) return;

        switch(config.type) {
            case SoundType.BGM: {
                if(config.stop) {
                    if(config.delay <= 0)   stopBGM(config.name, config.fadeTo, config.fadeDuration);
                    else                    GameMechanics.addDelay(config.delay, stopBGM, [config.name, config.fadeTo, config.fadeDuration]);
                } else {
                    if(config.delay <= 0)   playBGM(config.name, config.volume);
                    else                    GameMechanics.addDelay(config.delay, playBGM, [config.name, config.volume]);
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
                    if(config.delay <= 0)   stopSFX(config.name, config.id);
                    else                    GameMechanics.addDelay(config.delay, stopSFX, [config.name, config.id]);
                } else {
                    if(config.delay <= 0)   playSFX(config.name, config.id, config.loops, config.volume, config.pan, config.start);
                    else                    GameMechanics.addDelay(config.delay, playSFX, [config.name, config.id, config.loops, config.volume, config.pan, config.start]);
                }
                break;
            }
            default: throw new ArgumentError(toStringArgs("Invalid sound config type found : {0}", [config.type]));
        }
    }
}
}

