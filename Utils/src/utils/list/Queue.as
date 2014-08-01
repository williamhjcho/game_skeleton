/**
 * Created by William on 7/10/2014.
 */
package utils.list {

/**
 * FIFO
 */
public class Queue {

    private var mList:Array;
    private var mMaxLength:uint = 0;

    public function Queue(maxLength:uint = 0) {
        mList = [];
        mMaxLength = maxLength;
    }

    //==================================
    //  Public
    //==================================
    public function get():* {
        return isEmpty? null : mList.shift();
    }

    public function put(o:*):void {
        if(mMaxLength == 0 || mList.length < mMaxLength)
            mList.push(o);
    }

    public function clear():void {
        mList = [];
    }

    //==================================
    //  Get / Set
    //==================================
    public function get isEmpty():Boolean { return mList.length == 0; }

    public function get length():uint { return mList.length; }

    public function get maxLength():uint { return mMaxLength; }
    public function set maxLength(l:uint):void {
        mMaxLength = l;
        var len:int = mList.length;
        if(l != 0 && len > l) {
            mList.splice(0, len - l);
        }
    }

    public function toString():String {
        return mList.toString();
    }

}
}
