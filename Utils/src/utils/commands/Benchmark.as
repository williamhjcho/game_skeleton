/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/18/13
 * Time: 10:22 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.commands {
import flash.utils.getTimer;

public function Benchmark(n:int, f:Function, ...args):int {
    var t:int = getTimer();
    for (var i:int = 0; i < n; i++) {
        f.apply(this, args);
    }
    return getTimer() - t;
}
}
