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

import utils.managers.LoaderManager;
import utils.managers.serializer.SerializerManager;
import utils.managers.sounds.SoundManager;

/**
 * This class contains methods for data analysis and processing, LOCAL DATA ONLY
 */
public class AssetDataController {

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
                    SaveController.defaultSaveData = data;
                    SaveController.saveData = SerializerManager.decodeFromString(data);
                    break;
                }
                case AssetType.CSS: {
                    GameData.styleSheet = new StyleSheet();
                    GameData.styleSheet.parseCSS(data);
                    break;
                }
                case AssetType.TEXT: {
                    TextController.addText(SerializerManager.decodeFromString(data), asset.acronym, true);
                    TextController.currentLanguage ||= asset.acronym;
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
