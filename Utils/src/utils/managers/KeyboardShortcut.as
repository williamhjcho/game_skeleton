package utils.managers {
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;

/**
 * @author Rafael Belvederese
 */
public class KeyboardShortcut extends EventDispatcher {

    private var _keyString:String;
    private var _keyCode:int = -1;

    public var altKey:Boolean;
    public var ctrlKey:Boolean;
    public var shiftKey:Boolean;
    public var alternateKeyCode:int = -1;

    public function KeyboardShortcut(altKey:Boolean = false, ctrlKey:Boolean = false, shiftKey:Boolean = false, key:* = undefined) {
        this.altKey = altKey;
        this.ctrlKey = ctrlKey;
        this.shiftKey = shiftKey;
        if (key != undefined) {
            if (key is String) {
                this.keyString = key;
            } else if (key is int) {
                this.keyCode = key;
            }
        }
    }

    public function compare(event:KeyboardEvent):void {
        if (event.keyCode != this.keyCode && event.keyCode != this.alternateKeyCode) return;
        if (event.altKey != this.altKey) return;
        if (event.ctrlKey != this.ctrlKey) return;
        if (event.shiftKey != this.shiftKey) return;
        this.dispatchEvent(event);
    }

    public function get keyString():String {
        return _keyString;
    }

    public function set keyString(keyString:String):void {
        _keyString = keyString.toUpperCase();
    }

    public function get keyCode():int {
        if (this._keyCode >= 0) return _keyCode;
        if (!this.keyString) return -1;
        return this.keyString.charCodeAt(0);
    }

    public function set keyCode(keyCode:int):void {
        _keyCode = keyCode;
    }
}
}
