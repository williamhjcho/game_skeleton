/**
 * Created by William on 7/21/2014.
 */
package utils.list {
public class Graph2D {

    private var mWidth:uint, mHeight:uint, mSize:uint;
    private var mElements:ArrayEx;

    public function Graph2D(width:uint, height:uint, ...elements) {
        mWidth = width;
        mHeight = height;
        mSize = width * height;
        mElements = ArrayEx.from(elements);
        mElements.length = mSize;
    }

    //==================================
    //  Public
    //==================================
    public function get(i:uint, j:uint):* {
        return mElements[mWidth * j + i];
    }

    public function set(i:uint, j:uint, e:*):void {
        mElements[mWidth * j + i] = e;
    }

    //clockwise
    public function getNeighborIndexes(i:uint, j:uint, allowDiagonals:Boolean = false):Vector.<int> {
        var p:uint = i + j * mWidth;
        var wLower:Boolean = i > 0,
            wUpper:Boolean = i < mWidth - 1,
            hLower:Boolean = j > 0,
            hUpper:Boolean = j < mHeight - 1;
        var neighbors:Vector.<int> = new Vector.<int>();
        //top-left, top, top-right
        if(hLower) {
            var low:int = p - mWidth;
            if(wLower && allowDiagonals) neighbors.push(low - 1);
            neighbors.push(low);
            if(wUpper && allowDiagonals) neighbors.push(low + 1);
        }
        //side-right
        if(wUpper) neighbors.push(p + 1);
        //bottom-right, bottom, bottom-left
        if(hUpper) {
            var high:int = p + mWidth;
            if(wUpper && allowDiagonals) neighbors.push(high + 1);
            neighbors.push(high);
            if(wLower && allowDiagonals) neighbors.push(high - 1);
        }
        //side-left
        if(wLower) neighbors.push(p - 1);
        return neighbors;
    }

    public function getNeighbors(i:uint, j:uint, allowDiagonals:Boolean = false):Array {
        var neighbors:Array = [];
        var n_idx:Vector.<int> = getNeighborIndexes(i, j, allowDiagonals);
        for each (var index:int in n_idx) {
            neighbors.push(mElements[index]);
        }
        return neighbors;
    }

    //==================================
    //  Get / Set
    //==================================
    public function get width():uint {
        return mWidth;
    }

    public function get height():uint {
        return mHeight;
    }

    public function get size():uint {
        return mSize;
    }
}
}
