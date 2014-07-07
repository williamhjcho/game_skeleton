/**
 * Created by William on 2/3/14.
 */
package game.view {
import flash.text.TextField;

import game.view.base.BaseMovieClipAnimated;

import utilsDisplay.bases.interfaces.IPreLoader;

public class PreLoader extends BaseMovieClipAnimated implements IPreLoader {

    public var txtLabel:TextField;

    private var _percentage:Number = 0;

    public function PreLoader() {
        super();
        percentage = 0;
    }

    public function set percentage(p:Number):void {
        _percentage = p;
        txtLabel.text = int(_percentage * 100).toString() + "%" ;
    }

    public function get percentage():Number {
        return _percentage;
    }
}
}
