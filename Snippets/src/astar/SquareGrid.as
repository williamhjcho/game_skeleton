/**
 * Created by William on 2/26/14.
 */
package astar {
import flash.geom.Point;

public class SquareGrid extends Graph {

    public var size     :int;
    public var width    :int;
    public var height   :int;

    public function SquareGrid(width:int, height:int, size:int) {
        super();
        this.size   = size  ;
        this.width  = width ;
        this.height = height;
    }

    override public function allNodes():Array {
        var result:Array = [];
        for (var i:int = 0; i < width; i++) {
            for (var j:int = 0; j < height; j++) {
                result.push({x:i, y:j});
            }
        }
        return result;
    }

    override public function centerNode():Object {
        return { x: width >> 1, y: height >> 1 };
    }

    override public function nodeToString(n:Object):String {
        return "{x:"+ n.x + ', y:' + n.y + "}";
    }

    override public function stringToNode(s:String):Object {
        var fields:Array = s.replace(/([xX] *:\d+)|([yY] *:\d+)/, "$1,$2").split(",", 2);
        return {x:fields[0], y:fields[1]};
    }

    override public function nodesEqual(a:Object, b:Object):Boolean {
        return (a.x == b.x) && (a.y == b.y);
    }

    override public function nodeVertices(n:Object):Array {
        return [
            {x: n.x, y: n.y},
            {x: n.x + 1, y: n.y},
            {x: n.x + 1, y: n.y + 1},
            {x: n.x, y: n.y + 1}
        ];
    }

    override public function vertexGeom(n:Object):Point {
        return new Point(n.x * size, n.y * size);
    }

    override public function nodeValid(n:Object):Boolean {
        return (n.x >= 0 && n.x < width && n.y >= 0 && n.y < height);
    }

    override public function pointToNode(p:Point):Object {
        var x:Number = p.x / size;
        var y:Number = p.y / size;
        if(nodeValid({x: x, y: y})) {
            return {x: Math.floor(x), y: Math.floor(y)};
        } else {
            return null;
        }
    }

    override public function nodeNeighbors(n:Object):Array {
        var r:Array = [{ u: n.x + 1, v: n.y },
                { u: n.x, v: n.y + 1 },
                { u: n.x - 1, v: n.y },
                { u: n.x, v: n.y - 1 }];
        var result:Array = [];
        for (var i:int = 0; i != r.length; i++) {
            if (nodeValid(r[i])) {
                result.push(r[i]);
            }
        }
        return result;
    }

    override public function distance(a:Object, b:Object):Number {
        return Math.abs(a.x - b.x) + Math.abs(a.y - b.y);
    }
}
}
