/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/24/13
 * Time: 3:01 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.list {
public class LinkedList {

    private var _next:LinkedList;

    public function LinkedList(next:LinkedList = null) {
        this._next = next;
    }

    public function get next():LinkedList { return _next; }
    public function set next(n:LinkedList):void { this._next = n; }
    public function get isLast():Boolean { return _next == null; }

    public function append(next:LinkedList):LinkedList {
        if(next != null) {
            next._next = this._next;
            this._next = next;
        }
        return this;
    }

    public function appendToLast(link:LinkedList):LinkedList {
        var ln:LinkedList = this;
        while(!ln.isLast) {
            ln = ln._next;
        }
        ln._next = link;
        return this;
    }

    public function removeNext():LinkedList {
        if(isLast) return null;
        var n1:LinkedList = _next;
        if(n1.isLast) {
            this._next = null;
            return n1;
        }
        this._next = _next._next;
        return n1;
    }


}
}
