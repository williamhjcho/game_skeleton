/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 10:02 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.demonsters.debugger.MonsterDebugger;

import controller.Game;
import controller.data.DataController;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.system.Security;
import flash.text.TextField;

import model.Config;
import model.Data;

import utils.managers.DebuggerManager;
import utils.managers.EnvironmentManager;
import utils.managers.LoaderManager;

import utilsDisplay.view.Stats;

public class Main extends MovieClip {

    private static var _instance:Main = null;
    private static var _stage:Stage = null;

    private var _baseSprite:Sprite;
    private var _mapLayer:MovieClip;
    private var _hudLayer:MovieClip;
    private var _popUpLayer:MovieClip;
    private var game:Game;
    private var stats:Stats;

    public static function get instance ():Main { return _instance; }
    public static function get stage    ():Stage { return _stage; }

    public function Main(stage:Stage) {
        if(stage == null) throw new Error();
        if(_stage != null || _instance != null) throw new Error();
        _instance = this;
        _stage = stage;
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);

        onLoadAssets()
    }

    private function onLoadAssets():void {
        for each (var asset:String in Client.config.assets) {
            var loader:* = LoaderManager.getLoader(asset);
            DataController.analyzeLoader(loader);
        }

        initializeControllers();
        initializeBases();
        initializeGame();
    }

    private function initializeControllers():void {
        //initialize
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
        _mapLayer = new MovieClip;
        this.addChild(_mapLayer);

        //HudLayer
        _hudLayer = new MovieClip;
        this.addChild(_hudLayer);

        //PopUpLayer
        _popUpLayer = new MovieClip;
        this.addChild(_popUpLayer);

        stats = new Stats();
        stats.alpha = 0.75;
        addChild(stats);

        game = new Game(_mapLayer, _hudLayer, _popUpLayer);
    }

    private function initializeGame():void {
        Data.stage = _stage;

        game.initialize();
    }


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
