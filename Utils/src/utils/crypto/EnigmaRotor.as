/**
 * Created with IntelliJ IDEA.
 * User: williamwc
 * Date: 2/3/13
 * Time: 12:11 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.crypto {
public class EnigmaRotor {
    private var labelRing:Array;
    private var indexRing:Array;
    private var crossRing:Array;
    private var ring:Array;   // [label,indexRing, crossRing]
    private var stepsRotated:int = 0;


    public function EnigmaRotor(crossRing:Array = null) {
        var staticWheel:Array = Enigma.getValidCharacters();
        labelRing = [];
        for (var i:int = 0; i < staticWheel.length; i++) {
            labelRing.push(staticWheel[i]);
        }
        setCrossRing(crossRing);
    }

    public function rotate(step:int):Boolean {
        // returns if has completed a full rotation
        var cycle:Array;
        if(step > 0) {
            cycle = ring.splice(0,step);
            this.ring = ring.concat(cycle);
        } else {
            cycle = ring.splice(ring.length + step);
            this.ring = cycle.concat(ring);
        }
        stepsRotated += step;
        if(stepsRotated < labelRing.length) {
            return false;
        } else {
            stepsRotated -= labelRing.length - 1;
            return true;
        }
    }

    public function rotateTo(position:int):void {
        //todo: better direct rotation (left/right splices)
        var idx:int = getIndexOf(labelRing[0]);
        var cycle:Array = ring.splice(idx);
        this.ring = cycle.concat(ring);
        rotate(position);
    }


    public function getOutput(input:int):int {
        return ring[input][2];
    }

    public function getOutputInv(input:int):int {
        return getIndexOfCross(input);
    }



    public function setCrossRing(crossRing:Array = null):void {
        var i:int;
        if(crossRing == null) {
            indexRing = [];
            for (i = 0; i < labelRing.length; i++) {
                indexRing.push(i);
            }
            crossRing = shuffle(indexRing);
        }

        this.crossRing = crossRing;

        ring = [];
        for (i = 0; i < labelRing.length; i++) {
            ring.push([labelRing[i],indexRing[i],crossRing[i]]);
        }
    }

    public function getCrossRing():Array {
        return crossRing;
    }


    private function getIndexOf(label:String):int {
        for (var i:int = 0; i < ring.length; i++) {
            if(ring[i][0] == label) return i;
        }
        return -1;
    }

    private function getIndexOfCross(cross:int):int {
        for (var i:int = 0; i < ring.length; i++) {
            if(ring[i][2] == cross) return i;
        }
        return -1;
    }



    public static function shuffle(target:Array):Array {
        var indexArr:Array = new Array();
        var shuffled:Array = new Array();
        var i:int, idx:int, realIdx:int;

        for (i = 0; i < target.length; i++) {
            indexArr.push(i);
        }

        while (indexArr.length > 0) {
            idx = Math.random() * indexArr.length;
            realIdx = indexArr[idx];
            shuffled.push(target[realIdx]);
            indexArr.splice(idx, 1);
        }

        return shuffled;
    }
}
}
