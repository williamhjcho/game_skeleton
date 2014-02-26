/**
 * Created by William on 2/19/14.
 */
package testing {
public class BinaryHeap {
    
    private var content:Array = [];
    private var scoreFunction:Function = null;
    
    public function BinaryHeap(scoreFunction:Function = null) {
        this.scoreFunction = scoreFunction || score;
    }

    public function bubbleUp(n:uint):void {
        var element:Object = content[n];
        var score:Number = scoreFunction(element);

        while(n > 0) {
            var parentN:uint = int((n + 1) / 2) - 1;
            var parent:Object = content[parentN];

            if(score >= scoreFunction(parent)) {
                break;
            }

            content[parentN] = element;
            content[n] = parent;
            n = parentN;
        }
    }


    public function sinkDown(n:uint):void {
        var element:Object = n;
        var score:Number = scoreFunction(element);
        var len:int = content.length;

        while(true) {
            //child indexes
            var right:int = (n + 1) * 2, left:int = right - 1;
            var child:Object = null;
            var childScore:Number = 0;
            var swap:int = -1; //confirmation if it is necessary to swap

            if(right < len) {
                child = content[right];
                childScore = scoreFunction(child);

                if(childScore < score)
                    swap = right;
            }

            if(left < len) {
                child = content[left];
                childScore = scoreFunction(child);

                if(childScore < score)
                    swap = left;
            }

            //no swapping child
            if(swap == -1) return;

            content[n] = content[swap];
            content[swap] = element;
            n = swap;
        }
    }

    public function push(element:Object):void {
        content.push(element);
        bubbleUp(content.length-1);
    }

    public function pop():Object {
        var element:Object = content[0];
        var end:Object = content.pop();

        if(content.length > 0) {
            content[0] = end;
            sinkDown(0);
        }

        return element;
    }

    public function remove(element:Object):void {
        var len:int = content.length;
        for (var i:int = 0; i < len; i++) {
            if(content[i] != element) continue;

            var end:Object = content.pop();
            if(i == len - 1) break;

            content[i] = end;
            bubbleUp(i);
            sinkDown(i);
            break;
        }
    }

    private static function score(x:*):Number {
        return x;
    }
}
}
