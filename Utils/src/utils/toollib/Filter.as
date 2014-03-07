/**
 * Created by William on 3/5/14.
 */
package utils.toollib {

public final class Filter {

    /**
     * Calculates the negative(opposite) value for every element inside it (from the color spectrum)
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
     * Calculates the grayscale
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
     * * Calculates the gaussian filter
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

    /**
     * Calculates the Sobel Operator filter
     * @param data Array or Vector of(unsigned) integers
     * @param width width of the canvas
     * @param height height of the canvas
     * @param output
     * @return output
     */
    public static function sobel(data:*, width:uint, height:uint, output:Vector.<uint> = null):Vector.<uint> {
        output ||= new Vector.<uint>();
        output.length = width * height;

        for (var y:int = 1; y < height - 1; y++) {
            for (var x:int = 1; x < width - 1; x++) {
                var Gx:Number = -(data[(x-1) + (y-1) * width] + 2 * data[(x-1) + (y) * width] + data[(x-1) + (y+1) * width])
                        +(data[(x+1) + (y-1) * width] + 2 * data[(x+1) + (y) * width] + data[(x+1) + (y+1) * width]);
                var Gy:Number = +(data[(x-1) + (y-1) * width] + 2 * data[(x) + (y-1) * width] + data[(x+1) + (y-1) * width])
                        -(data[(x-1) + (y+1) * width] + 2 * data[(x) + (y+1) * width] + data[(x+1) + (y+1) * width]);
                var G:int = (Math.abs(Gx) + Math.abs(Gy)) / 2;
                output[x + y * width] = G | 0xff000000;
            }
        }
        return output;
    }

    /**
     * Calculates the Sobel Operator filter
     * @param data Array or Vector of(unsigned) integers
     * @param width width of the canvas
     * @param height height of the canvas
     * @param threshold threshold value to base the colorOn colorOff limit
     * @param colorOn
     * @param colorOff
     * @param output
     * @return output
     */
    public static function sobelBW(data:*, width:uint, height:uint, threshold:uint = 90, colorOn:uint = 0xffffffff, colorOff:uint = 0xff000000, output:Vector.<uint> = null):Vector.<uint> {
        output ||= new Vector.<uint>();
        output.length = width * height;

        var kernelX:Array = [
                [-1, 0, 1],
                [-2, 0, 2],
                [-1, 0, 1]
        ];
        var kernelY:Array = [
                [ 1, 2, 1],
                [ 0, 0, 0],
                [-1,-2,-1]
        ];
        var rgbX:Object = {r:0.0, g:0.0, b:0.0};
        var rgbY:Object = {r:0.0, g:0.0, b:0.0};
        var r:int,g:int,b:int;

        for (var y:int = 1; y < height - 1; y++) {
            for (var x:int = 1; x < width - 1; x++) {
                rgbX.r = rgbX.g = rgbX.b = 0;
                rgbY.r = rgbY.g = rgbY.b = 0;

                for (var j:int = -1; j <= 1; j++) {
                    for (var i:int = -1; i <= 1; i++) {
                        var color:uint = data[(x + i) + (y + j) * width];
                        var kx:int = kernelX[j+1][i+1], ky:int = kernelY[j+1][i+1];
                        r = (color>>16) & 0xff;
                        g = (color>>8 ) & 0xff;
                        b = (color    ) & 0xff;

                        rgbX.r += kx * r;
                        rgbX.g += kx * g;
                        rgbX.b += kx * b;

                        rgbY.r += ky * r;
                        rgbY.g += ky * g;
                        rgbY.b += ky * b;
                    }
                }
                r = Math.abs(rgbX.r) + Math.abs(rgbY.r);
                g = Math.abs(rgbX.g) + Math.abs(rgbY.g);
                b = Math.abs(rgbX.b) + Math.abs(rgbY.b);

                if((r + g + b) / 3 > threshold) {
                    output[x + y * width] = colorOn;
                } else {
                    output[x + y * width] = colorOff;
                }
            }
        }
        return output;
    }

    /**
     * Calculates the Sobel Operator at the horizontal level
     * @param data Array or Vector of(unsigned) integers
     * @param width width of the canvas
     * @param height height of the canvas
     * @param output
     * @return output
     */
    public static function sobelHorizontal(data:*, width:uint, height:uint, output:Vector.<uint> = null):Vector.<uint> {
        output ||= new Vector.<uint>();
        output.length = width * height;

        for (var y:int = 1; y < height - 1; y++) {
            for (var x:int = 1; x < width - 1; x++) {
                var G:Number = +(data[(x-1) + (y-1) * width] + 2 * data[(x) + (y-1) * width] + data[(x+1) + (y-1) * width])
                        -(data[(x-1) + (y+1) * width] + 2 * data[(x) + (y+1) * width] + data[(x+1) + (y+1) * width]);
                output[x + y * width] = G | 0xff000000;
            }
        }
        return output;
    }

    /**
     * Calculates the Sobel Operator at the vertical level
     * @param data Array or Vector of(unsigned) integers
     * @param width width of the canvas
     * @param height height of the canvas
     * @param output
     * @return output
     */
    public static function sobelVertical(data:*, width:uint, height:uint, output:Vector.<uint> = null):Vector.<uint> {
        output ||= new Vector.<uint>();
        output.length = width * height;

        for (var y:int = 1; y < height - 1; y++) {
            for (var x:int = 1; x < width - 1; x++) {
                var G:Number = -(data[(x-1) + (y-1) * width] + 2 * data[(x-1) + (y) * width] + data[(x-1) + (y+1) * width])
                        +(data[(x+1) + (y-1) * width] + 2 * data[(x+1) + (y) * width] + data[(x+1) + (y+1) * width]);
                output[x + y * width] = G | 0xff000000;
            }
        }
        return output;
    }
}
}
