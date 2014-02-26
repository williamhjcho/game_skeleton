/**
 * Created by William on 2/20/14.
 */
package utils.toollib.heap {
public class BinaryHeapMin extends BinaryHeap {


    public function BinaryHeapMin(scoreFunction:Function = null):void {
        super(scoreFunction);
    }

    /**
     * Sends the element at n, upwards swapPing with the parent node if the score is HIGHER
     * @param n The index on the tree
     * @throws ArgumentError if n is out of range of tree.length
     */
    override public function bubbleUp(n:uint):void {
        var len:uint = tree.length;
        if(n >= len)
            throw new ArgumentError("Value n=" + n + " is out of range=" + len + ".");
        var element:Object = tree[n];
        var score:Number = _scoreFunction(element);

        while(n > 0) {
            var parentN:uint = int((n + 1) / 2) - 1;
            var parent:Object = tree[parentN];

            if(score < _scoreFunction(parent)) {
                break;
            }

            tree[parentN] = element;
            tree[n] = parent;
            n = parentN;
        }
    }

    /**
     * Sends the element at n downwards, swapping with the child node if the score is LOWER
     * @param n The index of the element at the tree
     * @throws ArgumentError if n is out of range of tree.length
     */
    override public function sinkDown(n:uint):void {
        var len:int = tree.length;
        if(n >= len)
            throw new ArgumentError("Value n=" + n + " is out of range=" + len + ".");
        var element:Object = tree[n];
        var score:Number = _scoreFunction(element);

        while(true) {
            //child indexes
            var right:int = (n + 1) * 2, left:int = right - 1;
            var child:Object = null;
            var childScore:Number = 0;
            var swap:int = -1; //confirmation if it is necessary to swap

            if(right < len) {
                child = tree[right];
                childScore = _scoreFunction(child);

                if(childScore > score)
                    swap = right;
            }

            if(left < len) {
                child = tree[left];
                childScore = _scoreFunction(child);

                if(childScore > score)
                    swap = left;
            }

            //no swapping child
            if(swap == -1) return;

            tree[n] = tree[swap];
            tree[swap] = element;
            n = swap;
        }
    }

}
}
