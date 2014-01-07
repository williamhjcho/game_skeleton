/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/24/13
 * Time: 3:11 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.list {
public class DoubleLinkedList {

    private var _prev:DoubleLinkedList, _next:DoubleLinkedList;

    public function DoubleLinkedList(previous:DoubleLinkedList = null, next:DoubleLinkedList = null) {
        this._prev = previous;
        this._next = next;
    }

    public function get next():DoubleLinkedList { return _next; }
    public function set next(n:DoubleLinkedList):void { this._next = n; }

    public function get previous():DoubleLinkedList { return _prev; }
    public function set previous(n:DoubleLinkedList):void { this._prev = n; }

    public function get isFirst():Boolean { return _prev == null; }
    public function get isLast():Boolean { return _next == null; }

    public function append(next:DoubleLinkedList):DoubleLinkedList {
        if(next != null) {
            if(!isLast)
                this._next._prev = next;
            next._next = this._next;
            next._prev = this;
            this._next = next;
        }
        return this;
    }

    public function prepend(prev:DoubleLinkedList):DoubleLinkedList {
        if(prev != null) {
            if(!isFirst)
                this._prev._next = prev;
            prev._prev = this._prev;
            prev._next = this;
            this._prev = prev;
        }
        return this;
    }

    public function appendToLast(link:DoubleLinkedList):DoubleLinkedList {
        var ln:DoubleLinkedList = this;
        while(!ln.isLast) {
            ln = ln._next;
        }
        ln._next = link;
        link._prev = ln;
        link._next = null;
        return this;
    }

    public function prependToFirst(link:DoubleLinkedList):DoubleLinkedList {
        var lp:DoubleLinkedList = this;
        while(!lp.isFirst) {
            lp = lp._prev;
        }
        lp._prev = link;
        link._prev = null;
        link._next = lp;
        return this;
    }

    public function remove():DoubleLinkedList {
        if(!isFirst)
            this._prev._next = this._next;
        if(!isLast)
            this._next._prev = this._prev;
        this._prev = null;
        this._next = null;
        return this;
    }

    public function removeNext():DoubleLinkedList {
        if(isLast) return null;

        var ln:DoubleLinkedList = this._next;
        if(ln.isLast) {
            this._next = null;
        } else {
            this._next = ln._next;
            ln._next._prev = this;
        }

        ln._next = null;
        ln._prev = null;
        return ln;
    }

    public function removePrev():DoubleLinkedList {
        if(isFirst) return null;

        var lp:DoubleLinkedList = this._prev;
        if(lp.isFirst) {
            this._prev = null;
        } else {
            this._prev = lp._prev;
            lp._prev._next = this;
        }

        lp._prev = null;
        lp._next = null;
        return lp;
    }
}
}
