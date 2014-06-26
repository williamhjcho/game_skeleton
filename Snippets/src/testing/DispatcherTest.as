/**
 * Created by William on 6/26/2014.
 */
package testing {
import flash.utils.setTimeout;

import utils.events.SignalDispatcher;

public class DispatcherTest extends SignalDispatcher {

    public function DispatcherTest() {
        setTimeout(disp, 3000);
    }

    private function disp():void {
        super.dispatchSignalWith("wut", {name:"wat"});
    }
}
}
