/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 10:02 AM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform {
import com.demonsters.debugger.MonsterDebugger;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.Stage;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.system.Security;
import flash.text.TextField;

import gameplataform.constants.AssetKey;
import gameplataform.controller.Game;
import gameplataform.controller.data.AssetDataController;
import gameplataform.controller.data.GameData;
import gameplataform.model.Config;

import utils.managers.EnvironmentManager;

import utilsDisplay.view.Stats;

/**
 * This class :
 *  - analyzes the assets already loaded by Client
 *  - initializes controllers
 *  - instantiates the layers
 *  - initializes the game
 */
public class Main extends Sprite {

    private static var _instance:Main = null;
    private static var _stage:Stage = null;

    private var _mapLayer   :Sprite;
    private var _hudLayer   :Sprite;
    private var _popUpLayer :Sprite;
    private var _game       :Game;
    private var _stats      :Stats;

    public function Main(stage:Stage) {
        if(_instance != null)
            throw new IllegalOperationError("Singleton class Main, cannot be instantiated more than once.");
        if(stage == null)
            throw new ArgumentError("Parameter stage cannot be null.");

        _instance = this;
        _stage = stage;
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);

        GameData.stage = _stage;

        analyzeAssets();
        initializeControllers();
        initializeBases();
        initializeGame();
    }

    /**
     * Runs through Config.assets and analyzes their content (see DataController)
     */
    private function analyzeAssets():void {
        AssetDataController.analyzeAssets(Client.config.assets[AssetKey.MAIN_ASSETS]);
    }

    /**
     * Initializes any important OUTSIDE GAME controllers
     */
    private function initializeControllers():void {
        var config:Config = Client.config;

        Security.allowDomain(config.allowedDomain);
        Security.allowInsecureDomain(config.allowedDomain);

        MonsterDebugger.initialize(this);

        //identifying the Environment of the game (wem, offline, scorm....)
        EnvironmentManager.initialize(loaderInfo.url, config.serverTest);
    }

    /**
     * Creating and adding the game layers and the game itself
     */
    private function initializeBases():void {
        //creating a background
        var g:Graphics = super.graphics;
        g.beginFill(0xffffff,0);
        g.drawRect(0,0,_stage.stageWidth, _stage.stageHeight);
        g.endFill();

        //MapLayer
        _mapLayer = new Sprite();
        this.addChild(_mapLayer);

        //HudLayer
        _hudLayer = new Sprite();
        this.addChild(_hudLayer);

        //PopUpLayer
        _popUpLayer = new Sprite();
        this.addChild(_popUpLayer);

        if(Client.config.showStats) {
            _stats = new Stats();
            _stats.alpha = 0.75;
            addChild(_stats);
        }

        _game = new Game(_mapLayer, _hudLayer, _popUpLayer);
    }

    private function initializeGame():void {
        _game.initialize();
    }


    //==================================
    //  Get / Set
    //==================================
    public static function get instance ():Main { return _instance; }
    public static function get stage    ():Stage { return _stage; }

}
}
