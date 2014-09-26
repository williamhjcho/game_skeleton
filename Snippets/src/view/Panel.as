/**
 * Created by William on 8/8/2014.
 */
package view {
import flash.text.TextField;
import flash.utils.setInterval;

import snd.Snd;

import utilsDisplay.base.BaseMovieClip;

public class Panel extends BaseMovieClip {

    public var btn1:BaseButton;
    public var btn2:BaseButton;
    public var btn3:BaseButton;

    public var txtDebug:TextField;

    public function Panel() {
        super();
    }

    public function setup():void {
        btn1.click = onClick;
        btn2.click = onClick;
        btn3.click = onClick;
        btn1.over = onOver;
        btn2.over = onOver;
        btn3.over = onOver;
        btn1.out = onOut;
        btn2.out = onOut;
        btn3.out = onOut;

        setInterval(update, 100);
    }

    private function update():void {
        var debug:String = Snd.toString();
        //trace("========== DEBUG ==========");
        //trace(debug);
        txtDebug.text = debug;
    }

    //==================================
    //
    //==================================
    private function onClick(btn:BaseButton):void {
        switch(btn) {
            case btn1: Snd.play("click", "unique", 1.0, 0.0, 0, 5); break;
            case btn2: Snd.play("click"); break;
            case btn3: Snd.play("click"); break;
        }
    }

    private function onOver(btn:BaseButton):void {
        switch(btn) {
            case btn1: Snd.play("over"); break;
            case btn2: Snd.play("over"); break;
            case btn3: Snd.play("over"); break;
        }
    }

    private function onOut(btn:BaseButton):void {
        switch(btn) {
            case btn1: break;
            case btn2: break;
            case btn3: break;
        }
    }

}
}
