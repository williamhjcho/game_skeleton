/**
 * Created by William on 2/26/14.
 */
package testing {
import flash.display.Graphics;
import flash.display.Sprite;

import utils.toollib.color.Colors;

import utilsDisplay.managers.buttons.ButtonManager;

public class ButtonTest extends Sprite {

    private var g:Graphics;

    public function ButtonTest() {
        super();

        this.g = this.graphics;
        drawAs(Colors.GREEN);

        ButtonManager.add(this, {
            enable      : true,
            onDown      : onDown   ,
            onUp        : onUp     ,
            onOver      : onOver   ,
            onOut       : onOut    ,
            onEnable    : onEnable ,
            onDisable   : onDisable
        });
    }

    private function onDown     (btn:ButtonTest):void { drawAs(Colors.AQUA); }
    private function onUp       (btn:ButtonTest):void { drawAs(Colors.GREEN); }
    private function onOver     (btn:ButtonTest):void { drawAs(Colors.LIME); }
    private function onOut      (btn:ButtonTest):void { drawAs(Colors.GREEN); }
    private function onEnable   (btn:ButtonTest):void { drawAs(Colors.GREEN); }
    private function onDisable  (btn:ButtonTest):void { drawAs(Colors.BLACK); }

    private function drawAs(color:uint):void {
        g.clear();
        g.lineStyle(3, color);
        g.beginFill(color, 0.70);
        g.drawRect(0,0,100,50);
    }

}
}
