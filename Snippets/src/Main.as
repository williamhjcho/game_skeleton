/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 9:57 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.demonsters.debugger.MonsterDebugger;

import flash.display.Graphics;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;

import utils.toollib.ToolMath;

[SWF(width=1024, height=768, backgroundColor = 0x808080, frameRate=30)]
public class Main extends Sprite {

    public function Main() {
        MonsterDebugger.initialize(this);


    }

    private var deck:Vector.<Card>;
    private function calculateProbability():void {
        deck = new Vector.<Card>();
        var t:Array = [1,1,1,1,1, 2,2, 3,3, 4,4, 5, 6, 7, 8];
        for (var i:int = 0; i < t.length; i++) {
            deck.push(new Card(t[i]));
        }
    }



}
}

class Card {
    public var type:int = 0;

    public function Card(type:int):void {
        this.type = type;
    }
}

import flash.utils.Dictionary;

class HuffmanCoding {



    public function HuffmanCoding() {

    }

    public static function compress(s:String):String {
        var cps:String = "";
        var tree:Vector.<Object> = analyze(s);


        return "";
    }

    public static function decompress(s:String):String {
        return "";
    }


    //==================================
    //  Compressing
    //==================================
    private static function analyze(s:String):Vector.<Object> {
        var len:int = s.length;
        var frequencies:Dictionary = new Dictionary();
        for (var i:int = 0; i < len; i++) {
            var ch:String = s.charAt(i);
            if(ch in frequencies)
                frequencies[ch]++;
            else
                frequencies[ch] = 1;
        }

        var temp:Vector.<Object> = new Vector.<Object>();
        for (var ch:String in frequencies) {
            temp.push({value:ch, frequency:frequencies[ch]});
        }
        temp.sort(function(a:Object, b:Object):int {
            if(a.frequency > b.frequency) return 1;
            else if(a.frequency < b.frequency) return -1;
            else return 0;
        });
        traceThis(temp);

        var tree:Vector.<Object> = new Vector.<Object>();


        return tree;
    }

    private static function traceThis(t:Vector.<Object>):void {
        var s:String = "[";
        for each (var o:Object in t) {
            s += o.value + ":" + o.frequency + ","
        }
        trace(s + ']');
    }
}
