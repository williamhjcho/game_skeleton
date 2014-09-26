/**
 * Created by William on 8/8/2014.
 */
package {
import com.demonsters.debugger.MonsterDebugger;
import com.greensock.events.LoaderEvent;

import flash.display.Shape;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import utils.managers.LoaderManager;

[SWF(width=800, height=800, backgroundColor=0x808080, frameRate=30)]
public class Client extends Sprite {

    public static var instance:Client;

    private static var background:Shape;

    [Embed(source="../output/char.png")]
    public static const CHAR_EMBED:Class;

    public function Client() {
        instance = this;
        super();
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
            {"type": "SWF" , "name":"basicElements", "url":"basicElements.swf"}
        ], {onComplete:onLoadAssets});
    }

    private function onLoadAssets(e:LoaderEvent):void {
        trace("init");
        init();
    }

    //==================================
    //
    //==================================
    private function init():void {
        addChild(new Main());
    }
}
}
