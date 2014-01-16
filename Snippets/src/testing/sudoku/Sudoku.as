/**
 * Created by William on 1/14/14.
 */
package testing.sudoku {
import flash.display.Sprite;

public class Sudoku extends Sprite {

    private static const SIZE:uint = 3;

    private var blocks:Vector.<SBlock>;

    public function Sudoku() {
        super();

        blocks = new Vector.<SBlock>();
        blocks.length = SIZE * SIZE;
        blocks.fixed = true;
        for (var i:int = 0; i < SIZE * SIZE; i++) {
            blocks[i] = new SBlock(3);
            blocks[i].x = (i%3) * (blocks[i].width + 3);
            blocks[i].y = int(i/3) * (blocks[i].height + 3);
            addChild(blocks[i]);
        }
    }

    public function get isSolved():Boolean {
        for each (var block:SBlock in blocks) {
            if(!block.isComplete)
                return false;
        }

        for (var i:int = 0; i < SIZE; i++) {
            //checking only diagonal blocks
            block = blocks[i * (SIZE + 1)];

            for (var j:int = 0; j < block.length; j++) {
                var digit:uint = block.getDigitAt(j);
                var line:uint = j % SIZE;
                var column:uint = j / SIZE;

                for (var k:int = 0; k < SIZE; k++) {
                    //same block
                    if(k == i)
                        continue;

                    //horizontal || vertical
                    if(blocks[line * SIZE + k].hasDigitInLine(digit, line) || blocks[column + SIZE * k].hasDigitInColumn(digit, column))
                        return false;
                }
            }
        }

        return true;
    }

    public function stringfy():String {
        var s:String = "";



        return s;
    }
}
}
