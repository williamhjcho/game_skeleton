/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 10:02 AM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform {
import com.demonsters.debugger.MonsterDebugger;

import flash.display.Sprite;
import flash.display.Stage;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.system.Security;
import flash.text.TextField;

import gameplataform.controller.Game;
import gameplataform.controller.GameData;
import gameplataform.controller.data.DataController;
import gameplataform.model.Config;

import utils.managers.DebuggerManager;
import utils.managers.EnvironmentManager;
import utils.managers.LoaderManager;

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

    private var _baseSprite :Sprite;
    private var _mapLayer   :Sprite;
    private var _hudLayer   :Sprite;
    private var _popUpLayer :Sprite;
    private var _game       :Game;
    private var _stats      :Stats;

    public function Main(stage:Stage) {
        if(stage == null)
            throw new ArgumentError("Parameter stage cannot be null.");
        if(_instance != null)
            throw new IllegalOperationError("Singleton class Main, cannot be instantiated more than once.");

        _instance = this;
        _stage = stage;
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);

        analyzeAssets();
        initializeControllers();
        initializeBases();
        initializeGame();
    }

    /**
     * Runs through Config.assets for Loaders, and analyzes their content (see DataController)
     */
    private function analyzeAssets():void {
        GameData.stage = _stage;

        for each (var asset:String in Client.config.assets) {
            var loader:* = LoaderManager.getLoader(asset);
            DataController.analyzeLoader(loader);
        }
    }

    private function initializeControllers():void {
        var config:Config = Client.config;

        Security.allowDomain(config.allowedDomain);
        Security.allowInsecureDomain(config.allowedDomain);

        DebuggerManager.initialize(MonsterDebugger.trace);

        //identifying the Environment of the game (wem, offline, scorm....)
        EnvironmentManager.initialize(loaderInfo.url, config.serverTest);
    }

    private function initializeBases():void {
        //STARTING THE GAME STRUCTURE
        _baseSprite = new Sprite();
        _baseSprite.graphics.beginFill(0xff0000,0);
        _baseSprite.graphics.drawRect(0,0,_stage.stageWidth, _stage.stageHeight);
        _baseSprite.graphics.endFill();
        this.addChild(_baseSprite);

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

    //==================================
    //
    //==================================
    public function showLoadError():void {
        var container:Sprite = new Sprite();
        container.x = 0;
        container.y = 0;
        var fundo:Sprite = new Sprite();
        fundo.graphics.beginFill(0x0066ff, 1);
        fundo.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
        fundo.graphics.endFill();
        fundo.x = 0;
        fundo.y = 0;
        container.addChild(fundo);

        var texto:TextField = new TextField();
        texto.multiline = true;

        texto.width = _stage.stageWidth;

        texto.htmlText = "<p align='center'><font size='20' face='verdana,tahoma'> Atenção, erro de conexão, verifique sua conexão e reinicie o jogo." +
                "<br>Se o erro persistir contacte o administrador de rede." +
                "<br> Código:AssetsLoadingERROR" +
                "</font></p>";

        texto.y = _stage.stageWidth / 2 - texto.height / 2;
        texto.x = _stage.stageWidth / 2 - texto.width / 2;
        container.addChild(texto);
        this.addChild(container);
    }

}
}
