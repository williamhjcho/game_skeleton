/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 11:15 AM
 * To change this template use File | Settings | File Templates.
 */
package starling {
import starling.core.State;

import org.osflash.signals.Signal;

import starling.display.MovieClip;

public class ALevel extends State {

    public var lvlEnded:Signal;
    public var restartLevel:Signal;
    protected var _level:MovieClip;

    public function ALevel(level:MovieClip = null) {
        super();

        _level = level;
        lvlEnded = new Signal();
        restartLevel = new Signal();




    }

    override public function initialize():void {
        super.initialize();

    }
}
}
