/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 3/31/13
 * Time: 1:27 AM
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.controller.data {
import com.greensock.loading.LoaderMax;
import com.greensock.loading.LoaderStatus;
import com.greensock.loading.XMLLoader;
import com.greensock.loading.core.LoaderCore;

import flash.text.StyleSheet;

import gameplataform.constants.AssetType;
import gameplataform.controller.GameData;

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

    private static var analyzedLoaders:Vector.<LoaderCore> = new Vector.<LoaderCore>();

    //==================================
    //     Public
    //==================================
    /**
     * Analyzes the loader's contents according to their type/Class
     * @param loader LoaderCore subclass [from greensock]
     */
    public static function analyzeLoader(loader:LoaderCore):void {
        if(loader == null)
            throw new ArgumentError("Parameter loader cannot be null.");

        if(loader in analyzedLoaders)
            return; //already analyzed

        analyzedLoaders.push(loader);
        if(loader is XMLLoader) {
            var xml:XML = XMLLoader(loader).content;
            for (var c:int = 0; c < xml.children().length(); c++) {
                var ldr:LoaderMax = LoaderMax.getLoader(xml.child(c).@name);
                if(ldr.status == LoaderStatus.COMPLETED)
                    analyzeXML(xml, ldr);
            }
        }
    }


    //==================================
    //  Private
    //==================================
    /**
     * Analyzes the XMLLoader :
     * - De-serialize the raw file data
     * - Add sounds directly to SoundManager
     * @param xml
     * @param loader
     */
    private static function analyzeXML(xml:XML, loader:LoaderMax):void {
        var xmlList:XMLList;
        for (var c:int = 0; c < xml.children().length(); c++) {
            //finding the XML block where this loader's name is contained
            if(xml.child(c).@name == loader.name) {
                xmlList = xml.child(c).children();
                break;
            }
        }

        for (var i:int = 0; i < xmlList.length(); i++) {
            var xmlPropertyName:String = xmlList[i].name();
            var childName:String = xmlList[i].@name;
            var data:String;

            switch (xmlPropertyName) {
                case "MP3Loader": {
                    SoundManager.addPreloaded(childName, loader.getContent(childName));
                    break;
                }
                case "DataLoader": {
                    data = loader.getContent(childName);
                    switch(String(xmlList[i].@type)) {
                        case AssetType.VARIABLES: {
                            GameData.variables = SerializerManager.decodeFromString(data);
                            break;
                        }
                        case AssetType.SAVE: {
                            GameData.defaultSaveData = data;
                            GameData.saveData = SerializerManager.decodeFromString(data);
                            break;
                        }
                        case AssetType.TEXT: {
                            GameData.addText(SerializerManager.decodeFromString(data), String(xmlList.@acronym), true);
                            GameData.currentLanguage = String(xmlList.@acronym);
                            break;
                        }                        
                        case AssetType.CSS: {
                            GameData.styleSheet = new StyleSheet();
                            GameData.styleSheet.parseCSS(data);
                            break;
                        }
                    }
                    break;
                }
            }
        }
    }


}
}
