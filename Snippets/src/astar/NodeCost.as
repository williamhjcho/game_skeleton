/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 11/11/13
 * Time: 1:58 PM
 * To change this template use File | Settings | File Templates.
 */
package astar {
public class NodeCost {

    private var G:int = 0, H:int = 0;

    public function NodeCost(costFromStartNode:int = 0, costToTargetNode:int = 0) {
        this.G = costFromStartNode;
        this.H = costToTargetNode;
    }

    public function get total():int { return G + H; }

    public function get costFromStart():int { return G; }
    public function set costFromStart(v:int):void { G = v; }

    public function get costToTarget():int { return H; }
    public function set costToTarget(v:int):void { H = v; }

}
}
