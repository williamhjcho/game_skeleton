/**
 * Created by William on 7/21/2014.
 */
package utils.list {
public class Graph1D {

    private var mLength:uint;
    private var mElements:ArrayEx;

    public function Graph1D(length:uint, ...elements) {
        mLength = length;
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
    public function get length():uint {
        return mLength;
    }



}
}
