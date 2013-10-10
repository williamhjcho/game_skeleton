/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/10/13
 * Time: 11:47 AM
 * To change this template use File | Settings | File Templates.
 */
package starling.hero {
import starling.display.Button;

public class HeroButton extends Button {



    public function HeroButton() {
        super(HeroAssets.ATLAS_FRONT.getTexture("front"), "", HeroAssets.ATLAS_JUMP.getTexture("jump"));
        this.useHandCursor = true;
    }
}
}
