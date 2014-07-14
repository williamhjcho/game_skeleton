/**
 * Created by William on 7/14/2014.
 */
package view {
import flash.display.MovieClip;

import utilsDisplay.view.scroll.ScrollContainer;

public class SContainer extends ScrollContainer {

    public var container:MovieClip;

    public function SContainer() {
        super();
        super.setContainer(container);
    }
}
}
