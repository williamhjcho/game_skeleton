/**
 * Created by William on 4/17/2014.
 */
package drawing {
import utils.toollib.vector.v2d;

public class Class1 {

    public var num1:uint;
    public var num2:int;
    public var num3:Number;

    public var str:String;

    public var v:v2d;

    public var vec1:Vector.<int>;
    public var vec2:Vector.<Vector.<int>>;
    public var vec3:Array;
    public var vec4:Vector.<ClassB>;

    public var c1:Object;
    public var c2:Class2;

    public function Class1() {
    }

    public static function getInstance():Class1 {
        var c:Class1 = new Class1();
        c.num1 = 1;
        c.num2 = 2;
        c.num3 = -3;
        c.str = "testing string";
        c.v = new v2d(-1.25,8);
        c.vec1 = new <int>[20,40,60,80];
        c.vec2 = new <Vector.<int>>[new <int>[0,0,0,0], new <int>[1,1,1,1], new <int>[2,2,2,2]];
        c.vec3 = ["wa","da","fu"];
        c.vec4 = new <ClassB>[new Class2(), new Class2()];
        c.c1 = {wub:"wub"};
        c.c2 = new Class2();
        return c;
    }
}
}
