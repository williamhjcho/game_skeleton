/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 3/31/13
 * Time: 1:27 AM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.controller.data {
import flash.text.StyleSheet;

import gameplataform.constants.AssetType;
import gameplataform.controller.GameData;

import utils.managers.LoaderManager;
import utils.managers.event.MultipleSignal;
import utils.managers.serializer.SerializerManager;
import utils.managers.sounds.SoundManager;

/**
 * This class contains methods for data analysis and processing, LOCAL DATA ONLY
 */
public class DataController {

    /**
     * dispatcher functions as an EventDispatcher, but has an direct communication pipeline (without Event Objects)
     * ex: dispatcher.add("type1", function1);
     * dispatcher.dispatch("parameter1", true, 23);
     * (note it doesn't dispatch any single objects, only the direct parameters)
     */
    public static var dispatcher:MultipleSignal = new MultipleSignal();


    //==================================
    //     Public
    //==================================
    /**
     * Runs through the asset list, checks their TYPE and add to GameData accordingly
     * @param assetList List of Array or Vector.<Object>
     */
    public static function analyzeAssets(assetList:*):void {
        for each (var asset:Object in assetList) {
            var dataName:String = asset.name || asset.url;
            var data:* = LoaderManager.getContent(dataName);
            switch(asset.type) {
                case AssetType.SAVE: {
                    GameData.defaultSaveData = data;
                    GameData.saveData = SerializerManager.decodeFromString(data);
                    break;
                }
                case AssetType.CSS: {
                    GameData.styleSheet = new StyleSheet();
                    GameData.styleSheet.parseCSS(data);
                    break;
                }
                case AssetType.TEXT: {
                    GameData.addText(SerializerManager.decodeFromString(data), asset.acronym, true);
                    GameData.currentLanguage ||= asset.acronym;
                    break;
                }
                case AssetType.SOUND: {
                    SoundManager.addPreloaded(dataName, data);
                    break;
                }
                case AssetType.VARIABLES: {
                    GameData.variables = SerializerManager.decodeFromString(data);
                    break;
                }
            }
        }
    }

}
}
