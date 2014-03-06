/**
 * Created by William on 3/5/14.
 */
package utils.toollib {
public final class Filter {

    /**
     * Receives and array or vector of (unsigned)integers and applies the corresponding negative in the color spectrum
     * @param data Array or Vector of (unsigned)integers
     * @param output
     * @return output
     */
    public static function negative(data:*, output:Vector.<uint> = null):Vector.<uint> {
        output ||= new Vector.<uint>(data.length);
        var l:int = data.length;
        for (var i:int = 0; i < l; i++) {
            output[i] = ToolColor.opposite(data[i]);
        }
        return output;
    }

    /**
     * Calculates the grayscale form of an Array or Vector of (unsigned)integers
     * @param data Array or Vector of (unsigned) integers
     * @param output
     * @return output
     */
    public static function grayScale(data:*, output:Vector.<uint> = null):Vector.<uint> {
        output ||= new Vector.<uint>(data.length);
        var l:int = data.length;
        for (var i:int = 0; i < l; i++) {
            output[i] = ToolColor.grayScale(data[i]);
        }
        return output;
    }

    /**
     * * Calculates the gaussian filter form of an Array or Vector of (unsigned)integers
     * @param data Array or Vector of (unsigned) integers
     * @param width width of the canvas
     * @param height height of the canvas
     * @param kernel Matrix containing the constants to be applied in this filter
     * @param output
     * @return output
     */
    public static function gaussian(data:*, width:uint, height:uint, kernel:Matrix, output:Vector.<uint> = null):Vector.<uint> {
        output ||= new Vector.<uint>(width * height);

        var kernelWidth:uint = kernel.columns, kernelHeight:uint = kernel.rows;
        var kernelOffsetW:uint = (kernelWidth - 1) / 2, kernelOffsetH:uint = (kernelHeight - 1) / 2;
        var rgb:Object = {r:0.0, g:0.0, b:0.0};

        for (var y:int = kernelOffsetH; y < height - kernelOffsetH; y++) {
            for (var x:int = kernelOffsetW; x < width - kernelOffsetW; x++) {

                rgb.r = rgb.g = rgb.b = 0.0;

                for (var j:int = -kernelOffsetH; j <= kernelOffsetH; j++) {
                    for (var i:int = -kernelOffsetW; i < kernelOffsetW; i++) {
                        var color:uint = data[(x + i) + (y + j) * width];
                        var k:Number = kernel.getAt(j + kernelOffsetH, i + kernelOffsetW);
                        rgb.r += (k * ToolColor.getR(color));
                        rgb.g += (k * ToolColor.getG(color));
                        rgb.b += (k * ToolColor.getB(color));
                    }
                }

                rgb.r = ToolMath.clamp(rgb.r, 0, 0xff);
                rgb.g = ToolMath.clamp(rgb.g, 0, 0xff);
                rgb.b = ToolMath.clamp(rgb.b, 0, 0xff);

                output[x + y * width] = ToolColor.RGBtoInt(rgb.r, rgb.g, rgb.b, 0xff);
            }
        }
        return output;
    }


}
}
