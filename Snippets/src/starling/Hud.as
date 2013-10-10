
/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 2:57 PM
 * To change this template use File | Settings | File Templates.
 */
package starling {
import feathers.controls.Button;
import feathers.controls.Callout;
import feathers.controls.Label;

import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.texts.Fonts;
import starling.themes.MetalWorksMobileTheme;
import starling.utils.HAlign;
import starling.utils.VAlign;

public class Hud extends Sprite {

    private var button:Button;

    private var txtField:TextField;

    public function Hud() {
    }

    public function initialize():void {
        new MetalWorksMobileTheme();

        button = new Button();
        button.label = "Testing";
        button.setSize(100,50);
        button.validate();
        button.x = 100;
        button.y = 100;
        addChild(button);

        //txtField = new TextField(300,200,"Simple Text Example", "Verdana", 12, 0xf0ff00, false);
        txtField = new TextField(300,200,"Simple Text Example", Fonts.Kashuan_Script.fontName, 12, 0xf0ff00, false);
        txtField.x = 100;
        txtField.border = true;
        txtField.autoSize = TextFieldAutoSize.NONE;
        txtField.vAlign = VAlign.TOP;
        txtField.hAlign = HAlign.LEFT;
        addChild(txtField);

        button.addEventListener(TouchEvent.TOUCH     , buttonInteracted);
    }


    private function buttonInteracted(e:TouchEvent):void {
        const label:Label = new Label();
        var touch:Touch;
        touch = e.getTouch(button, TouchPhase.BEGAN);       if(touch) { label.text = "BEGAN";      }
        touch = e.getTouch(button, TouchPhase.MOVED);       if(touch) { label.text = "MOVED";      }
        touch = e.getTouch(button, TouchPhase.ENDED);       if(touch) { label.text = "ENDED";      }
        touch = e.getTouch(button, TouchPhase.STATIONARY);  if(touch) { label.text = "STATIONARY"; }
        touch = e.getTouch(button, TouchPhase.HOVER);       if(touch) { label.text = "HOVER";      }
        Callout.show(label, button);
    }
}
}
