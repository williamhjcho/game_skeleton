/**
 * Created by William on 7/10/2014.
 */
package utils.list {
public class Queue {

    private var list:Array = [];

    public function Queue() {

    }

    public function pop():* {
        return isEmpty? null : list.pop();
    }

    public function push(o:*):void {
        list.push(o);
    }

    public function clear():void {
        list = [];
    }

    public function get isEmpty():Boolean {
        return list.length == 0;
    }


}
}
