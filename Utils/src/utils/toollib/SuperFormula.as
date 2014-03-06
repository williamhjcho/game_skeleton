/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/26/13
 * Time: 9:40 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib {
public final class SuperFormula {

    public var x:Number = 0, y:Number = 0, radius:Number = 100;
    public var a:Number, b:Number, m:Number, n1:Number, n2:Number, n3:Number;

    public function SuperFormula(x:Number, y:Number, radius:Number, a:Number = 19, b:Number = 19, m:Number = 9, n1:Number = 14, n2:Number = 11, n3:Number = 11) {
        this.radius = radius;
        setCenter(x,y);
        setVariables(a,b,m,n1,n2,n3);
    }

    public function setCenter(x:Number, y:Number):void {
        this.x = x;
        this.y = y;
    }

    public function setVariables(a:Number = 19, b:Number = 19, m:Number = 9, n1:Number = 14, n2:Number = 11, n3:Number = 11):SuperFormula {
        this.a    = a;
        this.b    = b;
        this.m    = m;
        this.n1   = n1;
        this.n2   = n2;
        this.n3   = n3;
        return this;
    }

    public function getCoordinates(rad:Number, output:Object):void {
        var rad2:Number = rad * m / 4;
        var r:Number = Math.pow(Math.pow(Math.abs(Math.cos(rad2) / a), n2) + Math.pow(Math.abs(Math.sin(rad2) / b), n3), -1/n1);
        output.x = this.x + r * Math.cos(rad2) * radius;
        output.y = this.y + r * Math.sin(rad2) * radius;
    }

}
}
