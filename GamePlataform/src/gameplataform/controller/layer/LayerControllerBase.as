/**
 * Created with IntelliJ IDEA.
 * User: filipe
 * Date: 30/01/13
 * Time: 17:49
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.controller.layer {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.utils.Dictionary;

public class LayerControllerBase {

    private var _name:String;
    private var instances:Dictionary;
    private var counterInstances:Dictionary;

    public var placeHolder:DisplayObjectContainer;

    public function LayerControllerBase(placeHolder:DisplayObjectContainer, name:String = null) {
        this._name = name || placeHolder.name;
        this.placeHolder = placeHolder;
        this.instances = new Dictionary();
        this.counterInstances = new Dictionary();
    }

    public function get name():String { return this._name; }

    //==================================
    //  Public
    //==================================
    public function addChild(child:DisplayObject, childName:String, x:Number = Number.NaN, y:Number = Number.NaN):void {
        if(!isNaN(x)) child.x = x;
        if(!isNaN(y)) child.y = y;
        placeHolder.addChild(child);
        instances[childName] = child;
        counterInstances[child] = childName;
    }

    public function removeChild(child:DisplayObject):DisplayObject {
        if(placeHolder.contains(child)) {
            placeHolder.removeChild(child);
            delete instances[counterInstances[child]];
            delete counterInstances[child];
        }
        return child;
    }

    public function removeChildByName(name:String):DisplayObject {
        var child:DisplayObject = instances[name];
        if (child != null)
            removeChild(child);
        return child;
    }

    public function removeAll():void {
        for each (var child:DisplayObject in instances) {
            removeChild(child);
        }
    }

    public function getChild(name:String):DisplayObject {
        return instances[name];
    }

    public function swap(name1:String, name2:String):void {
        placeHolder.swapChildren(instances[name1], instances[name2]);
    }

    public function getIndex(name:String):int {
        return placeHolder.getChildIndex(instances[name]);
    }
}
}
