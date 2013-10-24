/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/18/13
 * Time: 2:21 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.base.interfaces {
public interface IAnimatable {

    function show():void;
    function hide():void;

    function advanceTime(t:Number):void;

    function animateIn(target:Object, t:Number, parameters:Object):void;
    function animateOut(target:Object, t:Number, parameters:Object):void;

}
}
