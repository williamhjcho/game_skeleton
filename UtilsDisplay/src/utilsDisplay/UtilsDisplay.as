/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/4/13
 * Time: 1:53 PM
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay {
public class UtilsDisplay {
    private static var _gameWidth:int = 0;
    private static var _gameHeight:int = 0;
    private static var _scale:Number = 1;

    private static var _initialized:Boolean;


    public static function initialize(gameWidth:int, gameHeight:int):void {
        _initialized = true;
        _gameHeight = gameHeight;
        _gameWidth = gameWidth;
    }


    public static function get scale():Number { return _scale; }
    public static function set scale(value:Number):void{ _scale = value; }
    public static function get gameWidth():int { return _gameWidth * _scale; }
    public static function get gameHeight():int { return _gameHeight * _scale; }

    public function UtilsDisplay() {
    }
}
}
