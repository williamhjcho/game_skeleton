/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/4/13
 * Time: 11:45 AM
 * To change this template use File | Settings | File Templates.
 */
package worker {
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.net.FileReference;
import flash.net.FileReferenceList;
import flash.system.MessageChannel;
import flash.system.Worker;
import flash.system.WorkerDomain;
import flash.utils.ByteArray;

import fr.kikko.lab.ShineMP3Encoder;

[SWF(width=800, height=600, backgroundColor=0x808080, frameRate=30, pageTitle="BLAHBLASDF")]
public class Main extends MovieClip {

    [Embed(source="../../output/BackWorker.swf", mimeType="application/octet-stream")]
    private var WorkerSWFClass:Class;
    private var worker:Worker;
    private var gui:ui;

    private var list:FileReferenceList;
    private var file:FileReference;
    private var bm:MessageChannel;
    private var mb:MessageChannel;
    private var memory:ByteArray;

    private var mp3Encoder:ShineMP3Encoder;
    private var USEWORKER:Boolean = true;

    public function Main() {
        var xm:XML = new XML();
        xm = <root>asdfasdfa</root>;

        trace(xm.toString());
        gui = new ui();
        gui.loadbar.scaleX = 0;
        gui.x = 300;
        gui.y = 200;
        addChild(gui);
        gui.loadButton.addEventListener(MouseEvent.CLICK, onClick);
        list = new FileReferenceList();
        list.addEventListener(Event.SELECT, onSelect);


        worker = WorkerDomain.current.createWorker(new WorkerSWFClass());
        bm = worker.createMessageChannel(Worker.current);
        mb = Worker.current.createMessageChannel(worker);

        worker.setSharedProperty("btm", bm);
        worker.setSharedProperty("mtb", mb);

        bm.addEventListener(Event.CHANNEL_MESSAGE, onBackTOMain);
        worker.start();
        memory = bm.receive(true);
    }


    private function onEncodeComplete(event:Event):void {
        (new FileReference()).save(mp3Encoder.mp3Data);
        mp3Encoder = null;


    }

    private function onProgress(event:ProgressEvent):void {
        trace(event.bytesLoaded);
        gui.loadbar.scaleX = event.bytesLoaded / event.bytesTotal;
    }

    private function onClick(event:MouseEvent):void {
        list.browse();
    }

    private function onSelect(event:Event):void {
        file = list.fileList[0];
        file.addEventListener(Event.COMPLETE, onLoaded);
        file.load();

    }

    private function onLoaded(event:Event):void {

        memory.length = 0;
        memory.writeBytes(file.data);

        if (USEWORKER) {
            mb.send("DATA");
        } else {
            mp3Encoder = new ShineMP3Encoder(file.data);
            mp3Encoder.addEventListener(Event.COMPLETE, onEncodeComplete);

            mp3Encoder.addEventListener(ProgressEvent.PROGRESS, onProgress);
            mp3Encoder.start();
        }
    }

    private function onBackTOMain(event:Event):void {

        if (bm.messageAvailable) {
            var header:String = bm.receive();
            if (header == "PROGRESS") {
                gui.loadbar.scaleX = bm.receive() / bm.receive();
            }
            else {
                (new FileReference()).save(bm.receive());
            }
        }
    }
}
}

