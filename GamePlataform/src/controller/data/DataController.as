/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 3/31/13
 * Time: 1:27 AM
 * To change this template use File | Settings | File Templates.
 */
package controller.data {
import com.greensock.events.LoaderEvent;
import com.greensock.loading.DataLoader;
import com.greensock.loading.LoaderMax;
import com.greensock.loading.LoaderStatus;
import com.greensock.loading.XMLLoader;

import controller.event.DataEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.text.StyleSheet;
import flash.utils.Dictionary;

import model.GameData;

import utils.AssetsManager;
import utils.managers.serializer.SerializerManager;
import utils.managers.sounds.SoundManager;

public class DataController {

    private static var dispatchingUnit:EventDispatcher = new EventDispatcher();

    private static var _loadedXMLs:Dictionary = new Dictionary();


    public function DataController() {}

    /** Event Management **/
    public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
        dispatchingUnit.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
        dispatchingUnit.removeEventListener(type, listener, useCapture)
    }

    public static function dispatchEvent(e:Event):void {
        dispatchingUnit.dispatchEvent(e);
    }

    /** Core **/
    public static function loadData(path:String):void {
        AssetsManager.loadDataAssets(path, {name:path, onComplete:onDataLoaded}, null, null);
    }

    private static function onDataLoaded(e:LoaderEvent):void {
        var dl:DataLoader = e.target as DataLoader;
        dispatchEvent(new DataEvent(DataEvent.DATA_LOADED, dl.content, false, false));
    }


    public static function loadXML(path:String, onProgress:Function = null):void {
        AssetsManager.loadXMLAssets(path, {name:path, onComplete:onLoadXML}, onProgress, null);
    }

    public static function onLoadXML(e:LoaderEvent):void {
        var xmlLoader:XMLLoader = e.target as XMLLoader;
        var xml:XML = xmlLoader.content;
        _loadedXMLs[xmlLoader.url] = xml;

        for (var c:int = 0; c < xml.children().length(); c++) {
            var loader:LoaderMax = LoaderMax.getLoader(xml.child(c).@name);
            if(loader.status == LoaderStatus.COMPLETED)  //load="true"
                analyzeXML(xml, loader);
        }
        dispatchEvent(new DataEvent(DataEvent.XML_LOADED, xml, false, false));
    }


    public static function loadFromXML(xmlPath:String, loaderName:String):void {
        AssetsManager.loadExternalLoader(loaderName, {onComplete:onLoadFromXML, xmlPath:xmlPath});
    }

    private static function onLoadFromXML(e:LoaderEvent):void {
        var loader:LoaderMax = e.target as LoaderMax;
        var xml:XML = _loadedXMLs[loader.vars.xmlPath];
        analyzeXML(xml, loader);
        dispatchEvent(new DataEvent(DataEvent.FROM_XML_FINISHED, xml, false,false));
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
                        case "GAME_VARIABLES": {
                            GameData.variables = SerializerManager.decode(JSON.parse(data));
                            break;
                        }
                        case "SAVE_DATA": {
                            GameData.defaultSaveData = data;
                            GameData.saveData = SerializerManager.decode(JSON.parse(data));
                            break;
                        }
                        case "TEXT": {
                            GameData.addText(JSON.parse(data), String(xmlList.@acronym), true);
                            GameData.currentLanguage = String(xmlList.@acronym);
                            break;
                        }                        
                        case "CSS": {
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
