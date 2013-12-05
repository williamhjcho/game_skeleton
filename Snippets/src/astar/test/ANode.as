/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 11/25/13
 * Time: 9:05 AM
 * To change this template use File | Settings | File Templates.
 */
package astar.test {
import astar.INode;

public class ANode implements INode {

    public function ANode() {
        super();
    }


    public function get isTransversable():Boolean {
        return false;
    }

    public function get g():Number {
        return 0;
    }

    public function set g(v:Number):void {
    }

    public function get h():Number {
        return 0;
    }

    public function set h(v:Number):void {
    }

    public function set parent(node:INode):void {
    }

    public function get x():int {
        return 0;
    }

    public function set x(v:int):void {
    }

    public function get y():int {
        return 0;
    }

    public function set y(v:int):void {
    }

    public function get parent():INode {
        return null;
    }
}
}
