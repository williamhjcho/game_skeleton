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

        var arr:Array = [0,1,null,3,4,null,6,null,null,9,10];

        trace(arr);

        execute(arr);
        trace("------------");
        execute(arr);
    }

    private function execute(arr:Array):void {
        var l:int = arr.length;
        var currentIndex:int = 0;
        for (var i:int = 0; i < l; i++) {
            if(arr[i] != null) {
                if(currentIndex != i) {
                    arr[currentIndex] = arr[i];
                    arr[i] = null;
                }

                if(arr[currentIndex] == 9) arr.push(11);
                if(arr[currentIndex] == 10) arr[currentIndex] = null;

                currentIndex++;
            }
        }

        trace(arr);

        if(currentIndex != i) {
            l = arr.length;
            while(i < l) {
                arr[currentIndex++] = arr[i++];
            }
            arr.length = currentIndex;
        }
        trace(arr);
    }
}
}
