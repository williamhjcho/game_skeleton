/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/23/13
 * Time: 1:20 PM
 * To change this template use File | Settings | File Templates.
 */
package scrl {
import flash.geom.Rectangle;

public class ScrollParams {

    public var contentArea  :Rectangle;

    public var orientation  :String = ScrollOrientation.AUTO;

    public var time         :Number = 0.5;      //animation time
    public var wheelSpeed   :Number = 5;        //pixels

    public var vertical     :ComponentParams = new ComponentParams();
    public var horizontal   :ComponentParams = new ComponentParams();


}
}
