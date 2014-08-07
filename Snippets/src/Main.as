/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import Box2D.Collision.Shapes.b2PolygonShape;
import Box2D.Common.Math.b2Vec2;
import Box2D.Dynamics.b2Body;
import Box2D.Dynamics.b2BodyDef;
import Box2D.Dynamics.b2World;

import com.demonsters.debugger.MonsterDebugger;
import com.greensock.events.LoaderEvent;

import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import utils.commands.addPrefix;

import utils.list.BinaryHeap;

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


    private function init():void {
        trace("init");

    }



}
}

