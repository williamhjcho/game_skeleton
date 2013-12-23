/**
 * Created with IntelliJ IDEA.
 * User: filipe
 * Date: 30/01/13
 * Time: 17:39
 * To change this template use File | Settings | File Templates.
 */
package utils.managers {
import flash.display.MovieClip;
import flash.events.Event;
import flash.media.SoundMixer;
import flash.utils.ByteArray;

public class LipSyncManager {
    public static var bytes:ByteArray = new ByteArray();
    public static var value:int;
    public static var cf:int = 0;
    public static var delay:int=2;

    public static var currentLipSync:MovieClip;

    public static function enableLipsync(mouthMc:MovieClip):void {
        if (currentLipSync != null) {
            disableLipsync();
        }
        if (mouthMc != null) {
            currentLipSync = mouthMc;
            currentLipSync.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

    }

    public static function disableLipsync():void {
        if (currentLipSync != null) {
            currentLipSync.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
            currentLipSync.gotoAndStop(1);
            currentLipSync = null;
        }
        bytes = new ByteArray();
        value = 0;
        cf = 0;
    }

    public static function onEnterFrame(event:Event):void {
        cf++;
        if (cf == delay) {
           // DebuggerManager.debug("[LipSyncManager]speaking", event.currentTarget, "", "", 0xff0000);
            cf = 0;
            SoundMixer.computeSpectrum(bytes, true, 0);

            if (bytes.readFloat() < 0) {
                value = bytes.readFloat() * (-100);
            } else {
                value = bytes.readFloat() * (100);
            }
            value = value / 2;

            if (currentLipSync != null) {
                currentLipSync.gotoAndStop(value);

            } else {
                currentLipSync.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
                bytes = new ByteArray();
                value = 0;
                cf = 0;
            }
        }
    }
}
}

/*
 /*
 - Copyright 2011 Pixel Envision (E.Gonenc)
 - http://www.pixelenvision.com/
 - support@pixelenvision.com


var left:Number;

function processSound(event:SampleDataEvent):void
{
    var bytes:ByteArray = new ByteArray();
    playerObject.sourceSnd.extract(bytes, 4096);
    bytes.position = 0;
    while(bytes.bytesAvailable > 0)
    {
        left = bytes.readFloat()*128;
        if (left<0)	{
            left = -left;
        }
        var scale:Number = left*2;
    }
    event.data.writeBytes(bytes);

//Define mouth animation here
    if (scale<1) {mouth.gotoAndStop(1);}
    else if (scale<10) {mouth.gotoAndStop(2);}
    else if (scale<25) {mouth.gotoAndStop(3);}
    else if (scale<50) {mouth.gotoAndStop(4);}
    else {mouth.gotoAndStop(5);}
//Define mouth animation here

    trace(scale);
}

var playerObject:Object = new Object();
playerObject.sourceSnd = new speech();
playerObject.outputSnd = new Sound();
playerObject.outputSnd.addEventListener(SampleDataEvent.SAMPLE_DATA, processSound);
playerObject.outputSnd.play();
stop();

 */
