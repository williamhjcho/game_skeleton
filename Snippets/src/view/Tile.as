/**
 * Created by William on 7/22/2014.
 */
package view {
import flash.display.Graphics;
import flash.display.MovieClip;
import flash.text.TextField;

import utils.color.Colors;

public class Tile extends MovieClip {

    public var arrow:MovieClip;
    public var txtCost:TextField;
    public var txtPriority:TextField;
    public var txtDistance:TextField;

    private var mWidth:Number, mHeight:Number;
    private var g:Graphics;

    private var mWalkable:Boolean = true;

    public function Tile(width:Number, height:Number) {
        super();
        g = super.graphics;
        mWidth = width;
        mHeight = height;
        asIs();

        txtCost.width = width;
        txtPriority.width = txtDistance.width = width / 2;
        txtCost.y = (height - 2*txtCost.height)/2;
        txtPriority.y = txtDistance.y = txtCost.y + txtCost.height;
        txtDistance.x = txtPriority.x + txtPriority.width;

        arrow.x = width/2;
        arrow.y = height/2;
        arrow.visible = false;
    }

    public function asIs        ():void { this.color = (mWalkable? Colors.WHITE : Colors.BLACK); }
    public function asFocus     ():void { this.color = Colors.PURPLE; }
    public function asStart     ():void { this.color = Colors.GREEN; }
    public function asEnd       ():void { this.color = Colors.RED; }
    public function asUnWalkable():void { this.color = Colors.BLACK; }
    public function asWalkable  ():void { this.color = Colors.WHITE; }
    public function asPath      ():void { this.color = Colors.GRAY; }
    public function asNeighbor  ():void { this.color = Colors.OLIVE; }

    public function set cost(t:String):void { txtCost.text = t; }
    public function set priority(t:String):void { txtPriority.text = t; }
    public function set distance(t:String):void { txtDistance.text = t; }


    public function get cost():String { return txtCost.text; }
    public function get priority():String { return txtPriority.text; }
    public function get distance():String { return txtDistance.text; }



    public function setDirection(d:int):void {
        switch(d) {
            case 0: /*up    */ arrow.rotation = -90; break;
            case 1: /*right */ arrow.rotation = 0; break;
            case 2: /*down  */ arrow.rotation = 90; break;
            case 3: /*left  */ arrow.rotation = 180; break;
        }
    }

    public function get px():int { return this.x / mWidth; }
    public function get py():int { return this.y / mHeight; }

    public function set color(c:uint):void {
        g.clear();
        g.lineStyle(1, 0x303030);
        g.beginFill(0xffffff & c);
        g.drawRect(0, 0, mWidth, mHeight);
        g.endFill();
    }

    public function get walkable():Boolean {
        return mWalkable;
    }

    public function set walkable(b:Boolean):void {
        mWalkable = b;
        if(b) asWalkable();
        else asUnWalkable();
    }
}
}
