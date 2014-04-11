/**
 * Created by William on 4/3/14.
 */
package utilsDisplay.managers {
import flash.display.Sprite;
import flash.geom.Rectangle;

public class Dragger {

    public var centralize:Boolean = true;
    public var lockCenter:Boolean = false;

    private var _isDragging:Boolean = false;
    private var _target:Sprite;
    private var _area:Rectangle = new Rectangle(0,0,0,0);

    public function Dragger(target:Sprite, area:Rectangle, centralize:Boolean = true, lockCenter:Boolean = false) {
        this._target = target;
        this.centralize = centralize;
        this.lockCenter = lockCenter;
        if(area == null) {
            this._area = null;
        } else {
            this._area.x        = area.x;
            this._area.y        = area.y;
            this._area.width    = area.width;
            this._area.height   = area.height;
        }
    }

    private var _temp:Rectangle = new Rectangle(0,0,0,0);
    public function startDrag():void {
        if(_area == null) {
            _target.startDrag(lockCenter, null);
            return;
        }
        var tw:Number = _target.width, th:Number = _target.height;
        var sw:Number = _area.width, sh:Number = _area.height;
        //width
        if(tw > sw) { //target is bigger
            _temp.x = sw - tw;
            _temp.width = tw - sw;
        } else { //area is bigger
            if(centralize) {
                _temp.x = sw - tw >> 1;
                _temp.width = 0;
            } else {
                _temp.x = 0;
                _temp.width = sw - tw;
            }
        }
        ///height
        if(th > sh) { //target is bigger
            _temp.y = sh - th;
            _temp.height = th - sh;
        } else { //area is bigger
            if(centralize) {
                _temp.y = sh - th >> 1;
                _temp.height = 0;
            } else {
                _temp.y = 0;
                _temp.height = sh - th;
            }
        }
        _isDragging = true;
        _target.startDrag(lockCenter, _temp);
    }

    public function stopDrag():void {
        _isDragging = false;
        _target.stopDrag();
    }

    //==================================
    //  Get / Set
    //==================================
    public function get target():Sprite { return _target; }
    public function set target(t:Sprite):void { _target = t; }

    public function get isDragging():Boolean { return _isDragging; }

    public function get area():Rectangle {
        return _area.clone();
    }
    public function set area(r:Rectangle):void {
        if(r == null) {
            _area = null;
        } else {
            _area ||= new Rectangle();
            this._area.x        = r.x;
            this._area.y        = r.y;
            this._area.width    = r.width;
            this._area.height   = r.height;
        }
    }

    public function get x       ():Number { return _area.x; }
    public function get y       ():Number { return _area.y; }
    public function get width   ():Number { return _area.width; }
    public function get height  ():Number { return _area.height; }

    public function set x       (v:Number):void { _area.x = v; }
    public function set y       (v:Number):void { _area.y = v; }
    public function set width   (v:Number):void { _area.width = v; }
    public function set height  (v:Number):void { _area.height = v; }
}
}
