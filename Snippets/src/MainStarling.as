/**
 * Created by William on 8/8/2014.
 */
package {

import flash.utils.setInterval;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

public class MainStarling extends Sprite {

    private var obj:Image;

    public function MainStarling() {
        super();
        this.addEventListener(Event.ADDED_TO_STAGE, initialize);
    }

    public function initialize(e:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
        trace("init Main Starling");

        obj = new Image(Texture.fromEmbeddedAsset(Client.CHAR_EMBED));
        obj.x = 0;
        addChild(obj);

        setInterval(update, 100);
    }

    private var velocity:Number = 10;
    private function update():void {
        obj.x += velocity;
        if(obj.x < 0 || obj.x > 400) velocity *= -1;
    }

}
}
