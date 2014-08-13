/**
 * Created by William on 7/21/2014.
 */
package utils.graph {
import utils.list.PriorityQueue;

public class AStar {

    private var _graph:IGraph;
    private var _start:int = -1, _end:int = -1;
    private var path:Vector.<int>;
    private var cost_so_far  :Object = {};
    private var came_from    :Object = {};
    private var priorities   :Object = {};
    private var distances    :Object = {};

    public function AStar(graph:IGraph) {
        this._graph = graph;
        this.path = new Vector.<int>();
    }

    public function find(start:int, end:int):Vector.<int> {
        //*
        var queue:PriorityQueue = new PriorityQueue();
        /*/
        var queue:PriorityQueueDict = new PriorityQueueDict();
        //*/
        queue.put(start, 0);
        _start = start;
        _end = end;
        came_from = {};
        came_from[start] = null;
        cost_so_far = {};
        cost_so_far[start] = 0;
        priorities = {};
        priorities[start] = 0;
        distances = {};
        distances[start] = 0;
        path = new Vector.<int>();

        var found:Boolean = false;

        while(!queue.isEmpty) {
            var current:int = queue.get();
            var neighbors:Vector.<int> = _graph.getNeighbors(current);

            if(current == end) {
                found = true;
                break;
            }

            for each (var neighbor:int in neighbors) {
                var new_cost:Number = cost_so_far[current] + _graph.getCost(current, neighbor);
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


    public function get graph():IGraph { return _graph; }
    public function get currentPath():Vector.<int> { return path; }
    public function get start():int { return _start; }
    public function get end():int { return _end; }

}
}
