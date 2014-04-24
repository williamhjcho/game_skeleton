/**
 * Created by William on 4/24/2014.
 */
package gameplataform.view.base {
import utils.managers.event.MultipleSignal;

public class BaseMovieClipDispatcher extends BaseMovieClip {

    public var dispatcher:MultipleSignal;

    public function BaseMovieClipDispatcher() {
        super();
        this.dispatcher = new MultipleSignal(this);
    }
}
}
