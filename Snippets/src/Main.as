/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.demonsters.debugger.MonsterDebugger;

import flash.display.MovieClip;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

[SWF(width=960, height=600, backgroundColor=0x808080, frameRate=1)]
public class Main extends MovieClip {

    [Embed(source="../output/mona_lisa.jpg")]
    private static const MONA_LISA:Class;

    [Embed(source="../output/valve.PNG")]
    private static const VALVE:Class;

    [Embed(source="../output/Bikesgray.jpg")]
    private static const BIKE:Class;

    [Embed(source="../output/_textFile.json", mimeType = "application/octet-stream")]
    private static const JSON:Class;

    public function Main() {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        MonsterDebugger.initialize(this);

        var arr:Array = [0,1,2];
       trace(arr);

        var len:int = arr.length;
        arr.push(3,4,5);
        trace(arr);
        arr.splice(0, len);
        trace(arr);
    }

}
}
