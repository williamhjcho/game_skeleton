/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 09/04/13
 * Time: 14:06
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.io {
import flash.events.KeyboardEvent;

public class InputShortcut {

    private var _code:int = -1; //keyCode
    private var _direction:String = ""; //up,down
    private var _alt   :Boolean = false;
    private var _ctrl  :Boolean = false;
    private var _shift :Boolean = false;

    public var f:Function = null;
    public var fArgs:Array = null;

    private var _key:String = "";

    public function InputShortcut(code:int, direction:String, f:Function, fArgs:Array = null, altKey:Boolean = false, ctrlKey:Boolean = false, shiftKey:Boolean = false) {
        this._alt = altKey;
        this._ctrl = ctrlKey;
        this._shift = shiftKey;
        this._direction = direction;
        this._code = code;
        this.f = f;
        this.fArgs = fArgs;
        _key = makeKey(this);
    }

    public function check(e:KeyboardEvent):void {
        if((e.keyCode != _code)
        || (_alt != e.altKey)
        || (_ctrl != e.ctrlKey)
        || (_shift != e.shiftKey))  return;
        //executing
        if(f != null) f.apply(this, fArgs);
    }

    public function destroy():void {
        f = null;
        fArgs = null;
    }

    public function get key():String { return _key; } //read only

    public function get code()      :int    { return _code; }
    public function set code(c:int) :void   { this._code = c; _key = makeKey(this); }

    public function get direction()         :String { return _direction;                    }
    public function set direction(v:String) :void   { _direction = v; _key = makeKey(this); }
    public function get alt()           :Boolean    { return _alt;                          }
    public function set alt(v:Boolean)  :void       { _alt = v;     _key = makeKey(this);   }
    public function get ctrl()          :Boolean    { return _ctrl;                         }
    public function set ctrl(v:Boolean) :void       { _ctrl = v;    _key = makeKey(this);   }
    public function get shift()         :Boolean    { return _shift;                        }
    public function set shift(v:Boolean):void       { _shift = v;   _key = makeKey(this);   }

    public static function makeKey(i:InputShortcut):String {
        //code_direction_[tf][tf][tf]
        return i.code + "_" + i.direction + "_" + i.alt.toString() + i.ctrl.toString() + i.shift.toString();
    }
}
}
