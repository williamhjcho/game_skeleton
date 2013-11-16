/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 11/11/13
 * Time: 1:34 PM
 * To change this template use File | Settings | File Templates.
 */
package astar {
public interface IMap {

    function getNode(x:int, y:int):INode;
    function getDistanceBetween(a:INode, b:INode):int;
    function getNeighborsOf(node:INode):Vector.<INode>;
}
}
