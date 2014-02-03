/**
 * Created by William on 2/3/14.
 */
package gameplataform.view {
import flash.display.MovieClip;
import flash.text.TextField;

import utilsDisplay.bases.interfaces.IPreLoader;

public class PreLoader extends MovieClip implements IPreLoader {

    public var txtLabel:TextField;
    public var bar:MovieClip;

    private var _percentage:Number = 0;

    public function PreLoader() {
        super();
        percentage = 0;
    }


    public function set percentage(p:Number):void {
        _percentage = p;
        bar.gotoAndStop(int(_percentage * bar.totalFrames));
        txtLabel.text = int(_percentage * 100).toString() + "%" ;
    }

    public function get percentage():Number {
        return _percentage;
    }
}
}
