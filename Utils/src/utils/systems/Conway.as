/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 5/3/13
 * Time: 11:10 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.systems {

public class Conway {

    private var _width:uint, _height:uint;
    private var currentHolder:Boolean;
    private var _generation:uint;
    private var cells0:Vector.<Vector.<uint>>;
    private var cells1:Vector.<Vector.<uint>>;

    public function Conway(width:uint, height:uint) {
        _width = width;
        _height = height;
        _generation = 0;
        currentHolder = true;

        checkCells();
    }

    private function checkCells():void {
        if(cells0 == null)  cells0 = new Vector.<Vector.<uint>>(_width);
        else                cells0.length = _width;
        if(cells1 == null)  cells1 = new Vector.<Vector.<uint>>(_width);
        else                cells1.length = _width;
        for (var i:int = 0; i < _width; i++) {
            if(cells0[i] == null)   cells0[i] = new Vector.<uint>(_height);
            else                    cells0[i].length = _height;
            if(cells1[i] == null)   cells1[i] = new Vector.<uint>(_height);
            else                    cells1[i].length = _height;
        }
    }

    public function get width():uint { return _width; }
    public function set width(v:uint):void {
        _width = v;
        checkCells();
    }

    public function get height():uint { return _height; }
    public function set height(v:uint) {
        _height = v;
        checkCells();
    }

    public function setDimenisions(width:uint, height:uint):void {
        _width = width;
        _height = height;
        checkCells();
    }

    public function get generation():int { return this._generation; }

    public function randomize():void {
        var cells:Vector.<Vector.<uint>> = (currentHolder)? cells0 : cells1;
        for (var i:int = 0; i < _width; i++) {
            for (var j:int = 0; j < _height; j++) {
                cells[i][j] = Math.round(Math.random());
            }
        }
    }

    public function iterate():void {
        //rules :
        //Any live cell with fewer than two live neighbours dies, as if caused by under-population.
        //Any live cell with two or three live neighbours lives on to the next generation.
        //Any live cell with more than three live neighbours dies, as if by overcrowding.
        //Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

        var cells:Vector.<Vector.<uint>>, next:Vector.<Vector.<uint>>;
        if(currentHolder) {
            cells = cells0;
            next = cells1;
        } else {
            cells = cells1;
            next = cells0;
        }
        currentHolder = !currentHolder;
        _generation++;

        for (var i:int = 1; i < _width - 1; i++) {
            for (var j:int = 1; j < _height - 1; j++) {
                var n:uint =
                    cells[i - 1][j - 1] + cells[i][j - 1] + cells[i + 1][j - 1] +
                    cells[i - 1][j    ] +                   cells[i + 1][j    ] +
                    cells[i - 1][j + 1] + cells[i][j + 1] + cells[i + 1][j + 1];

                if(cells[i][j] == 1) {
                    if(n == 2 || n == 3)
                        next[i][j] = 1;
                } else {
                    if(n == 3)
                        next[i][j] = 1;
                }
            }
        }
    }


}
}
