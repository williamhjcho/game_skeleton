/**
 * Created by William on 5/9/2014.
 */
package gameplataform.controller.sound {
import gameplataform.constants.SoundID;
import gameplataform.controller.data.GameData;

import utils.managers.sounds.SoundManager;

public class SoundPlayer {

    public static const UNIQUE:String = "unique";

    public static const LOOP:int = 99999;

    //==================================
    //
    //==================================
    public static function play_track():void { SoundManager.play(SoundID.TRACK, UNIQUE, volumeBackground, 0, 0, LOOP); }
    public static function stop_track():void { SoundManager.stop(SoundID.TRACK, UNIQUE); }

    //==================================
    //
    //==================================

    public static function play_click(id:String = null):String { return SoundManager.play(SoundID.CLICK, id, volumeSFX, 0, 0, 0); }
    public static function play_over (id:String = null):String { return SoundManager.play(SoundID.OVER, id, volumeSFX, 0, 0, 0); }


    //==================================
    //
    //==================================
    public static function get volumeBackground ():Number { return GameData.variables.volumeMain * GameData.variables.volumeBackground; }
    public static function get volumeSFX        ():Number { return GameData.variables.volumeMain * GameData.variables.volumeSFX; }
}
}
