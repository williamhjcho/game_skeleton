/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/3/13
 * Time: 9:22 AM
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.view {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.system.System;
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.utils.getTimer;

public class Stats extends Sprite {

    private var WIDTH:Number = 70, HEIGHT:Number = 100;

    private var graph:BitmapData;
    private var rect:Rectangle;

    private var xml:XML;
    private var style:StyleSheet;
    private var text:TextField;

    private var time:uint;
    private var lastTimeFrame:uint = 0;

    private var fps:uint;
    private var ms:uint;
    private var memory:Number;
    private var memoryMax:Number = 0;

    private var colors:Colors;
    private var benchmarks:Benchmarks;

    public function Stats() {
        colors = new Colors();
        benchmarks = new Benchmarks();

        xml = <xml>
            <fps>FPS: </fps>
            <ms>MS: </ms>
            <mem>MEM: </mem>
            <max>MAX: </max>
        </xml>;

        style = new StyleSheet();
        style.setStyle("xml"    , {fontSize:'9px', fontFamily:'_sans', leading:'-2px'});
        style.setStyle("fps"    , {color: hex2css(colors.fps)});
        style.setStyle("ms"     , {color: hex2css(colors.ms)});
        style.setStyle("mem"    , {color: hex2css(colors.memory)});
        style.setStyle("max"    , {color: hex2css(colors.memoryMax)});

        text = new TextField();
        text.x = 0; text.y = 0;
        text.width          = WIDTH;
        text.height         = 50;
        text.styleSheet     = style;
        text.condenseWhite  = true;
        text.selectable     = false;
        text.mouseEnabled   = false;
        text.wordWrap       = false;
        text.htmlText       = xml;

        this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
        this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
    }

    private function onAdded(e:Event):void {
        this.graphics.beginFill(colors.bg,1);
        this.graphics.drawRect(0,0,WIDTH, HEIGHT);
        this.graphics.endFill();

        addChild(text);

        graph = new BitmapData(WIDTH, HEIGHT - 50,false,colors.graphBG);
        rect = new Rectangle(WIDTH-1,0,1,HEIGHT - 50);

        this.graphics.beginBitmapFill(graph, new Matrix(1,0,0,1,0,50));
        this.graphics.drawRect(0, 50, WIDTH, HEIGHT - 50);

        this.addEventListener(MouseEvent.CLICK, onClick);
        this.addEventListener(Event.ENTER_FRAME, update);
    }

    private function onRemoved(e:Event):void {
        this.removeEventListener(Event.ENTER_FRAME, update);
        this.removeEventListener(MouseEvent.CLICK, onClick);

        this.graphics.clear();
        while(numChildren > 0) this.removeChildAt(0);
        graph.dispose();
    }

    private function update(e:Event):void {
        time = getTimer();

        if(ms > 1000) {
            memory = System.totalMemory / 1000000;
            memoryMax = Math.max(memory, memoryMax);

            graph.scroll(-1,0);
            graph.fillRect(rect, colors.graphBG);
            graph.setPixel(graph.width - 1, graph.height - Math.min(graph.height, (fps / stage.frameRate) * graph.height)   , colors.fps);
            graph.setPixel(graph.width - 1, graph.height - Math.min(graph.height, ((ms/fps)/(benchmarks.maxMS - benchmarks.minMS)) *graph.height), colors.ms);
            graph.setPixel(graph.width - 1, graph.height - Math.min(graph.height, Math.sqrt(Math.sqrt(memory)))             , colors.memory);
            graph.setPixel(graph.width - 1, graph.height - Math.min(graph.height, Math.sqrt(Math.sqrt(memoryMax)))          , colors.memoryMax);

            xml.fps = "FPS: " + fps + "/" + stage.frameRate;
            xml.ms  = "MS: " + int(ms / fps).toString();
            xml.mem = "MEM: " + memory.toFixed(3);
            xml.max = "MAX: " + memoryMax.toFixed(3);

            fps = 0;
            ms = 0;
        }

        ms += time - lastTimeFrame;
        lastTimeFrame = time;
        fps++;

        text.htmlText = xml;
    }

    private function onClick(e:MouseEvent):void {
        stage.frameRate += (this.mouseY / this.height > 0.5) ? -1 : 1;
        xml.fps = "FPS: " + fps + "/" + stage.frameRate;
        text.htmlText = xml;
    }


    private static function hex2css(color:uint):String {
        return "#" + color.toString(16);
    }

}
}

class Colors {
    public var bg           :uint = 0x000033;
    public var graphBG      :uint = 0x000033;
    public var fps          :uint = 0xffff00;
    public var ms           :uint = 0x00ff00;
    public var memory       :uint = 0x00ffff;
    public var memoryMax    :uint = 0xff0070;
}

class Benchmarks {
    public var minMS:uint = 0;
    public var maxMS:uint = 100;
}
