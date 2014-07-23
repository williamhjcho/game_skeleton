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
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import utils.commands.getRandomElementFrom;

import utils.list.ArrayEx;
import utils.list.PriorityQueue;

import utils.managers.LoaderManager;

import view.TileBoard;

[SWF(width=800, height=800, backgroundColor=0x808080, frameRate=30)]
public class Main extends MovieClip {

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
            {"type": "SWF" , "name":"basicElements", "url":"basicElements.swf"}
        ], {onComplete:onLoadAssets});
    }

    private function onLoadAssets(e:LoaderEvent):void {
        init();
    }

    //==================================
    //
    //==================================
    private var board:TileBoard;

    private function init():void { trace("init");
        //var alphabet:Array = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","y","x","z"];
        //var p:PriorityQueue = new PriorityQueue();
        //var i:int;
        //i = 0; p.put(alphabet[i], i); trace(p);
        //i = 1; p.put(alphabet[i], i); trace(p);
        //i = 5; p.put(alphabet[i], i); trace(p);
        //i = 4; p.put(alphabet[i], i); trace(p);
        //i = 9; p.put(alphabet[i], i); trace(p);
        //i = 5; p.put(alphabet[i], i); trace(p);
        //i = 9; p.put(alphabet[i], i); trace(p);
        //i = 5; p.put(alphabet[i], i); trace(p);
        //i = 2; p.put(alphabet[i], i); trace(p);
        //i = 9; p.put("gg", i);        trace(p);

        var w:Number = 40;
        //board = new TileBoard(stage.stageWidth / w, stage.stageHeight / w, w, w);
        board = new TileBoard(10, 10, w, w);
        addChild(board);

        board.find(0,0, 9,9);
    }

}
}

