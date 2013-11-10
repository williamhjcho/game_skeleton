/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 3/27/13
 * Time: 9:00 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.systems {
public class CellularAutomata {

    private var _cellLength     :uint;
    private var _rules          :Vector.<uint>;
    private var cells0          :Vector.<uint>;
    private var cells1          :Vector.<uint>;

    private var _currentCells   :Boolean;
    private var _generation     :uint;

    public function CellularAutomata(cellLength:uint, rules:Vector.<uint> = null, initialCells:Vector.<uint> = null) {
        _cellLength = cellLength;
        _currentCells = true;
        _generation = 0;
        _rules = new <uint>[0,1,0,1,1,0,1,0];
        cells0 = new Vector.<uint>(_cellLength);
        cells1 = new Vector.<uint>(_cellLength);
        if(rules != null) setRules(rules);
        if(initialCells != null) setCells(initialCells);
    }

    public function iterate():void {
        var cells:Vector.<uint>, nextCells:Vector.<uint>;
        if(_currentCells) {
            cells = cells0;
            nextCells = cells1;
        } else {
            cells = cells1;
            nextCells = cells0;
        }
        _currentCells = !_currentCells;
        _generation++;
        for (var c:int = 1; c < cells.length - 1; c++) {
            nextCells[c] = _rules[cells[c-1] << 2 | cells[c] << 1 | cells[c+1]];
        }
    }

    public function setCells(cells:Vector.<uint>):void {
        _cellLength = cells.length;
        cells0.length = cells1.length = _cellLength;
        var current:Vector.<uint> = (_currentCells)? cells0 : cells1;
        for (var i:int = 0; i < _cellLength; i++) {
            current[i] = cells[i];
        }
    }

    public function getCells(output:Vector.<uint>):Vector.<uint> {
        var current:Vector.<uint> = (_currentCells)? cells0 : cells1;
        output ||= new Vector.<uint>(_cellLength);
        for (var c:int = 0; c < _cellLength; c++) {
            output[c] = current[c];
        }
        return output;
    }

    public function setRules(rules:Vector.<uint>):void {
        var min:int = Math.min(rules.length, _rules.length);
        var i:int;
        for (i = 0; i < min; i++) {
            _rules[i] = rules[i];
        }
        for (; i < _rules.length; i++) {
            _rules[i] = 0;
        }
    }

    public function getRules(output:Vector.<uint>):Vector.<uint> {
        output ||= new Vector.<uint>(_rules.length);
        for (var i:int = 0; i < _rules.length; i++) {
            output[i] = _rules[i];
        }
        return output;
    }

    public function get generation():uint { return _generation; }

    public function get cellLength():uint { return _cellLength; }

    public function set cellLength(n:uint):void {
        _cellLength = n;
        cells0.length = cells1.length = _cellLength;
    }
}
}
