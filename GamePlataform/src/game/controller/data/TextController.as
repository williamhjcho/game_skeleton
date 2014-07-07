/**
 * Created by William on 5/9/2014.
 */
package game.controller.data {
import flash.utils.Dictionary;

import utils.managers.DataManager;

/**
 * This class controls/holds text objects
 */
public class TextController {

    private static var textLibrary      :Dictionary = new Dictionary();
    private static var _currentLanguageAcronym:String = null;

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
