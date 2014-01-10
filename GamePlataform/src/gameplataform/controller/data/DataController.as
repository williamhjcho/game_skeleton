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

import flash.text.StyleSheet;
import flash.utils.Dictionary;

import gameplataform.constants.AssetType;
import gameplataform.controller.GameData;

import utils.managers.event.UDispatcher;
import utils.managers.serializer.SerializerManager;
import utils.managers.sounds.SoundManager;

public class DataController {

    private static var dispatchingUnit:UDispatcher = new UDispatcher(null);
    private static var analyzedLoaders:Dictionary = new Dictionary();

    public function DataController() {}

    //==================================
    //     Event Management
    //==================================
    public static function addEventListener(type:String, listener:Function):void {
        dispatchingUnit.addEventListener(type, listener);
    }

    public static function removeEventListener(type:String, listener:Function):void {
        dispatchingUnit.removeEventListener(type, listener);
    }

    public static function dispatchEvent(type:String, data:* = null):void {
        dispatchingUnit.dispatchEvent(type, data);
    }

    //==================================
    //     Core
    //==================================
    public static function analyzeLoader(loader:*):void {
        if(loader in analyzedLoaders)
            return; //already analyzed

        analyzedLoaders[loader] = true;
        if(loader is XMLLoader) {
            var xml:XML = XMLLoader(loader).content;
            for (var c:int = 0; c < xml.children().length(); c++) {
                var ldr:LoaderMax = LoaderMax.getLoader(xml.child(c).@name);
                if(ldr.status == LoaderStatus.COMPLETED)
                    analyzeXML(xml, ldr);
            }
        }
    }

    private static function analyzeXML(xml:XML, loader:LoaderMax):void {
        var xmlList:XMLList;
        for (var c:int = 0; c < xml.children().length(); c++) {
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
