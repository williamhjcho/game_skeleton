/**
 * Created by William on 7/21/2014.
 */
package graph {
import utils.list.PriorityQueue;
import utils.list.PriorityQueueDict;

public class AStar {

    private var _graph:IGraph;
    public var history:Vector.<Object>;
    public var start:int = -1, end:int = -1;
    public var path:Vector.<int> = new Vector.<int>();
    public var cost_so_far:Object = {};
    public var came_from:Object = {};
    public var priorities:Object = {};
    public var distances:Object = {};

    public function AStar(graph:IGraph) {
        this._graph = graph;
    }

    public function find(start:int, end:int):Vector.<int> {
        //*
        var queue:PriorityQueue = new PriorityQueue();
        /*/
        var queue:PriorityQueueDict = new PriorityQueueDict();
        //*/
        queue.put(start, 0);
        came_from = {};
        came_from[start] = null;
        cost_so_far = {};
        cost_so_far[start] = 0;
        priorities = {};
        priorities[start] = 0;
        distances = {};
        distances[start] = 0;
        history = new Vector.<Object>();
        path = new Vector.<int>();

        var found:Boolean = false;

        while(!queue.isEmpty) {
            var current:int = queue.get();
            var neighbors:Vector.<int> = _graph.getNeighbors(current);

            if(current == end) {  trace("found")
                found = true;
                break;
            }

            for each (var neighbor:int in neighbors) {
                var new_cost:int = cost_so_far[current] + _graph.getCost(current, neighbor);
                if(!(neighbor in cost_so_far) || (new_cost < cost_so_far[neighbor])) {
                    cost_so_far[neighbor] = new_cost;
                    var distance:Number = _graph.getDistance(end, neighbor);
                    var priority:Number = new_cost + distance;
                    queue.put(neighbor, priority);
                    came_from[neighbor] = current;

                    priorities[neighbor] = priority;
                    distances[neighbor] = distance;
                }
            }

            trace(current, queue.toString());

            //_history.push({
            //    current     : current,
            //    frontier    : frontier.toString(),
            //    neighbors   : neighbors,
            //    cost        : cost_so_far[current]
            //});
        }

        //reconstructing path
        if(found) {
            current = end;
            path.push(current);
            while(current != start) {
                current = came_from[current];
                path.push(current);
            }
        }
        return path;
    }


    public function get graph():IGraph {
        return _graph;
    }

}
}
