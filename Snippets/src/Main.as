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
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.utils.setInterval;

import menu.ItemCustom;
import menu.MenuContainer;

import utils.commands.Benchmark;
import utils.systems.CellularAutomata;
import utils.systems.Conway;
import utils.toollib.ToolColor;

import utilsDisplay.view.menu.Menu;
import utilsDisplay.view.menu.MenuItem;
import utilsDisplay.view.scroll.Scroll;
import utilsDisplay.view.scroll.ScrollParameters;

[SWF(width=1024, height=768, backgroundColor = 0x808080, frameRate=60)]
public class Main extends Sprite {

    private var color0:uint, color1:uint;

    public function Main() {
        MonsterDebugger.initialize(this);

        color0 = ToolColor.random();
        color1 = ToolColor.opposite(color0);

        testConway();
    }

    //==================================
    //
    //==================================
    private var scroll:Scroll, sParams:ScrollParameters = new ScrollParameters();
    private var container:SimpleChild = new SimpleChild(300,200,"rect", 0x00ff0000);
    private var content:SimpleChild = new SimpleChild(200,100,"circle", 0xff00ff00);
    private var tV:SimpleChild = new SimpleChild(30,100), kV:SimpleChild = new SimpleChild(30, 30), bVU:SimpleChild = new SimpleChild(30,30), bVD:SimpleChild = new SimpleChild(30,30);
    private var tH:SimpleChild = new SimpleChild(100,30), kH:SimpleChild = new SimpleChild(30, 30), bHU:SimpleChild = new SimpleChild(30,30), bHD:SimpleChild = new SimpleChild(30,30);
    private function scrollTest():void {
        container.x = 10;
        container.y = 10;
        addChild(container);
        addChild(tV);
        addChild(kV);
        addChild(bVU);
        addChild(bVD);
        addChild(tH);
        addChild(kH);
        addChild(bHU);
        addChild(bHD);
        scroll = new Scroll(container, content, sParams);
        scroll.setVerticalComponents(tV,kV, bVU, bVD);
        scroll.setHorizontalComponents(tH,kH, bHU, bHD);

        stage.addEventListener(KeyboardEvent.KEY_UP, press);
    }

    private function press(e:KeyboardEvent):void {
        //trace(e.keyCode);
        switch(e.keyCode) {
            case 87: content.height += 50; scroll.update(); break;
            case 65: content.width  -= 50; scroll.update(); break;
            case 83: content.height -= 50; scroll.update(); break;
            case 68: content.width  += 50; scroll.update(); break;
        }
    }


    //==================================
    //
    //==================================
    private var _menu:Menu, menuContainer:MenuContainer;

    private function menuTest():void {
        menuContainer = new MenuContainer(400,600,0x000ff0);
        menuContainer.x = 20;
        menuContainer.y = 20;
        addChild(menuContainer);
        _menu = new Menu(menuContainer, null);
        var item:MenuItem;
        item = _menu.add(new ItemCustom(200, 50, 0x0f00f0));
        item = _menu.add(new ItemCustom(200, 50, 0x0f00f0));
        item = _menu.add(new ItemCustom(200, 50, 0x0f00f0));
        item = _menu.add(new ItemCustom(200, 50, 0x0f00f0));
        item = _menu.add(new ItemCustom(200, 50, 0x0f00f0));
    }


    //==================================
    //  Cellular Automata
    //==================================
    private var automata:CellularAutomata;
    private var automataCanvas:BitmapData;
    private function testCellularAutomata():void {
        automataCanvas = new BitmapData(250, stage.stageHeight, true, 0xffffff);
        automata = new CellularAutomata(automataCanvas.width);

        var canvas:Bitmap = new Bitmap(automataCanvas);
        canvas.x = stage.stageWidth - canvas.width >> 1;
        addChild(canvas);

        var g:Graphics = this.graphics;
        g.beginFill(color0);
        g.drawRect(canvas.x - 100, 30, 30, 30);
        g.beginFill(color1);
        g.drawRect(canvas.x - 50, 30, 30, 30);
        g.endFill();

        trace(automata);

        setInterval(automataEF, 15);
    }

    private function automataEF():void {
        var cells:Vector.<uint> = automata.cells;
        var gen:int = automata.generation;
        for (var i:int = 0; i < automata.length; i++) {
            automataCanvas.setPixel32(i, gen, cells[i] == 0? color0 : color1);
        }

        if(gen >= stage.stageHeight) {
            color0 = ToolColor.random();
            color1 = ToolColor.opposite(color0);
            automata.reset();
            automata.randomizeCells();
            automata.randomizeRules();
            trace(automata);
        } else {
            automata.iterate();
        }
    }

    //==================================
    //  Conway
    //==================================
    private var conway:Conway;
    private var cc:Shape;
    private var cSize:Rectangle = new Rectangle(0,0,5,5);

    private function testConway():void {
        conway = new Conway(30,30);
        conway.randomize();

        cc = new Shape();
        cc.x = stage.stageWidth - conway.width * cSize.width * 2 >> 1;
        cc.y = stage.stageHeight - conway.height * cSize.height * 2 >> 1;
        addChild(cc);

        conwayRender();
        //setInterval(conwayEF, 50);
        stage.addEventListener(MouseEvent.MOUSE_WHEEL, conwayEF);
    }

    private function conwayEF(e:Event = null):void {
        conway.iterate();
        conwayRender();
    }

    private function conwayRender():void {
        var cells:Vector.<Vector.<uint>> = conway.cells;
        var g:Graphics = cc.graphics;
        g.clear();
        g.lineStyle(0);

        for (var i:int = 0; i < conway.width; i++) {
            for (var j:int = 0; j < conway.height; j++) {
                var c:uint = cells[i][j] == 0? color0 : color1;
                g.beginFill(c);
                g.drawCircle(i * cSize.width*2, j * cSize.width*2, cSize.width);
            }
        }
        g.endFill();
    }

    //==================================
    //  Class Arch
    //==================================
    private function testClassArch():void {

    }


    //==================================
    //      Benchmark
    //==================================
    private var vec:Vector.<Vector.<uint>> = new <Vector.<uint>>[new <uint>[0], new <uint>[0]];
    private function benchmarkStuff():void {
        trace(Benchmark(90000,f1,vec));
        trace(Benchmark(90000,f2,vec[1]));
    }

    private function f1(v:Vector.<Vector.<uint>>):void {
        v[0][0] += 1;
    }

    private function f2(v:Vector.<uint>):void {
        v[0] += 1;
    }
}
}
