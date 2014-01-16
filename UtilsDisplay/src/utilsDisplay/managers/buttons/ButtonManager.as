/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 8/14/13
 * Time: 7:29 PM
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.managers.buttons {

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.utils.Dictionary;
import flash.utils.setTimeout;

public class ButtonManager {

    private static const STATUS_DISABLED:uint = 0;
    private static const STATUS_ENABLED :uint = 1;

    public static var DEFAULT_OVER_COLOR:uint = 0xffbb00;
    public static var DEFAULT_DOWN_COLOR:uint = 0x000000;
    public static var DEFAULT_DELAY_TIME:uint = 0;
    public static var DEFAULT_BUTTON_MODE:Boolean = true;

    private static const MODE_NONE :uint = 0;
    private static const MODE_OVER :uint = 1;
    private static const MODE_DOWN :uint = 2;

    private static const BUTTON_MODE:String = "buttonMode";

    private static var _buttons:Dictionary = new Dictionary();
    private static var _focus:DisplayObject = null;

    public static function add(button:DisplayObject, parameters:Object):void {
        var p:ButtonProperty = _buttons[button];

        if(p != null)
            throw new ArgumentError("Already registered instance : \"" + button.name + "\".");

        parameters ||= {};

        p                   = new ButtonProperty();
        p.reference         = button;
        p.status            = STATUS_DISABLED;
        p.mode              = MODE_NONE;

        p.priority          = parameters.priority || 0;
        p.useCapture        = (parameters.useCapture == null)? false : parameters.useCapture;
        p.useWeakReference  = (parameters.useWeakReference == null)? false : parameters.useWeakReference;

        p.useDefault    = parameters.useDefault == null ? true : parameters.useDefault;
        p.delay         = parameters.delay != int.MIN_VALUE? parameters.delay : DEFAULT_DELAY_TIME;
        p.overColor     = parameters.overColor  || DEFAULT_OVER_COLOR   ;
        p.downColor     = parameters.downColor  || DEFAULT_DOWN_COLOR   ;
        p.buttonMode    = parameters.buttonMode || DEFAULT_BUTTON_MODE  ;

        p.onClick       = parameters.onClick;
        p.onDown        = parameters.onDown     || (p.useDefault? defaultDown     : null);
        p.onUp          = parameters.onUp       || (p.useDefault? defaultUp       : null);
        p.onOver        = parameters.onOver     || (p.useDefault? defaultOver     : null);
        p.onOut         = parameters.onOut      || (p.useDefault? defaultOut      : null);
        p.onEnable      = parameters.onEnable   || (p.useDefault? defaultEnable   : null);
        p.onDisable     = parameters.onDisable  || (p.useDefault? defaultDisable  : null);

        _buttons[button] = p;

        enable(button);
    }

    public static function remove(button:DisplayObject):void {
        var p:ButtonProperty = _buttons[button];

        if(p == null || button == null) return;
        button.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
        button.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        button.removeEventListener(MouseEvent.ROLL_OVER, onOver);
        button.removeEventListener(MouseEvent.ROLL_OUT, onOut);
        p.destroy();
        delete _buttons[button];
    }

    public static function change(button:DisplayObject, parameters:Object):void {
        var p:ButtonProperty = _buttons[button];
        if(p == null || parameters == null)
            return;

        p.priority          = parameters.priority || 0;
        p.useCapture        = (parameters.useCapture == null)? false : parameters.useCapture;
        p.useWeakReference  = (parameters.useWeakReference == null)? false : parameters.useWeakReference;

        p.useDefault    = parameters.useDefault == null ? p.useDefault : parameters.useDefault;
        p.delay         = parameters.delay      || p.delay     ;
        p.overColor     = parameters.overColor  || p.overColor ;
        p.downColor     = parameters.downColor  || p.downColor ;
        p.buttonMode    = parameters.buttonMode || p.buttonMode;

        p.onClick       = parameters.onClick   || p.onClick;
        p.onDown        = parameters.onDown    || p.onDown    || (p.useDefault? defaultDown     : null);
        p.onUp          = parameters.onUp      || p.onUp      || (p.useDefault? defaultUp       : null);
        p.onOver        = parameters.onOver    || p.onOver    || (p.useDefault? defaultOver     : null);
        p.onOut         = parameters.onOut     || p.onOut     || (p.useDefault? defaultOut      : null);
        p.onEnable      = parameters.onEnable  || p.onEnable  || (p.useDefault? defaultEnable   : null);
        p.onDisable     = parameters.onDisable || p.onDisable || (p.useDefault? defaultDisable  : null);
    }

    public static function enable(button:DisplayObject):void {
        var p:ButtonProperty = _buttons[button];

        if(p == null || p.status == STATUS_ENABLED) return;

        p.status = STATUS_ENABLED;

        if(p.buttonMode && button.hasOwnProperty(BUTTON_MODE))
            button[BUTTON_MODE] = true;
        button.addEventListener(MouseEvent.ROLL_OVER, onOver, p.useCapture, p.priority, p.useWeakReference);
        button.addEventListener(MouseEvent.ROLL_OUT , onOut, p.useCapture, p.priority, p.useWeakReference);
        p.callEnable();
    }

    public static function disable(button:DisplayObject):void {
        var p:ButtonProperty = _buttons[button];

        if(p == null || p.status == STATUS_DISABLED) return;

        p.status = STATUS_DISABLED;
        if(p.buttonMode && button.hasOwnProperty(BUTTON_MODE))
            button[BUTTON_MODE] = false;
        button.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
        button.removeEventListener(MouseEvent.MOUSE_UP  , onUp);
        button.removeEventListener(MouseEvent.ROLL_OVER , onOver);
        button.removeEventListener(MouseEvent.ROLL_OUT  , onOut);
        p.callDisable();
    }

    public static function setStatus(button:DisplayObject, enable:Boolean):void {
        if(enable)  ButtonManager.enable(button);
        else        ButtonManager.disable(button);
    }

    public static function isRegistered(button:DisplayObject):Boolean {
        return (button in _buttons);
    }

    public static function isEnabled(button:DisplayObject):Boolean {
        return isRegistered(button) ? ButtonProperty(_buttons[button]).status == STATUS_ENABLED : false;
    }

    public static function get currentFocus():DisplayObject { return _focus; }

    /** Mouse Events **/
    private static function onDown(e:MouseEvent):void {
        var button:DisplayObject = e.currentTarget as DisplayObject;
        button.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
        var p:ButtonProperty = _buttons[button];
        if(p == null) throw new Error("Un-disposed button: \"" + button.name + "\".");
        button.addEventListener(MouseEvent.MOUSE_UP, onUp, p.useCapture, p.priority, p.useWeakReference);
        p.mode = MODE_DOWN;
        p.callDown();
    }

    private static function onUp(e:MouseEvent):void {
        var button:DisplayObject = e.currentTarget as DisplayObject;
        var p:ButtonProperty = _buttons[button];
        if(p == null) throw new Error("Un-disposed button: \"" + button.name + "\".");
        if(p.delay > 0) {
            button.removeEventListener(MouseEvent.MOUSE_UP, onUp);
            disableOnClick(button);
            setTimeout(enableOnClick, p.delay, button);
        }
        p.callUp();
        p.callClick();
    }

    private static function onOver(e:MouseEvent):void {
        var button:DisplayObject = e.currentTarget as DisplayObject;
        var p:ButtonProperty = _buttons[button];
        if(p == null) throw new Error("Un-disposed button: \"" + button.name + "\".");
        button.addEventListener(MouseEvent.MOUSE_DOWN, onDown, p.useCapture, p.priority, p.useWeakReference);
        _focus = button;
        p.mode = MODE_OVER;
        p.callOver();
    }

    private static function onOut(e:MouseEvent):void {
        var button:DisplayObject = e.currentTarget as DisplayObject;
        button.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
        button.removeEventListener(MouseEvent.MOUSE_UP  , onUp);
        _focus = null;
        var p:ButtonProperty = _buttons[button];
        if(p == null) throw new Error("Un-disposed button: \"" + button.name + "\".");
        if(p.mode == MODE_DOWN)  //still holding mouse down
            p.callUp();
        p.mode = MODE_NONE;
        p.callOut();
    }

    private static function enableOnClick(button:DisplayObject):void {
        var p:ButtonProperty = _buttons[button];
        if(p == null || p.status != STATUS_ENABLED) return;
        button.addEventListener(MouseEvent.ROLL_OVER, onOver, p.useCapture, p.priority, p.useWeakReference);
        button.addEventListener(MouseEvent.MOUSE_UP, onUp, p.useCapture, p.priority, p.useWeakReference);
        p.callEnable();
    }

    private static function disableOnClick(button:DisplayObject):void {
        var p:ButtonProperty = _buttons[button];
        if(p == null) return;
        button.removeEventListener(MouseEvent.ROLL_OVER, onOver);
        button.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        p.callDisable();
    }



    /** Default Effects **/
    private static function defaultDown(button:DisplayObject):void {
        var p:ButtonProperty = _buttons[button];
        if(p.useDefault)
            TweenMax.to(p.reference, 0.3, {colorMatrixFilter: {colorize: p.downColor, amount: 0.3, saturation: 1}});
    }
    private static function defaultUp(button:DisplayObject):void {
        var p:ButtonProperty = _buttons[button];
        if(p.useDefault)
            TweenMax.to(p.reference, 0.3, {colorMatrixFilter: {remove: true}});
    }
    private static function defaultOver(button:DisplayObject):void {
        var p:ButtonProperty = _buttons[button];
        if(p.useDefault)
            TweenMax.to(p.reference, 0.3, {glowFilter: {color: p.overColor, alpha: 1, blurX: 5, blurY: 5, strength: 3, ease: Linear.easeInOut}});
    }
    private static function defaultOut(button:DisplayObject):void {
        var p:ButtonProperty = _buttons[button];
        if(p.useDefault)
            TweenMax.to(p.reference, 0.1, {glowFilter: {remove: true}});
    }
    private static function defaultEnable(button:DisplayObject):void {
        var p:ButtonProperty = _buttons[button];
        if(p.useDefault)
            TweenMax.to(p.reference, 0.3, {colorMatrixFilter: {colorize: 0x000000, amount: 0, saturation: 1, remove: true}});
    }
    private static function defaultDisable(button:DisplayObject):void {
        var p:ButtonProperty = _buttons[button];
        if(p.useDefault)
            TweenMax.to(p.reference, 0.3, {colorMatrixFilter: {colorize: 0x000000, amount: 0.5, saturation: 0}});
    }
}
}

