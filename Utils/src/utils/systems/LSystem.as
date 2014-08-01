/**
 * Created by William on 7/29/2014.
 */
package utils.systems {
import flash.utils.Dictionary;

public class LSystem {

    private var _original:String;
    private var _axiom:String;
    private var _generation:int;
    private var _table:Dictionary;

    public function LSystem(axiom:String, variables:Vector.<String>, substitutions:Vector.<String>) {
        _original = _axiom = axiom;
        _table = new Dictionary();
        _generation = 0;

        setVariables(variables, substitutions);
    }

    public function iterate(n:int = 1):String {
        for (var i:int = 0; i < n; i++) {
            var split:Array = _axiom.split();
            var len:int = split.length;
            for (var c:int = 0; c < len; c++) {
                if(split[c] in _table)
                    split[c] = _table[split[c]];
            }
            _axiom = split.join("");
            _generation++;
        }
        return _axiom;
    }

    public function get axiom():String { return _axiom; }
    public function get originalAxiom():String { return _original; }
    public function get generation():int { return _generation; }

    public function setVariables(variables:Vector.<String>, substitutions:Vector.<String>):void {
        _table = new Dictionary();
        var len_v:int = variables.length,
            len_s:int = substitutions.length;
        for (var i:int = 0; i < len_v; i++) {
            if(i < len_s)
                _table[variables[i]] = substitutions[i];
        }
    }

}
}
