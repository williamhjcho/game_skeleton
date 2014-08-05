/**
 * Created by William on 8/4/2014.
 */
package utilsDisplay.chart {

public class Bar extends ChartObject {

    private var w:Number, h:Number;
    private var bw:Number, bh:Number;
    private var data:*;

    public function Bar(data:*, width:Number, height:Number) {
        super();
        w = width;
        h = height;
    }

    public function append(form:String):ChartObject {
        return this;
    }

}
}
