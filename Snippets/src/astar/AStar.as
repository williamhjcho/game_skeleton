/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 11/11/13
 * Time: 12:04 PM
 * To change this template use File | Settings | File Templates.
 */
package astar {
import flash.utils.Dictionary;

public class AStar {

    private var map         :IMap;
    private var heuristic   :IHeuristic;
    private var costs:Dictionary = new Dictionary();

    public function AStar(map:IMap, heuristic:IHeuristic) {
        this.map = map;
        this.heuristic = heuristic;
    }

    public function findPath(start:INode, end:INode):Vector.<INode> {
        var openList:Vector.<INode> = new Vector.<INode>(), closedList:Vector.<INode> = new Vector.<INode>();
        var path:Vector.<INode> = new Vector.<INode>();
        var current:INode, neighbor:INode;
        var cost:Number = 1;
        var connected:Vector.<INode>;
        var g:Number, h:Number, f:Number;
        start.g = 0;

        if(!end.isTransversable) {
            return null;
        }

        while(openList.length != 0) {
            current = openList[0];

            if(current == end) {
                //found, return
            }

            openList.unshift();
            closedList.push(current);

            for each (neighbor in map.getNeighborsOf(current)) {
                if(closedList.indexOf(neighbor) != -1 || !neighbor.isTransversable) {
                    continue;
                }
            }
        }

        return null;
    }

    public function calculate(x0:int, y0:int, x1:int, y1:int):Vector.<INode> {
        var openList    :Vector.<INode> = new Vector.<INode>();
        var closedList  :Vector.<INode> = new Vector.<INode>();
        var path        :Vector.<INode> = new Vector.<INode>();
        var distance:Number = 0;

        var start:INode = map.getNode(x0, y0), end:INode = map.getNode(x1, y1);

        if(end.isTransversable) {
            return null;
        }

        while(openList.length != 0) {
            var current:INode = openList[0];

            //found the node
            if(current.x == x1 && current.y == y1) {
                //return path
            }

            openList.unshift();
            closedList.push(current);

            costs[current] ||= new NodeCost();
            var cost:NodeCost = costs[current];
            cost.costFromStart = heuristic.distance(start.x, start.y, current.x, current.y);
            cost.costToTarget = heuristic.distance(current.x, current.y, end.x, end.y);

            for each (var neighbor:INode in map.getNeighborsOf(current)) {
                if(closedList.indexOf(neighbor) != -1 || neighbor.isTransversable) {
                    continue;
                }

                costs[neighbor] ||= new NodeCost();
                var nCost:NodeCost = costs[current];
                nCost.costFromStart = heuristic.distance(start.x, start.y, current.x, current.y);
                nCost.costToTarget = heuristic.distance(current.x, current.y, end.x, end.y);

                if(openList.indexOf(neighbor) == -1) {
                    openList.push(neighbor);
                } else if(nCost.total < cost.costFromStart) {

                } else {

                }
            }
        }

        return null;
    }
}
}
