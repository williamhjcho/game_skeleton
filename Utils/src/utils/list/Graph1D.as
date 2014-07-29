/**
 * Created by William on 7/21/2014.
 */
package utils.list {
public class Graph1D {

    private var mSize:uint;
    private var mElements:ArrayEx;

    public function Graph1D(length:uint, ...elements) {
        mSize = length;
        mElements = ArrayEx.from(elements);
        mElements.length = length;
    }

    //==================================
    //  Public
    //==================================
    public function get(i:uint):* {
        return mElements[i];
    }

    public function set(i:uint, e:*):void {
        mElements[i] = e;
    }

    //==================================
    //  Get / Set
    //==================================
    public function get size():uint {
        return mSize;
    }



}
}
