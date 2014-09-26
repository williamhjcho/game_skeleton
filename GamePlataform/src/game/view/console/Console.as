/**
 * Created by William on 9/15/2014.
 */
package game.view.console {
import flash.text.TextField;

import game.view.base.BaseMovieClipDispatcher;

public class Console extends BaseMovieClipDispatcher {



    public var txtLog:TextField;

    public function Console() {
        super();
    }

    public function addToLog(s:String, color:int = -1):void {
        if(color < 0) {
            color
        }
    }

    public function logHTML(s:String):void {
        txtLog.htmlText += s;
    }
}
}
