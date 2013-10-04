/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 8/14/13
 * Time: 7:33 PM
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.managers.buttons {
internal final class ButtonProperty {

    public var reference:Object = null;

    public var status           :int    = NaN;
    public var mode             :int    = NaN;
    public var delay            :Number = NaN;
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

    public function callClick  ():void { onClick  .call(this, reference); }
    public function callDown   ():void { onDown   .call(this, reference); }
    public function callUp     ():void { onUp     .call(this, reference); }
    public function callOver   ():void { onOver   .call(this, reference); }
    public function callOut    ():void { onOut    .call(this, reference); }
    public function callEnable ():void { onEnable .call(this, reference); }
    public function callDisable():void { onDisable.call(this, reference); }

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
}
