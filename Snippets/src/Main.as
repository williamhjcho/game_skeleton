/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.demonsters.debugger.MonsterDebugger;
import com.greensock.events.LoaderEvent;

import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import utils.managers.LoaderManager;

import view.Buttons;

[SWF(width=800, height=600, backgroundColor=0x808080, frameRate=30)]
public class Main extends MovieClip {

    //[Embed(source="../output/mona_lisa.jpg")]
    //private static const MONA_LISA:Class;
    //
    //[Embed(source="../output/valve.PNG")]
    //private static const VALVE:Class;
    //
    //[Embed(source="../output/Bikesgray.jpg")]
    //private static const BIKE:Class;
    //
    //[Embed(source="../output/_textFile.json", mimeType = "application/octet-stream")]
    //private static const JSON:Class;

    private static var background:Shape;

    public function Main() {
       stage.scaleMode = StageScaleMode.NO_SCALE;
       stage.align = StageAlign.TOP_LEFT;

       MonsterDebugger.initialize(this);

        background = new Shape();
        background.graphics.beginFill(0x808080);
        background.graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
        addChild(background);

        loadAssets();
    }

    //==================================
    //  Load
    //==================================
    private function loadAssets():void {
        LoaderManager.loadList("main_assets", [
            {"type": "SWF" , "name":"basicElements", "url":"../fla/basicElements.swf"}
        ], {onComplete:onLoadAssets});
    }

    private function onLoadAssets(e:LoaderEvent):void {
        init();
    }

    //==================================
    //
    //==================================
    private var buttons:Buttons;

    private function init():void { trace("init");
        buttons = new Buttons();
        addChild(buttons);
    }

}
}
