/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/28/13
 * Time: 11:04 AM
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.view.menu {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;

public class Menu {

    private var container:DisplayObjectContainer;

    private var tree:Vector.<MenuItem>;
    private var currentPath:Vector.<int> = new Vector.<int>();

    public var parameters:MenuParameters;

    public function Menu(container:DisplayObjectContainer, parameters:MenuParameters = null) {
        if(container == null)
            throw new ArgumentError("Container cannot be null.");

        this.container = container;
        this.parameters = parameters || new MenuParameters();
        this.tree = new Vector.<MenuItem>();
    }

    public function get depth():int { return currentPath.length; }
    public function get currentNumChilds():int { return tree.length; }

    //==================================
    //
    //==================================
    public function add(image:DisplayObject):MenuItem {
        var item:MenuItem = new MenuItem(image);
        tree.push(item);
        renderFrom(tree);
        return item;
    }

    public function addList(list:*):void {
        for each (var image:DisplayObject in list) {
            var item:MenuItem = new MenuItem(image);

        }
        renderFrom(tree);
    }

    public function renderFrom(list:Vector.<MenuItem>):void {
        var x:Number = parameters.paddingLeft, y:Number = parameters.paddingTop;
        for each (var item:MenuItem in list) {
            container.addChild(item.image);
            //animate In function
            item.x = x;
            item.y = y;

            y += item.height + parameters.spacing;

            addEventsTo(item.image);
        }
    }

    public function openIndex(index:int):void {
        currentPath.push(index);

    }

    private function addEventsTo(target:DisplayObject):void {
        if(target.hasOwnProperty("buttonMode")) target["buttonMode"] = true;
        target.addEventListener(MouseEvent.CLICK, onClickItem);
        target.addEventListener(MouseEvent.ROLL_OVER, onOverItem);
        target.addEventListener(MouseEvent.ROLL_OUT, onOutItem);
    }

    private function removeEventsOf(target:DisplayObject):void {
        if(target.hasOwnProperty("buttonMode")) target["buttonMode"] = false;
        target.removeEventListener(MouseEvent.CLICK, onClickItem);
        target.removeEventListener(MouseEvent.ROLL_OVER, onOverItem);
        target.removeEventListener(MouseEvent.ROLL_OUT, onOutItem);
    }


    //==================================
    //     Events
    //==================================
    private function onClickItem(e:MouseEvent):void {
        var item:DisplayObject = e.currentTarget as DisplayObject;

    }

    private function onOverItem(e:MouseEvent):void {

    }

    private function onOutItem(e:MouseEvent):void {

    }
}
}


