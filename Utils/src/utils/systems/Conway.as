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
    private var currentHolder:uint;
    private var _generation:uint;
    private var cellHolder:Vector.<Vector.<Vector.<uint>>>;
    private var original:Vector.<Vector.<uint>>;

    public function Conway(width:uint, height:uint, initialCells:Vector.<Vector.<uint>> = null) {
        _width = width;
        _height = height;
        _generation = 0;
        currentHolder = 0;
        cellHolder = new <Vector.<Vector.<uint>>>[
            new Vector.<Vector.<uint>>(),
            new Vector.<Vector.<uint>>()
        ];

        if(initialCells == null) {
            original = new Vector.<Vector.<uint>>();
            for (var i:int = 0; i < _width; i++) {
                original[i] = new Vector.<uint>();
            }
            cells = original;
        } else {
            cells = initialCells;
        }
    }

    //==================================
    //  Methods
    //==================================
    private function checkCells():void {
        for (var i:int = 0; i < _width; i++) {
            if(cellHolder[0][i] == null)    cellHolder[0][i] = new Vector.<uint>();
            else                            cellHolder[0][i].length = _height;
            if(cellHolder[1][i] == null)    cellHolder[1][i] = new Vector.<uint>();
            else                            cellHolder[1][i].length = _height;
        }
    }

    public function randomize():void {
        for (var i:int = 0; i < _width; i++) {
            for (var j:int = 0; j < _height; j++) {
                original[i][j] = (Math.random() > 0.5)? 1 : 0;
            }
        }
        cells = original;
    }

    public function reset():void {
        _generation = 0;
        for (var i:int = 0; i < _width; i++) {
            for (var j:int = 0; j < _height; j++) {
                cellHolder[currentHolder][i][j] = original[i][j];
            }
        }
    }

    public function iterate():void {
        //rules :
        //Any live cell with fewer than two live neighbours dies, as if caused by under-population.
        //Any live cell with two or three live neighbours lives on to the next generation.
        //Any live cell with more than three live neighbours dies, as if by overcrowding.
        //Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

        var lastCells:uint = currentHolder;
        currentHolder = (currentHolder + 0x1) & 0x1;
        _generation++;

        for (var i:int = 1; i < _width - 1; i++) {
            for (var j:int = 1; j < _height - 1; j++) {
                var n:uint = cellHolder[lastCells][i - 1][j - 1] + cellHolder[lastCells][i][j - 1] + cellHolder[lastCells][i + 1][j - 1] +
                             cellHolder[lastCells][i - 1][j    ] +                                   cellHolder[lastCells][i + 1][j    ] +
                             cellHolder[lastCells][i - 1][j + 1] + cellHolder[lastCells][i][j + 1] + cellHolder[lastCells][i + 1][j + 1];

                if(cellHolder[lastCells][i][j] == 1) {
                    cellHolder[currentHolder][i][j] = (n == 2 || n == 3) ? 1 : 0;
                } else {
                    cellHolder[currentHolder][i][j] = (n == 3)? 1 : 0;
                }
            }
        }
    }

    //==================================
    //  Get/Set
    //==================================
    public function get generation():int { return this._generation; }

    public function get width():uint { return _width; }
    public function set width(v:uint):void {
        _width = v;
        checkCells();
    }

    public function get height():uint { return _height; }
    public function set height(v:uint):void {
        _height = v;
        checkCells();
    }

    public function get cells():Vector.<Vector.<uint>> { return cellHolder[currentHolder]; }
    public function set cells(v:Vector.<Vector.<uint>>):void {
        if(v == null) return;
        original = v;
        _width = v.length;
        _height = v[0].length;
        checkCells();
        for (var i:int = 1; i < _width - 1; i++) {
            for (var j:int = 1; j < _height - 1; j++) {
                cellHolder[currentHolder][i][j] = v[i][j];
            }
        }

        //borders are 0
        for (i = 0; i < _width; i++) {
            cellHolder[0][i][0]         =
            cellHolder[0][i][_height-1] =
            cellHolder[1][i][0]         =
            cellHolder[1][i][_height-1] = 0;
        }

        for (j = 0; j < _height; j++) {
            cellHolder[0][0][j]         =
            cellHolder[0][_width-1][j]  =
            cellHolder[1][0][j]         =
            cellHolder[1][_width-1][j]  = 0;
        }
    }

    public function setCell(x:int, y:int, alive:Boolean):void { cellHolder[currentHolder][x][y] = alive? 1 : 0; }
    public function isAlive(x:int, y:int):Boolean { return cellHolder[currentHolder][x][y] == 1; }

    public function setDimenisions(width:uint, height:uint):void {
        _width = width;
        _height = height;
        checkCells();
    }

    public function toString():String {
        var s:String = "";
        for each (var cc:Vector.<uint> in cellHolder[currentHolder]) {
            s += "[";
            for each (var cell:uint in cc) {
                s += cell;
            }
            s += "]\n"
        }
        return s;
    }

}
}