class ButtonProperty {

    public var reference:Object = null;

    public var status           :int    = int.MIN_VALUE;
    public var mode             :int    = int.MIN_VALUE;
    public var delay            :Number = int.MIN_VALUE;
    public var buttonMode       :Boolean = true;
    public var useDefault       :Boolean = true;
    public var overColor        :uint   = 0x000000;
    public var downColor        :uint   = 0x000000;
    public var priority         :uint = 0;
    public var useCapture       :Boolean = false;
    public var useWeakReference :Boolean = false;

    public var onClick    :Function = null;
    public var onDown     :Function = null;
    public var onUp       :Function = null;
    public var onOver     :Function = null;
    public var onOut      :Function = null;
    public var onEnable   :Function = null;
    public var onDisable  :Function = null;

    public function callClick  ():void { if(onClick   != null) onClick  .call(this, reference); }
    public function callDown   ():void { if(onDown    != null) onDown   .call(this, reference); }
    public function callUp     ():void { if(onUp      != null) onUp     .call(this, reference); }
    public function callOver   ():void { if(onOver    != null) onOver   .call(this, reference); }
    public function callOut    ():void { if(onOut     != null) onOut    .call(this, reference); }
    public function callEnable ():void { if(onEnable  != null) onEnable .call(this, reference); }
    public function callDisable():void { if(onDisable != null) onDisable.call(this, reference); }

    public function destroy():void {
        this.onClick   = null;
        this.onDown    = null;
        this.onUp      = null;
        this.onOver    = null;
        this.onOut     = null;
        this.onEnable  = null;
        this.onDisable = null;
    }
}
