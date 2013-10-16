/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.display.Sprite;
import flash.utils.getTimer;

import utils.commands.getClass;
import utils.toollib.Matrix;

public class Main extends Sprite {

    public function Main() {
        var matrix:Matrix = new Matrix(4,4);
        matrix.setRow(0, ["a", "b", "c", "d"]);
        matrix.setRow(1, ["e", "f", "g", "h"]);
        matrix.setRow(2, ["i", "j", "k", "l"]);
        matrix.setRow(3, ["m", "n", "o", "p"]);
        trace(matrix);

        //trace(matrix.rotateClockWise());
        trace(matrix.rotateCounterClockWise());
    }
}
}
