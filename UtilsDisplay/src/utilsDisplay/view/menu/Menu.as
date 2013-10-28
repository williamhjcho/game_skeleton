/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/28/13
 * Time: 11:04 AM
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.view.menu {
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;

public class Menu extends DisplayObjectContainer {

    private var items:Vector.<Item> = new Vector.<Item>();
    private var animateIn:Function, animateOut:Function;
    private var currentPath:Vector.<int> = new Vector.<int>();

    public function Menu() {
        super();

    }

    public function addItem(item:Item):void {
        var i:int = items.indexOf(item);
        if(i != -1) return; //already added

        item.x = 0;
        item.y = (items.length) * item.height;
        addChild(item);
    }

    public function addItems(list:Array):void {

    }

    public function render():void {
        for (var i:int = 0; i < items.length; i++) {
            var item:Item = items[i];
            addChild(item);
            item.x = 0;
            item.y = i * item.height;
        }
    }


    //==================================
    //     Events
    //==================================
    private function onClickItem(e:MouseEvent):void {
        var item:Item = e.currentTarget as Item;
        if(item.hasChildren) {
            //open sub menu
        } else {
            //execute function
        }
    }

    private function onOverItem(e:MouseEvent):void {

    }

    private function onOutItem(e:MouseEvent):void {

    }


}
}
