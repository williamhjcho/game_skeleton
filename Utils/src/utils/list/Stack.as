/**
 * Created by William on 7/21/2014.
 */
package utils.list {
/**
 * FILO
 */
public class Stack {

    private var mMaxLength:uint = 0;
    private var mList:Array;

    public function Stack(maxLength:uint = 0) {
        mMaxLength = maxLength;
        mList = [];
    }

    //==================================
    //  Public
    //==================================
    public function put(o:*):void {
        if(mMaxLength == 0 || mList.length < mMaxLength)
            mList.push(o);
    }

    public function get():* {
        return isEmpty? null : mList.pop();
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
        if(len > l) {
            mList.length = l;
        }
    }

    public function toString():String {
        return mList.toString();
    }
}
}
