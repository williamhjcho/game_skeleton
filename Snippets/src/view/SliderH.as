/**
 * Created by William on 7/11/2014.
 */
package view {
import flash.display.MovieClip;

import utilsDisplay.view.slider.SliderHorizontal;

public class SliderH extends SliderHorizontal {

    public var track:MovieClip, tracker:MovieClip;
    public var btnDown:MovieClip, btnUp:MovieClip;

    public function SliderH() {
        super();

        super.setElements(track, tracker);
    }
}
}
