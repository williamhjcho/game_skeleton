/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/4/13
 * Time: 11:43 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import Main;
import controller.data.DataController;
import controller.event.DataEvent;

import flash.display.MovieClip;
import flash.events.Event;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import model.Config;

import utils.managers.serializer.SerializerManager;

[SWF(width=800, height=600, backgroundColor=0x808080, frameRate=60, pageTitle="BLAHBLASDF")]
public class Client extends MovieClip {

    private static var _config:Config;

    public function Client() {
        setCustomMenu("Custom Menu", "v1.0", "1/1/2013");
        this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);

        loadConfigFile();
    }

    private function loadConfigFile():void {
        DataController.addEventListener(DataEvent.DATA_LOADED, onConfigLoaded);
        DataController.loadData("data/_gameConfig.txt");
    }

    private function onConfigLoaded(e:DataEvent):void {
        DataController.removeEventListener(DataEvent.DATA_LOADED, onConfigLoaded);
        _config = SerializerManager.decode(JSON.parse(e.data));
        this.addChild(new Main(this.stage));
    }


    public static function get config():Config { return _config; }



    /** * **/
    private function setCustomMenu(name:String, version:String, data:String):void {
        var gameMenu:ContextMenu = new ContextMenu();
        gameMenu.hideBuiltInItems();
        gameMenu.customItems.push(new ContextMenuItem(name));
        gameMenu.customItems.push(new ContextMenuItem('Version: ' + version));
        gameMenu.customItems.push(new ContextMenuItem('Date: ' + data));
        this.contextMenu = gameMenu;
    }

}
}
