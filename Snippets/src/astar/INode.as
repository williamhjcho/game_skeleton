/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 11/11/13
 * Time: 12:21 PM
 * To change this template use File | Settings | File Templates.
 */
package astar {
public interface INode {

    function get x():int;
    function set x(v:int):void;

    function get y():int;
    function set y(v:int):void;

    function get isTransversable():Boolean;

    function get g():Number;
    function set g(v:Number):void;
    function get h():Number;
    function set h(v:Number):void;

    function get parent():INode;
    function set parent(node:INode):void;

}
}
