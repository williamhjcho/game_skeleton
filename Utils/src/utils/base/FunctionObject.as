/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 19/07/13
 * Time: 14:49
 * To change this template use File | Settings | File Templates.
 */
package utils.base {
public final class FunctionObject {

    private var _caller:*;
    private var _function:Function;
    private var _parameters:Array;

    public var destroyAfterExecution:Boolean;

    public function FunctionObject(caller:* = null, f:Function = null, p:Array = null, destroyAfterExecution:Boolean = false) {
        this._caller = caller;
        this._function = f;
        this._parameters = p;
        this.destroyAfterExecution = destroyAfterExecution;
    }

    public function get caller      ():* { return this._caller; }
    public function get func        ():Function { return this._function; }
    public function set func        (f:Function):void { this._function = f; }
    public function get parameters  ():Array { return this._parameters; }
    public function set parameters  (p:Array):void { this._parameters = p; }

    public function execute(caller:* = null):void {
        if(_function != null) _function.apply(caller || _caller, _parameters);
        if(destroyAfterExecution) destroy();
    }

    public function clear():void {
        _function = null;
        _parameters = null;
    }

    public function destroy():void {
        _caller = null;
        _function = null;
        _parameters = null;
    }
}
}
