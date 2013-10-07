/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/3/13
 * Time: 3:04 PM
 * To change this template use File | Settings | File Templates.
 */
package model {
import flash.display.Stage;
import flash.geom.Rectangle;
import flash.text.StyleSheet;
import flash.utils.Dictionary;

import utils.managers.DataManager;

public class GameData {

    private static var _stage           :Stage;
    private static var _fps             :Number; //Frames Per Second
    private static var _spf             :Number; //Seconds Per Frame

    public static var defaultSaveData   :String;
    public static var saveData          :SaveData;
    public static var variables         :GameVariables;
    public static var styleSheet        :StyleSheet;
    private static var textLibrary      :Dictionary = new Dictionary();

    private static var _currentLanguageAcronym:String;

    public static function get stage():Stage { return _stage; }
    public static function set stage(value:Stage):void {
        _stage = value;
        _fps = _stage.frameRate;
        _spf = 1 / _stage.frameRate;
    }

    public static function get stageWidth():Number { return _stage.stageWidth; }
    public static function get stageHeight():Number { return _stage.stageHeight; }
    public static function get stageRect():Rectangle { return new Rectangle(0,0,_stage.stageWidth, _stage.stageHeight); }
    public static function get fps  ():Number { return _fps; }
    public static function get spf  ():Number { return _spf; }
    public static function get mspf ():Number { return _spf * 1000; }

    /** Data/Library Management **/
    public static function addText(model:Object, acronym:String, overwrite:Boolean):void {
        var library:DataManager = textLibrary[acronym];
        if(library == null)
            textLibrary[acronym] = library = new DataManager({}, "GameData.TextLibrary."+acronym, null);
        library.add(model, overwrite);
    }

    public static function getText(id:String):String { return DataManager(textLibrary[_currentLanguageAcronym]).getData(id) as String; }
    public static function getTextSpecific(id:String, acronym:String):String { return DataManager(textLibrary[acronym]).getData(id) as String; }

    public static function get currentLanguage():String { return _currentLanguageAcronym; }
    public static function set currentLanguage(acronym:String):void { _currentLanguageAcronym = acronym; }

}
}
