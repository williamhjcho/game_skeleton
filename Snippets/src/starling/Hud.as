
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

import flash.geom.Point;

import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.themes.MetalWorksMobileTheme;

public class Hud extends Sprite {

    private var button:Button;

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

        button.addEventListener(TouchEvent.TOUCH     , buttonInteracted);
    }

    private function onTriggered(e:Event):void {
        const label:Label = new Label();
        label.text = "Hi, I'm Feathers!\nHave a nice day.";
        Callout.show(label, button);
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
