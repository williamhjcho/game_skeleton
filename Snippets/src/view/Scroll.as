/**
 * Created by William on 7/14/2014.
 */
package view {
import flash.events.Event;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import utils.commands.lerp;

import utils.misc.TimeKeeper;
import utils.vector.v2d;

import utilsDisplay.view.BaseMovieClip;

public class Scroll extends BaseMovieClip {

    public var container:SContainer;
    public var sliderH:SliderH;
    public var sliderV:SliderV;

    private var _scrollTime:uint = 500;

    public function Scroll() {
        super();

        addEventListener(Event.ENTER_FRAME, update);
        setTimeout(function():void {
            container.add(new Obj1(), 0, 0);
        }, 2000);

        lastTimeStamp = getTimer();
    }

    private var time        :TimeKeeper = new TimeKeeper();
    private var end         :v2d = new v2d(0,0);
    private var current     :v2d = new v2d(0,0);
    private var start       :v2d = new v2d(0,0);
    private var lastTimeStamp:uint = 0;

    private function update(e:Event):void {
        var t:uint = getTimer();
        var dt:uint = t - lastTimeStamp;
        lastTimeStamp = t;
        time.update(dt);

        var ph:Number = sliderH.percentage, pv:Number = sliderV.percentage;
        if(ph != end.x || pv != end.y) {
            start.setTo(current.x, current.y);
            end.setTo(ph, pv);
            time.reset(_scrollTime);
        }
        current.setTo(
                lerp(start.x, end.x, time.progress),
                lerp(start.y, end.y, time.progress)
        );
        container.setPercentage(current.x, current.y);
    }

}
}
