/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/4/13
 * Time: 11:43 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.greensock.events.LoaderEvent;

import flash.display.MovieClip;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import model.Config;

import utils.managers.LoaderManager;
import utils.managers.serializer.SerializerManager;

import utilsDisplay.bases.interfaces.IPreLoader;
import utilsDisplay.view.preloader.DefaultPreLoader;

[SWF(width=800, height=600, backgroundColor=0x808080, frameRate=60, pageTitle="BLAHBLASDF")]
public class Client extends MovieClip {

    [Embed(source="../../output/app/data/files/_gameConfig.txt", mimeType="application/octet-stream")]
    private static const CONFIG:Class;

    private static const PRE_LOADER:Class;

    private static var _config:Config;
    private static var _preLoader:MovieClip;


    public function Client() {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        setCustomMenu("Custom Menu", "v1.0", "1/1/2013");

        this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);

        //Pre Loader
        _preLoader = (PRE_LOADER == null) ? new DefaultPreLoader() : new PRE_LOADER();
        (_preLoader).x = stage.stageWidth  - (_preLoader).width >> 1;
        (_preLoader).y = stage.stageHeight - (_preLoader).height >> 1;
        addChild(_preLoader);

        //Config
        _config = SerializerManager.decodeFromString(new CONFIG());

        //Load
        LoaderManager.loadList(_config.assets, "", onLoadAssets, updatePreLoader, null);
    }

    private function updatePreLoader(p:Number):void {
        IPreLoader(_preLoader).percentage = p;
    }

    private function onLoadAssets(e:LoaderEvent):void {
        removeChild(_preLoader);
        this.addChild(new Main(this.stage));
    }

    //==================================
    //
    //==================================
    public static function get config():Config {
        return _config;
    }

    //==================================
    //
    //==================================
    private function setCustomMenu(name:String, version:String, data:String):void {
        var gameMenu:ContextMenu = new ContextMenu();
        gameMenu.hideBuiltInItems();
        gameMenu.customItems.push(new ContextMenuItem(name));
        gameMenu.customItems.push(new ContextMenuItem('Version: ' + version));
        gameMenu.customItems.push(new ContextMenuItem('Date: ' + data));
        this.contextMenu = gameMenu;
    }

}
}
