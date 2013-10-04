/**
 * Created with IntelliJ IDEA.
 * User: william.cho
 * Date: 20/08/13
 * Time: 15:35
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.view.console {
import flash.utils.Dictionary;

public class CommandExec {

    private var history:Dictionary = new Dictionary();
    private var _commands:Dictionary = new Dictionary();

    public function CommandExec() {
    }

    public function load(commands:Array, overwrite:Boolean = true):void {
        for each (var comm:Object in commands) {
            _commands[comm.line] = comm;
        }
    }

    public function execute(line:String):void {
        //find command
        //find targets
        //find parameters
        //execute

        var command:String = line.replace(/\s.*/, "");
    }


}
}
