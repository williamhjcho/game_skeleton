/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 11/11/13
 * Time: 12:04 PM
 * To change this template use File | Settings | File Templates.
 */
package astar {
public interface IHeuristic {
    function distance(x0:int, y0:int, x1:int, y1:int):int;
}
}
