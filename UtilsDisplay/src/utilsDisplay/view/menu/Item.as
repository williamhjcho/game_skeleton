/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/28/13
 * Time: 11:05 AM
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.view.menu {
import flash.display.DisplayObject;

public class Item extends DisplayObject {

    public var children:Vector.<Item>;
    public var onClick:Function;

    public function Item() {

    }

    public function add(child:Item):void {
        if(children == null) {
            children = new <Item>[child];
        } else {
            var i:int = children.indexOf(child);
            if(i == -1) {
                children.push(child);
            }
        }
    }

    public function remove(child:Item):Item {
        if(children == null) return null;
        var i:int = children.indexOf(child);
        return (i == -1)? null : children.splice(i,1)[0];
    }

    public function removeByIndex(index:int):Item {
        if(children == null || children.length <= index) return null;
        return children.splice(index, 1)[0];
    }

    public function hasChild(item:Item):Boolean {
        if(children == null || children.length == 0) return false;
        for each (var child:Item in children) {
            if(child == item) return true;
            if(child.hasChild(item)) return true;
        }
        return false;
    }

    //==================================
    //
    //==================================
    public function get hasChildren():Boolean {
        return !(children == null || children.length == 0);
    }
}
}
