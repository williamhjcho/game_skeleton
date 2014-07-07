/**
 * Created by William on 2/19/14.
 */
package utils.heap {
internal class BinaryHeap {

    private static const SCORE_FUNC:Function = function(x:*):Number { return x; };

    protected var tree:Array = [];
    protected var _scoreFunction:Function = null;

    /**
     * A score function is used to determine if the element if bigger then it's children.
     * (Note: if it's bigger, then it will be sunk downwards.)
     * @param scoreFunction Must return Number. (default value: function(x:Object):Number { return x; })
     */
    public function BinaryHeap(scoreFunction:Function = null) {
        this.scoreFunction = scoreFunction;
    }

    //==================================
    //  Overrides
    //==================================
    public function bubbleUp(n:uint):void {
    }

    public function sinkDown(n:uint):void {
    }

    //==================================
    //  Public
    //==================================
    public function heapify(values:Array):BinaryHeap {
        for each (var element:Object in values) {
            push(element);
        }
        return this;
    }

    /**
     * Adds the element at the LAST node and bubbles it upward
     * @param element
     */
    public function push(element:Object):void {
        tree.push(element);
        bubbleUp(tree.length-1);
    }

    /**
     * Removes the root (first) element and tries to normalize the heap by putting the LAST element in the root, and sinking it downwards
     * @return The root element
     */
    public function pop():Object {
        var element:Object = tree[0];
        var end:Object = tree.pop();

        //checking if by popping the element, the tree is empty
        if(tree.length > 0) {
            tree[0] = end;
            sinkDown(0);
        }

        return element;
    }

    /**
     * Removes the element if found on the tree
     * @param element
     */
    public function remove(element:Object):void {
        var len:int = tree.length;
        for (var i:int = 0; i < len; i++) {
            if(tree[i] != element) continue;

            var end:Object = tree.pop();
            if(i == len - 1) break;

            tree[i] = end;
            bubbleUp(i);
            sinkDown(i);
            break;
        }
    }

    /**
     * Removes the element at index n
     * @param n The index of the element in the tree
     * @return The element
     * @throws ArgumentError if n is out of range of tree.length
     */
    public function removeAt(n:uint):Object {
        var len:uint = tree.length;
        if(n >= len)
            throw new ArgumentError("Value n=" + n + " is out of range=" + len + ".");
        var element:Object = tree[n];
        tree[n] = tree.pop();
        bubbleUp(n);
        sinkDown(n);
        return element;
    }

    /**
     * Removes every element in the tree
     * @return The tree as is
     */
    public function removeAll():Array {
        var _t:Array = tree;
        this.tree = [];
        return _t;
    }

    /**
     * Returns the index of the element in the tree, if not found, index = -1
     * @param element
     * @return index
     */
    public function indexOf(element:Object):int {
        for (var i:int = 0; i < this.length; i++) {
            if(element == tree[i])
                return i;
        }
        return -1;
    }

    //==================================
    //  Get / Set
    //==================================
    /**
     * Length of the tree (number of elements)
     */
    public function get length():uint {
        return tree.length;
    }

    public function set scoreFunction(f:Function):void {
        _scoreFunction = f || SCORE_FUNC;
    }

    //==================================
    //  Static
    //==================================
    //public static function heapify(values:Array, scoreFunction:Function = null):BinaryHeapMax {
    //    var bhm:BinaryHeapMax = new BinaryHeapMax(scoreFunction);
    //    for each (var element:Object in values) {
    //        bhm.push(element);
    //    }
    //    return bhm;
    //}
}
}
