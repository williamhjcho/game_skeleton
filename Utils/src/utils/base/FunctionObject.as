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

    public function FunctionObject(caller:* = null, f:Function = null, p:Array = null) {
        this._caller = caller;
        this._function = f;
        this._parameters = p;
    }

    public function reset(f:Function = null, p:Array = null):FunctionObject {
        this._function = f;
        this._parameters = p;
        return this;
    }

    public function execute(caller:* = null):FunctionObject {
        var f:Function = _function;
        var fp:Array = _parameters;
        if(f != null)
            f.apply(caller || _caller || this, fp);
        return this;
    }

    public function clear():FunctionObject {
        _function = null;
        _parameters = null;
        return this;
    }

    public function destroy():FunctionObject {
        _caller = null;
        _function = null;
        _parameters = null;
        return this;
    }


    public function get caller      ():* { return this._caller; }
    public function get func        ():Function { return this._function; }
    public function set func        (f:Function):void { this._function = f; }
    public function get parameters  ():Array { return this._parameters; }
    public function set parameters  (p:Array):void { this._parameters = p; }
}
}
