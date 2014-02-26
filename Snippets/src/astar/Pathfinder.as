/**
 * Created by William on 2/26/14.
 */
package astar {
// This class implements A* and related algorithms.  A* works by
// using two estimates from each point: the cost from the start to
// the point (g) and the cost from the point to the goal (h).  As
// we explore we calculate the g values and reach the best
// (lowest) cost from the start to any point. If the heuristic is
// "monotone" then the first time we reach a node we will have
// reached it via the shortest path, so g will be optimal.  If the
// heuristic is "admissible" (and all monotone heuristics are
// admissible) then h will never be greater than the actual cost
// to the goal.  In A*, f is the sum of g and h.  We define OPEN
// to be a "frontier" set of nodes we haven't completely examined
// yet and CLOSED to be a set of nodes that we've already seen.
// In this implementation we have VISITED, the union of OPEN and
// CLOSED, and we also store OPEN, but we do not keep track of
// CLOSED separately.  We repeatedly examine the most promising
// candidate from OPEN (the one with the lowest f score) and put
// in its neighbors.  With a monotone heuristic, f never
// decreases, so all the f values in the OPEN set are in a narrow
// range; OPEN can be thought of as a contour of f values, where
// OPEN is always expanding as the f values are increasing.  When
// h exactly matches the cost of reaching the goal, A* follows
// only that path and no others.
public class Pathfinder {
    public var graph:Graph;
    public var start:Object;
    public var goal:Object;

    public var heuristic:Function;

    // A function that takes two adjacent nodes and returns the
    // cost of traversing from one to the other. This function
    // does not have to be symmetric. Return Infinity if the
    // traversal is impossible.
    public var cost:Function;

    // Alpha can be between 0 (BFS) and 1 (Dijkstra's), with 0.5 being A*
    public var alpha:Number = 0.4999;

    // The VISITED set stores visited information about each node:
    // open, closed, parent, g, h, f. VISITED is the union of
    // CLOSED and OPEN.  We use a hash table (object) to represent
    // this set. The hash key is graph.nodeToString().  The parent
    // pointer inside VISITED points to the next object with
    // visited information (not to the node coordinates); this
    // makes it easy to reconstruct the path.
    public var visited:Object = { };

    // The OPEN set stores the subset of objects in 'visited'
    // that are currently open; we use an unsorted list.
    public var open:Array = [];

    // The path array stores the final path, once it's found
    public var path:Array = null;

    public function Pathfinder(graph:Graph, start:Object, goal:Object, heuristic:Function, cost:Function) {
        this.graph = graph;
        this.start = start;
        this.goal = goal;
        this.heuristic = heuristic;
        this.cost = cost;

        initialize(start);
    }

    public function initialize(start:Object):void {
        // Initialize the VISITED set and OPEN set by inserting
        // the start point
        var initialVisited:Object = {
            node: start,
            open: 1,
            closed: 0,
            parent: null,
            g: 0,
            h: heuristic(start, goal),
            f: NaN
        };
        initialVisited.f = (alpha*initialVisited.g + (1-alpha)*initialVisited.h) / Math.max(alpha, 1-alpha);

        visited[graph.nodeToString(start)] = initialVisited;
        open.push(initialVisited);
    }

    public function findPath():Boolean {
        while (open.length > 0) {
            // Find the best node (lowest f). After sorting it
            // will be the last element in the array, and we
            // remove it from OPEN and also update its open flag.
            open = open.sortOn('f', Array.DESCENDING | Array.NUMERIC);

            var best:Object = open.pop();
            best.open = 0;

            // If we find the goal, we're done.
            if (graph.nodesEqual(goal, best.node)) {
                reconstructPath();
                return true;
            }

            // Add the neighbors of this node to OPEN
            var next:Object = graph.nodeNeighbors(best.node);
            for (var j:int = 0; j != next.length; j++) {
                var c:Number = cost(best.node, next[j]);
                if (!isFinite(c)) continue; // cannot pass

                // Every node needs to be in VISITED; be sure it's there.
                var e:Object = visited[graph.nodeToString(next[j])];
                if (e != null) {
                    e = {
                        node: next[j],
                        open: 0,
                        closed: 0,
                        parent: null,
                        g: Infinity,
                        h: 0,
                        f: 0
                    };
                    visited[graph.nodeToString(next[j])] = e;
                }

                // We'll consider this node if the new cost (g) is
                // better than the old cost. The old cost starts
                // at Infinity, so it's always better the first
                // time we see this node.
                if (best.g + c < e.g) {
                    if (!e.open) {
                        e.open = 1;
                        open.push(e);
                    }
                    e.g = best.g + c;
                    e.h = heuristic(e.node, goal);
                    e.f = (alpha*e.g + (1-alpha)*e.h)/Math.max(alpha, 1-alpha);
                    e.parent = best;
                }
            }
        }

        return false;
    }

    // Reconstruct the path from the goal back to the start
    public function reconstructPath():void {
        path = [];
        var pathVisited:Object = visited[graph.nodeToString(goal)];
        while (pathVisited && pathVisited.node != start) {
            path.push(pathVisited.node);
            pathVisited = pathVisited.parent;
        }
        path.push(start);
    }
}
}
