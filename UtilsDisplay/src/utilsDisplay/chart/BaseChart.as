/**
 * Created by William on 8/4/2014.
 */
package utilsDisplay.chart {
public class BaseChart extends ChartObject {

    private var _data:*;
    private var dataKey:Function;


    public function BaseChart() {
        super();
    }

    public function data(data:*, key:Function = null):BaseChart {
        _data = data;
        dataKey = key || RETURN_ITSELF;
        return this;
    }

    public function append(type:String):ChartObject {
        switch(type) {

            default : return null;
        }
    }

    //==================================
    //
    //==================================
    private static function RETURN_ITSELF(d:*):* {
        return d;
    }
}
}
