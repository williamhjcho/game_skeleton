/**
 * Created by William on 2/26/14.
 */
package astar {
import flash.geom.Point;

public class Graph {

    public function allNodes():Array { return []; }

    public function centerNode():Object { return null; }

    public function vertexGeom(v:Object):Point { return new Point(0,0); }

    public function nodeGeom(n:Object):Array {
        var results:Array = [];
        var nodes:Array = nodeVertices(n);
        for (var i:int = 0; i != nodes.length; i++) {
            results.push(vertexGeom(nodes[i]));
        }
        return results;
    }

    public function nodeCenter(n:Object):Point {
        var center:Point = new Point(0,0);
        var nodes:Array = nodeVertices(n);
        for (var i:int = 0; i != nodes.length; i++) {
            center = center.add(vertexGeom(nodes[i]));
        }
        return center;
    }

    public function nodeValid(n:Object):Boolean { return false; }

    public function nodeToString(n:Object):String { return ""; }
    public function stringToNode(s:String):Object { return null; }
    public function nodesEqual(a:Object, b:Object):Boolean { return false; }
    public function nodeVertices(n:Object):Array { return null; }
    public function nodeNeighbors(n:Object):Array  { return null; }

    public function distance(a:Object, b:Object):Number { return 0; }
    public function pointToNode(p:Point):Object  { return null; }

    public function pointToVertex(p:Point):Object { return -1; }

}
}
