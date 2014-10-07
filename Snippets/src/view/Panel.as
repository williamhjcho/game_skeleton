/**
 * Created by William on 8/8/2014.
 */
package view {
import flash.text.TextField;
import flash.utils.setInterval;

import utils.sound.SoundUtil;

import utilsDisplay.base.BaseMovieClip;

use namespace SoundUtil;

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
        var debug:String = SoundUtil.toString();
        //trace("========== DEBUG ==========");
        //trace(debug);
        txtDebug.text = debug;
    }

    //==================================
    //
    //==================================
    private function onClick(btn:BaseButton):void {
        switch(btn) {
            case btn1: SoundUtil.play("right", "MY_ID", 0, 0, 0, 0, 1, 0.5, false);
                //Snd.play("right", null, 1.0, 0.0, 0, 0);
                break;
            case btn2: SoundUtil.play("click"); break;
            case btn3: SoundUtil.play("click"); break;
        }
    }

    private function onOver(btn:BaseButton):void {
        switch(btn) {
            case btn1: SoundUtil.play("over"); break;
            case btn2: SoundUtil.play("over"); break;
            case btn3: SoundUtil.play("over"); break;
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
