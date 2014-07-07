/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 11/04/13
 * Time: 12:40
 * To change this template use File | Settings | File Templates.
 */
package utils.systems {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Point;
import flash.utils.Dictionary;

import utils.commands.toRad;
import utils.vector.v2d;

public class TurtleGraphics {

    protected var drawOrder :String; //string containing the rules of what to execute
    protected var orders    :Dictionary; //contains functions to be executed for every character in drawOrder

    protected var turtle:Shape;  //the drawing mechanism

    protected var direction     :v2d;    //direction to where the turtle will be heading in case of 'move forward'
    protected var currentPoint  :v2d;    //current point from which the turtle will draw the next step
    protected var currentAngle  :Number; //(in radians)
    protected var angleVariation:Number; //(in radians) angle to add/subtract for every 'turn left/right'

    protected var l:Number;     //length in pixels of every stroke (draw line)
    protected var c:int;        //current iteration/char index (from drawOrder)

    protected var savedPos      :Vector.<Number>;
    protected var savedAngle    :Vector.<Number>;
    protected var savedPosAngle :Vector.<Number>;

    //last configs
    private var startPos:Point;
    private var _color:uint, _thickness:Number, _alpha:Number, _fill:Boolean, _fillColor:uint, _fillAlpha:Number;


    public function TurtleGraphics(drawOrder:String, startPos:Point, l:Number = 5, startDegree:Number = 0) {
        this.drawOrder = drawOrder;
        this.orders = new Dictionary();
        this.l = l;
        this.c = 0;
        this.angleVariation = 0;
        this.currentAngle   = toRad(startDegree);
        this.startPos       = startPos;
        this.currentPoint   = new v2d(startPos.x,startPos.y);
        this.direction      = new v2d(0,0);
        this.savedPos       = new Vector.<Number>;
        this.savedAngle     = new Vector.<Number>;
        this.savedPosAngle  = new Vector.<Number>;

        turtle = new Shape();
        turtle.graphics.moveTo(currentPoint.x, currentPoint.y);
        setLineStyle(0,Math.random()*0xffffff,1);
    }

    /** PUBLIC ACCESS **/
    public function iterate(param:* = null):void {
        var char:String = drawOrder.charAt(c++);
        if(orders[char] != null && orders[char] != undefined) {
            orders[char].apply(this, param);
        }
    }

    public function iterateN(n:int):void {
        for (var i:int = 0; i < n; i++) { iterate(); }
    }

    public function draw():void {
        while(c < drawOrder.length) { iterate(); }
    }

    public function setLineStyle(thickness:Number, color:uint, alpha:Number = 1):void {
        this._thickness = thickness; this._color = color; this._alpha = alpha;
        turtle.graphics.lineStyle(thickness,color, alpha);
    }

    public function fill(b:Boolean, color:uint = 0xffffff, alpha:Number = 1):void {
        this._fill = b;
        if(b) {
            this._fillColor = color; this._fillAlpha = alpha;
            turtle.graphics.beginFill(color, alpha);
        } else {
            turtle.graphics.endFill();
        }
    }

    public function clear():void {
        turtle.graphics.clear();
        turtle.graphics.lineStyle(_thickness,_color,_alpha);
        if(_fill) turtle.graphics.beginFill(_fillColor,_fillAlpha);
    }

    public function reset():void {
        clear();
        this.c = 0;
        currentPoint.setTo(startPos.x, startPos.y);
        savedPos     .splice(0, savedPos     .length);
        savedAngle   .splice(0, savedAngle   .length);
        savedPosAngle.splice(0, savedPosAngle.length);
    }

    public function addOrder(order:String, f:Function)  :void { orders[order] = f; }
    public function removeOrder(order:String)           :void { delete orders[order]; }

    /** GET SET **/
    public function getShape():Shape { return turtle; }
    public function getBitmap():Bitmap {
        var bmd:BitmapData = new BitmapData(turtle.width,turtle.height,true,0x0);
        bmd.draw(turtle);
        return new Bitmap(bmd);
    }

    public function getIteration()      :int  { return this.c; }
    public function setIteration(c:int) :void { this.c = c; }

    public function getDrawOrder()                  :String { return this.drawOrder; }
    public function setDrawOrder(drawOrder:String)  :void   { this.drawOrder = drawOrder; this.c = 0; }

    /** BASIC MOVING FUNCTIONS **/
    protected function moveForward():void {
        currentPoint.addXY(direction.x * l, direction.y * l);
        turtle.graphics.moveTo(currentPoint.x, currentPoint.y);
    }
    protected function moveForwardBy(l:Number):void {
        currentPoint.addXY(direction.x * l, direction.y * l);
        turtle.graphics.moveTo(currentPoint.x, currentPoint.y);
    }

    protected function drawForward():void {
        currentPoint.addXY(direction.x * l, direction.y * l);
        turtle.graphics.lineTo(currentPoint.x, currentPoint.y);
    }
    protected function drawForwardBy(l:Number):void {
        currentPoint.addXY(direction.x * l, direction.y * l);
        turtle.graphics.lineTo(currentPoint.x, currentPoint.y);
    }

    protected function turnLeft ():void { currentAngle -= angleVariation; direction.setTo(Math.cos(currentAngle), Math.sin(currentAngle)); }
    protected function turnRight():void { currentAngle += angleVariation; direction.setTo(Math.cos(currentAngle), Math.sin(currentAngle)); }

    protected function turnLeftBy (rad:Number):void { currentAngle -= rad; direction.setTo(Math.cos(currentAngle), Math.sin(currentAngle)); }
    protected function turnRightBy(rad:Number):void { currentAngle += rad; direction.setTo(Math.cos(currentAngle), Math.sin(currentAngle)); }

    protected function turnLeft90() :void { currentAngle -= Math.PI/2; direction.setTo(Math.cos(currentAngle), Math.sin(currentAngle)); }
    protected function turnRight90():void { currentAngle += Math.PI/2; direction.setTo(Math.cos(currentAngle), Math.sin(currentAngle)); }

    protected function savePos()    :void {
        //save order -> y, x
        savedPos.push(currentPoint.y, currentPoint.x);
    }
    protected function resumePos()  :void {
        //retrieve order -> x, y
        currentPoint.setTo(savedPos.pop(),savedPos.pop());
        turtle.graphics.moveTo(currentPoint.x, currentPoint.y)
    }

    protected function saveAngle()  :void { savedAngle.push(currentAngle);   }
    protected function resumeAngle():void { currentAngle = savedAngle.pop(); direction.setTo(Math.cos(currentAngle), Math.sin(currentAngle)); }

    protected function savePosAngle():void {
        //save order -> y, x, angle
        savedPosAngle.push(currentPoint.y, currentPoint.x, currentAngle);
    }
    protected function resumePosAngle():void {
        //retrieve order - > angle, y, x
        currentAngle = savedPosAngle.pop();
        direction.setTo(Math.cos(currentAngle), Math.sin(currentAngle));
        currentPoint.setTo(savedPosAngle.pop(), savedPosAngle.pop());
        turtle.graphics.moveTo(currentPoint.x, currentPoint.y);
    }

    protected function drawPoint(radius:Number = 3):void {
        turtle.graphics.drawCircle(currentPoint.x, currentPoint.y, radius);
        turtle.graphics.moveTo(currentPoint.x, currentPoint.y);
    }
}
}
