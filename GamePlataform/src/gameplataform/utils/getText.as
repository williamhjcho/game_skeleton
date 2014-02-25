/**
 * Created by William on 2/25/14.
 */
package gameplataform.utils {
import gameplataform.controller.GameData;

public function getText(id:String):String {
    return GameData.getText(id) || "[Invalid: \"" + id + "\"]";
}
}
