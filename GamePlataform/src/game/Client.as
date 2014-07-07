/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/4/13
 * Time: 11:43 AM
 * To change this template use File | Settings | File Templates.
 */
package game {
import com.greensock.events.LoaderEvent;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import game.constants.AssetKey;
import game.model.Config;
import game.view.PreLoader;

import utils.commands.execute;
import utils.managers.LoaderManager;
import utils.managers.serializer.SerializerManager;

/**
 * This class:
 *  - loads the asset list
 *  - manages the PreLoader
 *  - makes any SWF/security configuration
 */
[SWF(width=800, height=600, backgroundColor=0x808080, frameRate=30)]
public class Client extends Sprite {

    //Pre-loaded external assets, embed onto main.swf
    [Embed(source="../../../output/app/data/files/config.json", mimeType="application/octet-stream")]
    private static const CONFIG:Class;

    private static var _instance:Client;
    private static var _config:Config;
    private static var _preLoader:PreLoader;

    public function Client() {
        if(_instance != null) throw new IllegalOperationError("Singleton Class, cannot be instantiated more than once.");
        _instance = this;

        stage.align = StageAlign.TOP;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        setCustomMenu("Custom Menu", "v1.0", "1/1/2013");

        this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);

        //Config
        _config = SerializerManager.decodeFromString(new CONFIG());

        if(_config.preLoaderPath == null || _config.preLoaderPath == "") {
            throw new Error("Pre loader path not found on configuration file.");
        } else {
            loadPreLoader(_config.preLoaderPath);
        }
    }


    /**
     * Loads an external SWF with the PreLoader class
     * @param path path indicating the location relative to main.swf to a file preloader.swf, see model.Config class
     */
    private function loadPreLoader(path:String):void {
        LoaderManager.loadSWF(path, {onComplete:onLoadPreLoader});
    }

    private function onLoadPreLoader(e:LoaderEvent = null):void {
        _preLoader = new PreLoader();
        _preLoader.x = (stage.stageWidth  - _preLoader.width ) / 2;
        _preLoader.y = (stage.stageHeight - _preLoader.height) / 2;
        showPreLoader(0,1, loadMainAssets);
    }

    /**
     * Loads any necessary assets inside Config
     */
    private function loadMainAssets():void {
        LoaderManager.loadList(AssetKey.MAIN_ASSETS, _config.assets[AssetKey.MAIN_ASSETS], {onComplete:onLoadAssets, onProgress:updatePreLoader});
    }

    private function onLoadAssets(e:LoaderEvent):void {
        hidePreLoader(startGame);
    }

    private function startGame():void {
        this.addChild(new Main(this.stage));
    }

    //==================================
    //  Pre Loader
    //==================================
    public static function showPreLoader(startingPercentage:Number = 0, alpha:Number = 1, callback:Function = null, parameters:Array = null):void {
        _preLoader.alpha = alpha;
        _preLoader.percentage = startingPercentage;
        _instance.addChild(_preLoader);
        _preLoader.animateIn(callback, parameters);
    }

    public static function hidePreLoader(callback:Function = null, parameters:Array = null):void {
        if(_instance.contains(_preLoader)) {
            _preLoader.animateOut(function():void {
                _instance.removeChild(_preLoader);
                execute(callback, parameters);
            });
        }
    }

    public static function updatePreLoader(p:Number):void {
        _preLoader.percentage = p;
    }

    //==================================
    //  Get/Set
    //==================================
    public static function get config():Config {
        return _config;
    }

    //==================================
    //  Private
    //==================================
    private function setCustomMenu(name:String, version:String, date:String):void {
        var gameMenu:ContextMenu = new ContextMenu();
        gameMenu.hideBuiltInItems();
        gameMenu.customItems.push(new ContextMenuItem(name));
        gameMenu.customItems.push(new ContextMenuItem('Version: ' + version));
        gameMenu.customItems.push(new ContextMenuItem('Date: ' + date));
        this.contextMenu = gameMenu;
    }

}
}
