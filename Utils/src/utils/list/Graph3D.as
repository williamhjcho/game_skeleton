/**
 * Created by William on 7/21/2014.
 */
package utils.list {
public class Graph3D {

    private var mWidth:uint, mHeight:uint, mLength:uint, mSize:uint;
    private var mElements:ArrayEx;

    public function Graph3D(width:uint, height:uint, length:uint, ...elements) {
        mWidth = width;
        mHeight = height;
        mLength = length;
        mSize = width * height * length;
        mElements = ArrayEx.from(elements);
        mElements.length = mSize;
    }

    //==================================
    //  Public
    //==================================
    public function get(i:uint, j:uint, k:uint):* {
        return mElements[mWidth * mHeight * k + mWidth * j + i];
    }

    public function set(i:uint, j:uint, k:uint, e:*):void {
        mElements[mWidth * mHeight * k + mWidth * j + i] = e;
    }

    public function getNeighborIndexes(i:uint, j:uint, k:uint, allowDiagonals:Boolean = false):Vector.<int> {
        //incremental order: i -> j -> k
        var p:int = mWidth * mHeight * k + mWidth * j + i;
        var t1:int, t2:int;
        var wLower:Boolean = i > 0,
                wUpper:Boolean = i < mWidth - 1,
                hLower:Boolean = j > 0,
                hUpper:Boolean = j < mHeight - 1,
                lLower:Boolean = k > 0,
                lUpper:Boolean = k < mLength - 1;
        var neighbors:Vector.<int> = new Vector.<int>();

        //lower section
        if(lLower) {
            t1 = p - mWidth * mHeight;

            //middle: left, middle, right
            if(wLower) neighbors.push(t1 - 1);
            neighbors.push(t1);
            if(wUpper) neighbors.push(t1 + 1);

            //top: left, middle, right
            if(hLower) {
                t2 = t1 - mWidth;
                if(wLower && allowDiagonals) neighbors.push(t2 - 1);
                neighbors.push(t2);
                if(wUpper && allowDiagonals) neighbors.push(t2 + 1);
            }

            //bottom: left, middle, right
            if(hUpper) {
                t2 = t1 + mWidth;
                if(wLower && allowDiagonals) neighbors.push(t2 - 1);
                neighbors.push(t2);
                if(wUpper && allowDiagonals) neighbors.push(t2 + 1);
            }
        }

        //middle section
        t1 = p;
        //middle: left, middle, right
        if(wLower) neighbors.push(t1 - 1);
        neighbors.push(t1);
        if(wUpper) neighbors.push(t1 + 1);

        //top: left, middle, right
        if(hLower) {
            t2 = t1 - mWidth;
            if(wLower && allowDiagonals) neighbors.push(t2 - 1);
            neighbors.push(t2);
            if(wUpper && allowDiagonals) neighbors.push(t2 + 1);
        }

        //bottom: left, middle, right
        if(hUpper) {
            t2 = t1 + mWidth;
            if(wLower && allowDiagonals) neighbors.push(t2 - 1);
            neighbors.push(t2);
            if(wUpper && allowDiagonals) neighbors.push(t2 + 1);
        }

        //upper section
        if(lUpper) {
            t1 = p + mWidth * mHeight;

            //middle: left, middle, right
            if(wLower) neighbors.push(t1 - 1);
            neighbors.push(t1);
            if(wUpper) neighbors.push(t1 + 1);

            //top: left, middle, right
            if(hLower) {
                t2 = t1 - mWidth;
                if(wLower && allowDiagonals) neighbors.push(t2 - 1);
                neighbors.push(t2);
                if(wUpper && allowDiagonals) neighbors.push(t2 + 1);
            }

            //bottom: left, middle, right
            if(hUpper) {
                t2 = t1 + mWidth;
                if(wLower && allowDiagonals) neighbors.push(t2 - 1);
                neighbors.push(t2);
                if(wUpper && allowDiagonals) neighbors.push(t2 + 1);
            }
        }


        neighbors.push(get(i, j, k));
        return neighbors;
    }

    public function getNeighbors(i:int, j:int, k:int, allowDiagonals:Boolean = false):Array {
        var n_idx:Vector.<int> = getNeighborIndexes(i,j,k,allowDiagonals);
        var neighbors:Array = [];
        for each (var index:int in n_idx) {
            neighbors.push(mElements[index]);
        }
        return neighbors;
    }

    //==================================
    //  Get / set
    //==================================
    public function get width():uint { return mWidth; }
    public function get height():uint { return mHeight; }
    public function get length():uint { return mLength; }
    public function get size():uint { return mSize; }
}
}
