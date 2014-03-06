/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 11/25/13
 * Time: 9:04 AM
 * To change this template use File | Settings | File Templates.
 */
package astar.test {
import astar.IMap;
import astar.INode;

import flash.display.Sprite;

public class AMap extends Sprite implements IMap {



    public function AMap() {
        super();
    }


    public function getNode(x:int, y:int):INode {
        return null;
    }

    public function getDistanceBetween(a:INode, b:INode):int {
        return 0;
    }

    public function getNeighborsOf(node:INode):Vector.<INode> {
        return null;
    }
}
}
