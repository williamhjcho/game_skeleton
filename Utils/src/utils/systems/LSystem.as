/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/04/13
 * Time: 13:37
 * To change this template use File | Settings | File Templates.
 */
package utils.systems {
import flash.utils.Dictionary;

public class LSystem {

    private var _axiom      :String;
    private var _variables  :Vector.<String>;  //rules for the variables  [[variable],[rule]]
    private var _references :Vector.<String>;

    private var table           :Dictionary; //dictionary[variable] = rule;
    private var _originalAxiom  :String;
    private var _generation     :int = 0;

    public function LSystem(axiom:String, variables:Vector.<String>, references:Vector.<String>) {
        this.table = new Dictionary();
        this.axiom = axiom;
        setRules(variables, references);
    }

    public function iterate():void {
        //it's iterating backwards so there is no need for the 'c' correction after the rule apply
        //ex: axiom = new axiom; c += diff_length(new axiom, axiom);
        for (var c:int = _axiom.length - 1; c >= 0; c--) {
            var ch:String = _axiom.charAt(c);
            var variableCounterPart:String = table[ch];
            if(variableCounterPart != null) { //check if ch is a variable
                //applying the rule for that variable
                _axiom = _axiom.substring(0,c) + variableCounterPart + _axiom.substring(c+1);
            }
        }
        _generation++;
    }

    public function iterateN(n:uint):void {
        for (var i:int = 0; i < n; i++) { iterate(); }
    }

    private function validate():void {
        if(_variables == null || (_axiom == null || _axiom.length == 0)) {
            throw new Error("[LSystem] Invalid L-System. Axiom and Rules CANNOT be null, and axiom must be of length > 0.");
        }
        for (var variable:String in table) {
            if(table[variable] == null || table[variable] == undefined)
                throw new Error("[LSystem] Invalid L-System. The variable \"" + variable + "\" doesn't have a rule.");
        }
    }

    //==================================
    //      Get/Set
    //==================================
    public function setRules(variables:Vector.<String>, references:Vector.<String>):void {
        if(variables == null || references == null)
            throw new ArgumentError("Variables and references cannot be null.");
        if(variables.length > references.length)
            throw new ArgumentError("References.length must be at least variables.length");

        _variables = variables;
        _references = references;

        for (var variable:String in table) {
            delete table[variable];
        }
        for (var i:int = 0; i < variables.length; i++) {
            table[variables[i]] = references[i];
        }
    }

    public function set axiom(a:String):void {
        _axiom = _originalAxiom = a;
        _generation = 0;
    }
    public function get axiom():String { return this._axiom; }
    public function get generation()    :int    { return _generation; }
    public function get tree()          :String { return _axiom; }
    public function get originalAxiom() :String { return _originalAxiom; }
    public function get alphabet():Vector.<String> {
        //List of every symbol used in this LSystem
        var alphabet:Vector.<String> = new Vector.<String>();
        var matches:String = "";
        for (var variable:String in table) {
            //replacing any 'conflicting' characters (if there is any) such as [\W] = Non-word or [\D] = Non-digit
            alphabet.push(variable);
            matches += variable.replace(/[\\W\\D]/g,"\\"+variable);
        }
        var regex:RegExp = new RegExp("["+matches+"]","g");
        for each (var rule:String in table) {
            //removing already added(so far) variables on the alphabet
            rule = rule.replace(regex, "");
            //if there is anything left, split it and add every character.
            if(rule != "") {
                for each (var r:String in rule.split("")) { alphabet.push(r); matches += r.replace(/[\\W\-\+]/g,"\\"+r); }
                regex = new RegExp("["+matches+"]","g"); //(a new regex is only created when 'matches' have changed)
            }
        }
        //same as before, but using only the ORIGINAL axiom, since the subsequent trees/axioms are all following the rules
        var o_axiom:String = _originalAxiom.replace(regex, "");
        if(o_axiom != "") {
            for each (var o:String in o_axiom.split("")) { alphabet.push(o); }
        }

        return alphabet;
    }
}
}
