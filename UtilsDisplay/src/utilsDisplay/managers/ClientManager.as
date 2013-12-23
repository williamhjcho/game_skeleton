/**
 * Created with IntelliJ IDEA.
 * User: filipe
 * Date: 01/02/13
 * Time: 19:10
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.managers {
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;

import utils.managers.EnvironmentManager;

import utilsDisplay.UtilsDisplay;
import utilsDisplay.managers.buttons.ButtonManager;

public class ClientManager {
    private static var stage:Stage;
    private static var main:MovieClip;
    private static var btn:MovieClip;
    private static var currentState:String = StageDisplayState.NORMAL;

    public function ClientManager() {
    }

    public static function initialize(stage:Stage, main:MovieClip):void {
        ClientManager.stage = stage;
        ClientManager.main = main;
        ClientManager.stage.addEventListener(Event.RESIZE, handleStage);
        if (EnvironmentManager.isLocalSWF) {
            ClientManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        }


        var mask:Shape = new Shape();
        mask.graphics.beginFill(0xff0000);
        mask.graphics.drawRect(0, 0, UtilsDisplay.gameWidth, UtilsDisplay.gameHeight);
        mask.graphics.endFill();
        main.mask = mask;
    }
    public static function addFullScreenButton(maximizeButton:MovieClip):void{
        btn = maximizeButton;
        stage.addEventListener(Event.ADDED, onAdded);
        //btn = new MovieClip();
        btn.buttonMode = true;
        ButtonManager.add(btn, {onClick: onClickBtnFullScreen, delay: 0.3});
        btn.x = main.x + UtilsDisplay.gameWidth - btn.width;
        btn.y = main.y;
        stage.addChild(btn);
    }

    public static function  fullScreen(stageDisplayState:String, maxScale:Number = 1):void {
        currentState=stageDisplayState;

        if (stage.displayState != currentState){
            stage.displayState = currentState;
            var  widthIndex:Number =  stage.fullScreenWidth/ UtilsDisplay.gameWidth;
            var  heightIndex:Number =  stage.fullScreenHeight/ UtilsDisplay.gameHeight;
            var limitIndex:Number = Math.min(widthIndex,heightIndex);
            if(limitIndex <maxScale){
                maxScale= limitIndex;
            }
            UtilsDisplay.scale=maxScale;
            main.scaleX = maxScale;
            main.scaleY = maxScale;
            handleStage();
        }
    }

    private static function handleStage(e:Event=null):void {
        if (stage != null && main != null) {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            main.x = (stage.stageWidth >> 1) - (UtilsDisplay.gameWidth >> 1);
            main.y = (stage.stageHeight >> 1) - (UtilsDisplay.gameHeight >> 1);
            if (btn != null) {
                btn.x = main.x + UtilsDisplay.gameWidth - btn.width;
                btn.y = main.y;
            }
            var mask:Shape = new Shape();
            mask.graphics.beginFill(0xff0000);
            mask.graphics.drawRect(main.x, main.y, UtilsDisplay.gameWidth, UtilsDisplay.gameHeight);
            mask.graphics.endFill();
            main.mask = mask;

        }
    }

    private static function onKeyDown(event:KeyboardEvent):void {
        if (event.keyCode == 70 && event.ctrlKey && !event.altKey && !event.shiftKey) {
            stage.displayState = stage.displayState ==StageDisplayState.FULL_SCREEN ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN;
        }
    }

    private static function onClickBtnFullScreen(btn:Object):void {

        fullScreen(currentState ==StageDisplayState.FULL_SCREEN ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN);
    }

    private static function onAdded(event:Event):void {
        stage.setChildIndex(btn, stage.numChildren - 1);
    }
}
}
