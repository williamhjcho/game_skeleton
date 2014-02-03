/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/4/13
 * Time: 11:43 AM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform {
import com.greensock.events.LoaderEvent;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import gameplataform.model.Config;
import gameplataform.view.PreLoader;

import utils.managers.LoaderManager;
import utils.managers.serializer.SerializerManager;

import utilsDisplay.bases.interfaces.IPreLoader;
import utilsDisplay.view.preloader.DefaultPreLoader;

/**
 * This class:
 *  - loads the asset list
 *  - manages the PreLoader
 *  - makes any SWF/security configuration
 */
[SWF(width=800, height=600, backgroundColor=0x808080, frameRate=60, pageTitle="BLAHBLASDF")]
public class Client extends Sprite {

    //Pre-loaded external assets, embed onto main.swf
    [Embed(source="../../../output/app/data/files/_gameConfig.txt", mimeType="application/octet-stream")]
    private static const CONFIG:Class;


    private static var _instance:Client;
    private static var _config:Config;
    private static var _preLoader:DisplayObject;

    public function Client() {
        if(_instance != null) throw new IllegalOperationError("Singleton Class, cannot be instantiated twice.");
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
            onLoadPreLoader(null);
        } else {
            loadPreLoader(_config.preLoaderPath);
        }
    }

    /**
     * Loads an external SWF with the PreLoader class
     * @param path path indicating the location relative to main.swf to a file preloader.swf
     */
    private function loadPreLoader(path:String):void {
        LoaderManager.loadSWF(path, {}, onLoadPreLoader);
    }

    private function onLoadPreLoader(e:LoaderEvent = null):void {
        _preLoader = (e == null)? new DefaultPreLoader() : new PreLoader();
        _preLoader.x = (stage.stageWidth  - _preLoader.width ) >> 1;
        _preLoader.y = (stage.stageHeight - _preLoader.height) >> 1;
        showPreLoader(0,1);
        loadAssets();
    }

    private function loadAssets():void {
        LoaderManager.loadList(_config.assets, "", onLoadAssets, updatePreLoader, null);
    }

    private function onLoadAssets(e:LoaderEvent):void {
        hidePreLoader();
        this.addChild(new Main(this.stage));
    }

    //==================================
    //  Pre Loader
    //==================================
    public static function showPreLoader(startingPercentage:Number = 0, alpha:Number = 1):void {
        _preLoader.alpha = alpha;
        IPreLoader(_preLoader).percentage = startingPercentage;
        _instance.addChild(_preLoader);
    }

    public static function hidePreLoader():void {
        if(_instance.contains(_preLoader))
            _instance.removeChild(_preLoader);
    }

    public static function updatePreLoader(p:Number):void {
        IPreLoader(_preLoader).percentage = p;
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
