/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/7/13
 * Time: 10:52 AM
 * To change this template use File | Settings | File Templates.
 */
package citrus {
import citrus.core.starling.StarlingCitrusEngine;
import citrus.view.blittingview.AnimationSequence;

[SWF(width=1024, height=768, backgroundColor=0x808080, frameRate=30, pageTitle="BLAHBLASDF")]
public class Main extends StarlingCitrusEngine {

    public function Main() {
        this.setUpStarling();
        //new AnimationSequence()
    }
}
}
