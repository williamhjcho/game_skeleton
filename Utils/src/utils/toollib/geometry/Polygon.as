/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 08/03/13
 * Time: 16:38
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.geometry {
import utils.toollib.vector.v2d;

public class Polygon {

    protected var vertices:Vector.<v2d>;

    public function Polygon(numberOfVertices:int) {
        vertices = new Vector.<v2d>(numberOfVertices);
    }

    public function setVertices(...vertices):Polygon {
        var l:int = Math.min(this.vertices.length, vertices.length);
        for (var i:int = 0; i < l; i++) {
            this.vertices[i].x = vertices[i].x;
            this.vertices[i].y = vertices[i].y;
        }
        return this;
    }

    public function getVertex(idx:int):v2d { return vertices[idx]; }
    public function setVertex(idx:int, obj:Object):Polygon {
        vertices[idx].setTo(obj.x, obj.y);
        return this;
    }
    public function setVertexAs(idx:int, x:Number, y:Number):Polygon {
        vertices[idx].setTo(x,y);
        return this;
    }

    public function get numberOfVertices()  :Number { return vertices.length;    }
    public function get numberOfDiagonals() :int { return vertices.length * (vertices.length - 3) / 2;  }


    public function get area():Number {
        /*
        |v1.x v2.x v3.x ... vn.x|  * (1/2)
        |v1.y v2.y v3.y ... vn.y|
        */
        var area:Number = 0;
        for (var i:int = 0; i < vertices.length - 1; i++) {
            var v0:v2d = vertices[i];
            var v1:v2d = vertices[i+1];
            area += (v0.x * v1.y) - (v0.y * v1.x);
        }
        return area/2;
    }

    public function get centroid():v2d {
        var c:v2d = new v2d(0,0);
        for (var i:int = 0; i < vertices.length - 1; i++) {
            var v0:v2d = vertices[i];
            var v1:v2d = vertices[i+1];
            var t:Number = v0.x*v1.y - v1.x*v0.y;
            c.addXY((v0.x + v1.x) * t, (v0.y + v1.y) * t);
        }
        return c.multiply(1/(6*area));
    }

    public function getSide(idx:int,idx2:int):Number {
        return vertices[idx].distanceTo(vertices[idx2]);
    }

    public function getAngle(idx:int):Number {
        var v0:v2d = vertices[(idx <= 0)? vertices.length-1 : idx-1];
        var v1:v2d = vertices[idx];
        var v2:v2d = vertices[(idx >= vertices.length-1)? 0 : idx+1];
        var x01:Number = v1.x - v0.x, y01:Number = v1.y - v0.y;
        var x12:Number = v2.x - v1.x, y12:Number = v2.y - v1.y;
        var dot:Number = x01 * x12 + y01 * y12;
        var l01:Number = Math.sqrt(x01*x01 + y01*y01);
        var l12:Number = Math.sqrt(x12*x12 + y12*y12);
        return Math.acos(dot / (l01 * l12));
    }

    public function get perimeter():Number {
        var p:Number = 0;
        for (var i:int = 0; i < vertices.length; i++) {
            p += getSide(i, i+1);
        }
        return p + getSide(vertices.length-1,0);
    }

    public function get internalAnglesSum():Number { return Math.PI * (vertices.length - 2);       }
}
}
