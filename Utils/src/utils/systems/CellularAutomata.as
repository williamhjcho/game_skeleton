/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 3/27/13
 * Time: 9:00 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.systems {
public class CellularAutomata {

    private static const RULE_LENGTH:uint = 8;

    private var _length         :uint;
    private var _rule           :Vector.<uint>;
    private var cellHolder      :Vector.<Vector.<uint>>;
    private var currentHolder   :uint;
    private var _generation     :uint;
    private var original        :Vector.<uint>;

    public function CellularAutomata(length:uint, rules:Vector.<uint> = null, initialCells:Vector.<uint> = null) {
        _length = length;
        currentHolder = 0;
        _generation = 0;
        _rule = new <uint>[0,1,0,1,1,0,1,0];
        cellHolder = new <Vector.<uint>> [new Vector.<uint>(), new Vector.<uint>()];
        cellHolder[currentHolder][_length>>1] = 1;

        this.rule = rules;

        if(initialCells == null) {
            original = new Vector.<uint>();
            cells = original;
        } else {
            cells = initialCells;
        }
    }

    //==================================
    //  Methods
    //==================================
    public function randomizeRules():void {
        for (var i:int = 0; i < RULE_LENGTH; i++) {
            _rule[i] = (Math.random() > 0.5)? 1 : 0;
        }
    }

    public function randomizeCells():void {
        for (var i:int = 0; i < _length; i++) {
            original[i] = (Math.random() > 0.5)? 1 : 0;
        }
        cells = original;
    }

    public function reset():void {
        _generation = 0;
        for (var i:int = 0; i < _length; i++) {
            cellHolder[currentHolder][i] = original[i];
        }
    }

    public function iterate():void {
        var lastCells:uint = currentHolder;
        currentHolder = (currentHolder + 0x1) & 0x1;
        _generation++;
        for (var c:int = 1; c < _length-1; c++) {
            cellHolder[currentHolder][c] = _rule[(cellHolder[lastCells][c-1] << 2) | (cellHolder[lastCells][c] << 1) | (cellHolder[lastCells][c+1])];
        }
    }

    //==================================
    //  Get/Set
    //==================================
    public function get cells():Vector.<uint> { return cellHolder[currentHolder]; }
    public function set cells(v:Vector.<uint>):void {
        if(v == null) return;
        original = v;
        _length = v.length;
        cellHolder[0].length = cellHolder[1].length = _length;
        for (var i:int = 0; i < _length; i++) {
            cellHolder[currentHolder][i] = v[i];
        }
    }

    public function get rule():Vector.<uint> { return _rule; }
    public function set rule(rules:Vector.<uint>):void {
        if(rules == null || rules.length == 0) return;
        var min:int = Math.min(rules.length, RULE_LENGTH);
        var i:int;
        for (i = 0; i < min; i++) {
            _rule[i] = rules[i];
        }
        for (; i < _rule.length; i++) {
            _rule[i] = 0;
        }
    }

    public function set ruleDecimal(v:int):void {
        for (var i:int = RULE_LENGTH - 1; i >= 0; i--) {
            _rule[i] = v & 1;
            v >>= 1;
        }
    }
    public function get ruleDecimal():int {
        var dec:uint = 0, shift:uint = 0;
        for (var i:int = RULE_LENGTH - 1; i >= 0; i--) {
            dec |= _rule[i] << shift++;
        }
        return dec;
    }

    public function get generation():uint { return _generation; }
    public function get length():uint { return _length; }
    public function set length(n:uint):void {
        _length = n;
        cellHolder[0].length = cellHolder[1].length = _length;
    }

    public function setCell(position:int, alive:Boolean):void { cellHolder[currentHolder][position] = alive? 1 : 0; }
    public function isAlive(position:int):Boolean { return cellHolder[currentHolder][position] == 1; }

    public function toString():String {
        return "Cellular Automata: rule(" + ruleDecimal.toString() + "):[" + _rule.toString() + "], cells: [" + cellHolder[currentHolder].toString() + "]";
    }


}
}
