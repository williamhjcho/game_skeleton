/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/18/13
 * Time: 3:19 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib {
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

public final class DoubleDictionary {

    private var _references:Dictionary;

    public function DoubleDictionary(weakKeys:Boolean = false) {
        _references = new Dictionary(weakKeys);
    }

    public function add(a:*, b:*):void {
        var ka:* = _references[a], kb:* = _references[b];
        if(ka == null && kb == null) {
            _references[a] = b;
            _references[b] = a;
            return;
        }

        var errorMessage:String;
        if(ka != null && kb != null) {
            errorMessage = "Both keys are already registered.";
        } else if(ka != null) {
            errorMessage = "Key A is already registered: " + a;
        } else {
            errorMessage = "Key B is already registered: " + b;
        }
        throw new IllegalOperationError(errorMessage);
    }

    public function remove(k:*):* {
        var counter:* = _references[k];
        delete _references[k];
        delete _references[counter];
        return counter;
    }

    public function get(k:*):* {
        return _references[k];
    }
}
}
