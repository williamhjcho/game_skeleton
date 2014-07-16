/**
 * Created by William on 7/15/2014.
 */
package utilsDisplay.base.I {
public interface IButton {
    function onClick  (button:IButton):void;
    function onOver   (button:IButton):void;
    function onOut    (button:IButton):void;
    function onDown   (button:IButton):void;
    function onUp     (button:IButton):void;
    function onRemove (button:IButton):void;
    function onEnable (button:IButton):void;
    function onDisable(button:IButton):void;
}
}
