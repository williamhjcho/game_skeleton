/**
 * Created by William on 2/19/14.
 */
package utils.list {
public class BinaryHeap {

    private var tree:ArrayEx;
    private var compareFn:Function;

    public function BinaryHeap(comparingFunction:Function, elements:* = null) {
        this.compareFn = comparingFunction;
        this.tree = new ArrayEx();
        add(elements);
    }

    //==================================
    //
    //==================================
    /**
     * Adds/inserts an list of elements from an enumerable object to the three
     * @param elements enumerable object (Array, Vector, ...)
     */
    public function add(elements:*):void {
        for each (var element:* in elements) {
            insert(element);
        }
    }

    /**
     * Inserts at the LAST position and bubbles it upward
     * @param element to be added
     */
    public function insert(element:*):void {
        tree.push(element);
        bubbleUp(tree.length - 1);
    }

    /**
     * Removes a node from the tree
     * @param n index of the node
     * @return the element inside that node
     */
    public function removeAt(n:int):* {
        var len:uint = tree.length;
        if(n >= len)
            throw new ArgumentError("Value n=" + n + " is out of range=" + len + ".");
        var element:* = tree[n];
        tree[n] = tree.pop();
        bubbleUp(n);
        bubbleDown(n);
        return element;
    }

    /**
     * Removes the first element it finds
     * @param element
     */
    public function remove(element:*):void {
        for (var i:int = 0; i < tree.length; i++) {
            if(tree[i] == element) {
                removeAt(i);
                break;
            }
        }
    }

    /**
     * Destroys the tree and creates a new one
     */
    public function clear():void {
        tree = new ArrayEx();
    }

    /**
     * Index of an element in the tree
     * @param element
     * @return index, (-1 if not found)
     */
    public function indexOf(element:*):int {
        for (var i:int = 0; i < tree.length; i++) {
            if(tree[i] == element)
                return i;
        }
        return -1;
    }

    //==================================
    //
    //==================================
    /**
     * Bubbles an node upward if comparator(child, parent) > 0
     * @param n index of the node
     */
    public function bubbleUp(n:int):void {
        var child:int = n, parent:int;
        while(child > 0) {
            parent = int((child + 1) / 2) - 1;
            if(compare(child, parent) > 0) {
                tree.swap(child, parent);
            } else {
                break;
            }
            child = parent;
        }
    }

    /**
     * Bubbles an node downward the tree if comparator(parent, child) > 0
     * @param n index of the node
     */
    public function bubbleDown(n:int):void {
        var left:int, right:int, next:int;
        var length:int = tree.length;
        while(true) {
            next = n;
            left = 2 * n + 1;
            right = left + 1;
            if(left < length && compare(left, next) > 0)
                next = left;
            if(right < length && compare(right, next) > 0)
                next = right;
            if(next != n) {
                tree.swap(next, n);
                n = next;
            } else
                break;
        }
    }

    //==================================
    //
    //==================================
    public function get length():uint {
        return tree.length;
    }

    public function compare(a:int, b:int):int {
        return compareFn(tree[a], tree[b]);
    }

    public function toString():String {
        return tree.toString();
    }

}
}
