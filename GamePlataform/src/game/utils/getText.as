/**
 * Created by William on 2/25/14.
 */
package game.utils {
import game.controller.data.TextController;

public function getText(id:String):String {
    return TextController.getText(id) || "[Invalid: \"" + id + "\"]";
}
}
