/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/29/13
 * Time: 10:33 AM
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.view.menu {
import flash.display.DisplayObject;

public class MenuItem {

    public var image:DisplayObject;
    public var children:Vector.<MenuItem>;

    public function MenuItem(image:DisplayObject, children:Vector.<MenuItem> = null) {
        if(image == null) throw new ArgumentError("Image cannot be null.");
        this.image = image;
        this.children = children;
    }

    public function addImage(image:DisplayObject):void {
        if(children == null)
            children = new <MenuItem>[new MenuItem(image)];
        else
            children.push(new MenuItem(image));
    }

    public function addItem(item:MenuItem):void {
        if(children == null)
            children = new <MenuItem>[item];
        else
            children.push(item);
    }

    public function removeChild(item:MenuItem):MenuItem {
        if(children == null)
            return null;
        var i:int = children.indexOf(item);
        if(i != -1)
            return children.splice(i,1)[0];
        return null;
    }

    public function get x():Number { return image.x; }
    public function get y():Number { return image.y; }

    public function set x(v:Number):void { image.x = v; }
    public function set y(v:Number):void { image.y = v; }

    public function get width   ():Number { return image.width; }
    public function get height  ():Number { return image.height; }

    public function set width   (v:Number):void { image.width = v; }
    public function set height  (v:Number):void { image.height = v; }

}
}
