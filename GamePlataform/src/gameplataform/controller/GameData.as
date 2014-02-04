/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/3/13
 * Time: 3:04 PM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.controller {
import flash.display.Stage;
import flash.geom.Rectangle;
import flash.text.StyleSheet;
import flash.utils.Dictionary;

import gameplataform.model.*;

import utils.managers.DataManager;

/**
 * This class is NOT for game logic,
 * ONLY for data manipulation
 */
public class GameData {

    private static var _stage           :Stage;

    public static var user              :String;

    public static var defaultSaveData   :String;
    public static var saveData          :Save;
    public static var variables         :Variables;
    public static var styleSheet        :StyleSheet;

    private static var textLibrary      :Dictionary = new Dictionary();

    private static var _currentLanguageAcronym:String;

    public static function get stage():Stage            { return _stage; }
    public static function set stage(value:Stage):void  { _stage = value; }

    public static function get stageWidth   ():Number { return _stage.stageWidth; }
    public static function get stageHeight  ():Number { return _stage.stageHeight; }
    public static function get stageRect    ():Rectangle { return new Rectangle(0,0,_stage.stageWidth, _stage.stageHeight); }

    public static function addText(model:Object, acronym:String, overwrite:Boolean):void {
        var library:DataManager = textLibrary[acronym];
        if(library == null)
            library = textLibrary[acronym] = new DataManager({}, "GameData.TextLibrary." + acronym, null);
        library.add(model, overwrite);
    }

    public static function getText(id:String):String { return DataManager(textLibrary[_currentLanguageAcronym]).get(id) as String; }
    public static function getTextSpecific(id:String, acronym:String):String { return DataManager(textLibrary[acronym]).get(id) as String; }

    public static function get currentLanguage():String { return _currentLanguageAcronym; }
    public static function set currentLanguage(acronym:String):void { _currentLanguageAcronym = acronym; }

    public static function get acronyms():Vector.<String> {
        var list:Vector.<String> = new Vector.<String>();
        for (var acronym:String in textLibrary) {
            list.push(acronym);
        }
        return list;
    }
}
}
