/**
 * Created by William on 7/14/2014.
 */
package utilsDisplay.scroll {
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.getTimer;

import utils.misc.Easing;
import utils.vector.v2d;

import utilsDisplay.base.BaseMovieClip;
import utilsDisplay.slider.SliderHorizontal;
import utilsDisplay.slider.SliderVertical;

public class Scroll extends BaseMovieClip {

    private var _container  :ScrollContainer;
    private var _sliderH    :SliderHorizontal;
    private var _sliderV    :SliderVertical;

    //parameters
    private var _enabled    :Boolean = false;
    private var _scrollTime :uint = 500;
    private var _dynamicV   :Boolean = false;
    private var _dynamicH   :Boolean = false;
    private var _minTrackerSize:Number = 20;

    //easing
    private var lastTimeStamp:uint = 0;
    private var time        :uint = 0;
    private var end         :v2d = new v2d(0,0);
    private var current     :v2d = new v2d(0,0);
    private var start       :v2d = new v2d(0,0);

    public function Scroll(container:DisplayObjectContainer = null, trackV:Sprite = null, trackerV:Sprite = null, trackH:Sprite = null, trackerH:Sprite = null, parameters:Object = null) {
        super();

        this._container = new ScrollContainer(container);
        this._sliderH = new SliderHorizontal(trackH, trackerH);
        this._sliderV = new SliderVertical(trackV, trackerV);

        setParameters(parameters);
        enable();
    }

    //==================================
    //  Public
    //==================================
    public function enable():void {
        _enabled = true;
        this.addEventListener(Event.ENTER_FRAME, update);
        lastTimeStamp = getTimer();
    }

    public function disable():void {
        _enabled = false;
        this.removeEventListener(Event.ENTER_FRAME, update);
    }

    /**
     * @param parameters
     *      scrollTime(uint): 500,
     *      dynamicV(Boolean): false,
     *      dynamicH(Boolean): false,
     *      minTrackerSize(Number): 20
     */
    public function setParameters(parameters:Object):void {
        parameters ||= {};
        _scrollTime     = parameters.scrollTime || _scrollTime;
        _dynamicV       = (parameters.dynamicV == null)? _dynamicV : parameters.dynamicV;
        _dynamicH       = (parameters.dynamicH == null)? _dynamicH : parameters.dynamicH;
        _minTrackerSize = parameters.minTrackerSize || _minTrackerSize;
    }


    //==================================
    //  Get / Set
    //==================================
    public function get container():ScrollContainer { return _container; }
    public function get sliderH():SliderHorizontal { return _sliderH; }
    public function get sliderV():SliderVertical { return _sliderV; }

    //==================================
    //  Private
    //==================================
    private function resizeTrackers():void {
        //inversely proportional to content/container size
        if(_dynamicV) {
            _sliderV.resizeTracker(_minTrackerSize, Number.MAX_VALUE, 1 / (_container.contentHeight / _container.containerHeight));
        }
        if(_dynamicH) {
            _sliderH.resizeTracker(_minTrackerSize, Number.MAX_VALUE, 1 / (_container.contentWidth / _container.containerWidth));
        }
    }

    private function renderContainer():void {
        var t:uint = getTimer();
        var dt:uint = t - lastTimeStamp;
        lastTimeStamp = t;

        var ph:Number = _sliderH.percentage, pv:Number = _sliderV.percentage;
        if(ph != end.x || pv != end.y) {
            start.setTo(current.x, current.y);
            end.setTo(ph, pv);
            time = 0;
        } else {
            if(time + dt >= _scrollTime) {
                time = _scrollTime;
            } else {
                time += dt;
            }
        }
        current.setTo(
                Easing.cubicOut(time, start.x, end.x - start.x, _scrollTime),
                Easing.cubicOut(time, start.y, end.y - start.y, _scrollTime)
        );
        _container.setPercentage(current.x, current.y);
    }

    //==================================
    //  Event
    //==================================
    private function update(e:Event):void {
        resizeTrackers();
        renderContainer();
    }

}
}
