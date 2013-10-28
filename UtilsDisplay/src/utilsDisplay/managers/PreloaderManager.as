/**
 * Created with IntelliJ IDEA.
 * User: filipe
 * Date: 31/01/13
 * Time: 11:01
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.managers {
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import utilsDisplay.view.preloader.DefaultPreLoader;

public class PreloaderManager {

    private static var _stage:Stage;

    public static var loadingMovie:DisplayObjectContainer;
    public static var background:Sprite;

    private static var movieContainer:MovieClip;
    private static var isInitialized:Boolean = false;
    private static var _isVisible:Boolean = false;
    private static var _centralize:Boolean;

    public static function initialize(stage:Stage):void {
        isInitialized = true;
        _stage = stage;
        _stage.addEventListener(Event.RESIZE, resizeHandler);
        _stage.align = StageAlign.TOP_LEFT;
        _stage.scaleMode = StageScaleMode.NO_SCALE;
    }

    public static function setLoadingMovie(movie:DisplayObjectContainer, centralize:Boolean):void {
        if(!isInitialized) throw new Error("Initialize first.");
        _centralize = centralize;
        loadingMovie = movie || new DefaultPreLoader();

        if(movieContainer == null) {
            movieContainer = new MovieClip();
        } else {
            while(movieContainer.numChildren > 0)
                movieContainer.removeChildAt(0);
        }

        if(background == null)
            background = new Sprite();
        background.graphics.clear();
        background.graphics.beginFill(0x000000,0);
        background.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
        background.graphics.endFill();

        if(_centralize) {
            loadingMovie.x = (_stage.stageWidth >>1) - (loadingMovie.width >>1);
            loadingMovie.y = (_stage.stageHeight>>1) - (loadingMovie.height>>1);
        }

        movieContainer.addChild(background);
        movieContainer.addChild(loadingMovie);
    }

    private static function handleStage():void {
        if (_stage != null && loadingMovie != null) {
            _stage.align = StageAlign.TOP_LEFT;
            _stage.scaleMode = StageScaleMode.NO_SCALE;

            if(_centralize) {
                loadingMovie.x = (_stage.stageWidth >>1) - (loadingMovie.width >>1);
                loadingMovie.y = (_stage.stageHeight>>1) - (loadingMovie.height>>1);
            }

            background.width = _stage.stageWidth;
            background.height = _stage.stageHeight;
            background.x = 0;
            background.y = 0;
        }
    }

    public static function setVisible(visible:Boolean):void {
        if (isInitialized && movieContainer != null) {
            if (visible) {
                if (!_isVisible) {
                    _stage.addChild(movieContainer);
                    _isVisible = true;
                }
            } else {
                if (_isVisible) {
                    _stage.removeChild(movieContainer);
                    _isVisible = false;
                }
            }
            handleStage();
        }
    }

    public static function get isVisible():Boolean { return _isVisible; }

    //Listener´s
    private static function resizeHandler(e:Event):void {
        handleStage();
    }
}
}
