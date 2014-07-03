/**
 * Created with IntelliJ IDEA.
 * User: Filipe
 * Date: 04/09/13
 * Time: 21:20
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.view.preloader {
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import utils.toollib.color.ToolColor;

import utilsDisplay.bases.interfaces.IPreLoader;
import utilsDisplay.font.FontUbuntuRegular;

public class DefaultPreLoader extends Sprite implements IPreLoader {

    public var txtLabel:TextField;
    public var mcBackground:Sprite;
    public var dimensions:Rectangle = new Rectangle(0,0,600,400);
    private var _percentage:Number = 0;

    public function DefaultPreLoader() {
        mcBackground= new Sprite();
        mcBackground.graphics.beginFill(0x0423111,1);
        mcBackground.graphics.drawRect(dimensions.x, dimensions.y, dimensions.width, dimensions.height);
        mcBackground.graphics.endFill();
        this.addChild(mcBackground);

        var format:TextFormat = FontUbuntuRegular.getFormat();
        format.size = 50;

        txtLabel = new TextField();
        txtLabel.setTextFormat(format);
        txtLabel.autoSize = TextFieldAutoSize.CENTER;
        txtLabel.multiline = true;
        txtLabel.selectable = false;
        txtLabel.mouseEnabled = false;
        txtLabel.text = "";
        txtLabel.width = dimensions.width;
        txtLabel.height = dimensions.height;
        txtLabel.x = (this.width - txtLabel.width) >> 1;
        txtLabel.y = (this.height - txtLabel.height) >> 1;
        this.addChild(txtLabel);

        this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        this.addEventListener(Event.ENTER_FRAME, onEF);
        this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
    }
    private function onRemoved(e:Event):void {
        this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
        this.removeEventListener(Event.ENTER_FRAME, onEF);
        this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private var offSet:Object = {r:0.005, g:0.005, b:0.005};
    private var theta:Object = {r:Math.random()*Math.PI*2, g:Math.random()*Math.PI*2, b:Math.random()*Math.PI*2};
    private function onEF(e:Event):void {
        var r:int = 0xff * (1 + Math.sin(theta.r)) / 2;
        var g:int = 0xff * (1 + Math.sin(theta.g)) / 2;
        var b:int = 0xff * (1 + Math.sin(theta.b)) / 2;

        theta.r += offSet.r; if(theta.r < 0 || theta.r > Math.PI*2) offSet.r *= -1;
        theta.g += offSet.g; if(theta.g < 0 || theta.g > Math.PI*2) offSet.g *= -1;
        theta.b += offSet.b; if(theta.b < 0 || theta.b > Math.PI*2) offSet.b *= -1;

        var color:uint = ToolColor.RGBtoInt(r,g,b);
        mcBackground.graphics.clear();
        mcBackground.graphics.beginFill(color, 1);
        mcBackground.graphics.drawRect(dimensions.x, dimensions.y, dimensions.width, dimensions.height);

        txtLabel.textColor = ToolColor.opposite(color);
    }


    //==================================
    //     Public/Interface
    //==================================
    public function set percentage(p:Number):void {
        _percentage = p;
        txtLabel.text = "Loading : " + int(p * 100) + "%";
    }

    public function get percentage():Number {
        return _percentage;
    }

    override public function set visible(v:Boolean):void {
        super.visible = v;
        if(v)   this.addEventListener(Event.ENTER_FRAME, onEF);
        else    this.removeEventListener(Event.ENTER_FRAME, onEF);
    }





}
}
