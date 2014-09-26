/**
 * Created by William on 9/2/2014.
 */
package game.model.sound {
public dynamic class SoundTableElement {

    /**
     This is a DYNAMIC class
     to be populated by parameters within the corresponding JSON file
     every property will contain a ARRAY of OBJECTS
     */

    public function getProperty(id:String):SoundConfig {
        return this[id];
    }
}
}
