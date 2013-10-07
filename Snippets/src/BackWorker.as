/**
 * Created with IntelliJ IDEA.
 * User: filiperp
 * Date: 04/10/13
 * Time: 16:14
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.system.MessageChannel;
import flash.system.Worker;
import flash.utils.ByteArray;

import fr.kikko.lab.ShineMP3Encoder;

public class BackWorker  extends Sprite{
    private var memory:ByteArray= new ByteArray();

    private var bm:MessageChannel;
    private var mb:MessageChannel;
    var mp3Encoder:ShineMP3Encoder;
    public function BackWorker() {
        memory.shareable= true;

        bm = Worker.current.getSharedProperty('btm')
        mb = Worker.current.getSharedProperty('mtb')

        mb.addEventListener(Event.CHANNEL_MESSAGE, onMainToBack);
        bm.send(memory)
        super();
    }

    private function onMainToBack(event:Event):void {

        if(mp3Encoder==null){
            memory.position=0;
            mp3Encoder = new ShineMP3Encoder(memory);
            mp3Encoder.addEventListener(Event.COMPLETE,onEncodeComplete);

            mp3Encoder.addEventListener(ProgressEvent.PROGRESS, onProgress);
            mp3Encoder.start();
        }


    }

    private function onEncodeComplete(event:Event):void {
        bm.send("COMPLETE");
        bm.send(mp3Encoder.mp3Data);
        mp3Encoder= null;


    }

    private function onProgress(event:ProgressEvent):void {
        bm.send("PROGRESS");
        bm.send(event.bytesLoaded);
        bm.send(event.bytesTotal);
    }
}
}
