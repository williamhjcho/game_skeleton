/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.demonsters.debugger.MonsterDebugger;

import flash.display.Graphics;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import utils.commands.clamp;
import utils.managers.event.MultipleSignal;

import utils.toollib.color.Colors;

import utilsDisplay.managers.Dragger;

[SWF(width=960, height=600, backgroundColor=0x808080, frameRate=30)]
public class Main extends MovieClip {

    [Embed(source="../output/mona_lisa.jpg")]
    private static const MONA_LISA:Class;

    [Embed(source="../output/valve.PNG")]
    private static const VALVE:Class;

    [Embed(source="../output/Bikesgray.jpg")]
    private static const BIKE:Class;

    public function Main() {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        MonsterDebugger.initialize(this);

        var REGEXP:RegExp = /.*_(\d+)_(\d+)$/;
        var indexes:Array = "aesn_00123_00344".replace(REGEXP, "$1.$2").split(".");
       trace(int(indexes[0]));
       trace(int(indexes[1]));
    }


}
}
