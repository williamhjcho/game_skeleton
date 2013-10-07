/**
 * Created with IntelliJ IDEA.
 * User: filipe
 * Date: 30/01/13
 * Time: 17:49
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.bases {
import com.greensock.TweenMax;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.utils.Dictionary;

public class LayerControllerBase {

    public static var globalInstances:Dictionary = new Dictionary();
    public static var layers:Dictionary = new Dictionary();

    public var name:String;
    public var placeHolder:MovieClip;
    public var instances:Dictionary;


    public function LayerControllerBase(placeHolder:MovieClip, layerName:String = null) {
        if(layers[layerName] != null || layers[layerName] != undefined)
            throw new Error("[LayerControllerBase] Layer " + layerName + " is already registered.");
        else {
            this.name = layerName || placeHolder.name;
            this.placeHolder = placeHolder;
            this.instances = new Dictionary();
            layers[layerName] = this;
        }
    }

    /** Public Instance Access **/
    public function addChild(child:DisplayObject, childName:String, posX:int = NaN, posY:int = NaN):void {
        if(!isNaN(posX)) child.x = posX;
        if(!isNaN(posY)) child.y = posY;
        placeHolder.addChild(child);
        instances[childName] = child;
        instances[child] = childName;
        globalInstances[this.name + "." + childName] = child;
    }

    public function removeChild(child:DisplayObject, tweenTime:Number = 0):DisplayObject {
        var childName:String = instances[child];
        if(childName != null) {
            if(tweenTime <= 0) {
                remove(childName);
            } else {
                TweenMax.to(child, tweenTime, {alpha:0, onComplete: remove, onCompleteParams:[childName]});
            }
        }
        return child;
    }

    public function removeChildByName(childName:String, tempoTween:Number = 0):DisplayObject {
        var child:DisplayObject = instances[childName];
        if (child != null) {
            if (tempoTween <= 0) {
                remove(childName);
            } else {
                TweenMax.to(instances[childName], tempoTween, {alpha: 0, onComplete: remove, onCompleteParams: [childName]});
            }
        }
        return child;
    }

    public function removeAll():void {
        for (var childName:String in instances) {
            removeChildByName(childName);
        }
    }

    public function getChild(childName:String):DisplayObject {
        return instances[childName];
    }

    public function destroy():void {
        removeAll();
        delete layers[this.name];
    }

    private function remove(inName:String):void {
        var child:DisplayObject = instances[inName];
        placeHolder.removeChild(child);
        delete instances[inName];
        delete instances[child];
        delete globalInstances[this.name + inName];
    }

    /** Static Access **/
    public static function getInstance(layer:*, name:String):DisplayObject {
        //layer = LayerControllerBase or layer.name
        var layerName:String = (layer is LayerControllerBase) ? layer.name : layer;
        return globalInstances[layerName + "." + name];
    }

    public static function removeAll():void {
        for each (var layer:LayerControllerBase in layers) {
            layer.removeAll();
        }
    }

    public static function destroyAll():void {
        for each (var layer:LayerControllerBase in layers) {
            layer.destroy();
        }
    }


}
}
