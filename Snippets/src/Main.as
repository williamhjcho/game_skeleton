/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.demonsters.debugger.MonsterDebugger;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.geom.Rectangle;

import utils.toollib.Filter;

[SWF(width=960, height=600, backgroundColor=0x808080, frameRate=30)]
public class Main extends MovieClip {

    [Embed(source="../output/mona_lisa.jpg")]
    private static const MONA_LISA:Class;

    [Embed(source="../output/valve.PNG")]
    private static const VALVE:Class;

    [Embed(source="../output/Bikesgray.jpg")]
    private static const BIKE:Class;

    public function Main() {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        MonsterDebugger.initialize(this);
        testTriangle();
    }

    private var originalImage:Bitmap;
    private var outputImage:Bitmap;

    private var originalVector:Vector.<uint>;
    private var rect:Rectangle;

    private function testTriangle():void {
        originalImage = new VALVE();
        addChild(originalImage);

        rect = new Rectangle(0,0,originalImage.width, originalImage.height);
        originalVector = originalImage.bitmapData.getVector(rect);

        outputImage = new Bitmap(new BitmapData(originalImage.width, originalImage.height));
        outputImage.x = originalImage.width;
        addChild(outputImage);


        var output:Vector.<uint> = originalVector.concat();
        //output = Filter.grayScale(output);
        output = Filter.negative(output);
        //output = Filter.sobel(output, rect.width, rect.height, null);
        //output = Filter.sobelBW(output, rect.width, rect.height, 90);
        //output = Filter.sobelHorizontal(output, rect.width, rect.height, null);
        //output = Filter.sobelVertical(output, rect.width, rect.height, null);
        outputImage.bitmapData.setVector(rect, output);
    }


}
}
