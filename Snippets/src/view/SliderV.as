/**
 * Created by William on 7/11/2014.
 */
package view {
import flash.display.MovieClip;

import utilsDisplay.view.slider.SliderVertical;

public class SliderV extends SliderVertical {

    public var track:MovieClip, tracker:MovieClip;

    public function SliderV() {
        super();

        super.setElements(track, tracker);
    }


}
}
