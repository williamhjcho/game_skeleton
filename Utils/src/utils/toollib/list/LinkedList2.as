/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/24/13
 * Time: 3:11 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.list {
public class LinkedList2 {

    private var _prev:LinkedList2, _next:LinkedList2;

    public function LinkedList2(previous:LinkedList2 = null, next:LinkedList2 = null) {
        this._prev = previous;
        this._next = next;
    }

    public function get next():LinkedList2 { return _next; }
    public function set next(n:LinkedList2):void { this._next = n; }

    public function get previous():LinkedList2 { return _prev; }
    public function set previous(n:LinkedList2):void { this._prev = n; }

    public function get isFirst():Boolean { return _prev == null; }
    public function get isLast():Boolean { return _next == null; }


    public function append(next:LinkedList2):LinkedList2 {
        if(next != null) {
            if(!isLast)
                this._next._prev = next;
            next._next = this._next;
            next._prev = this;
            this._next = next;
        }
        return this;
    }

    public function prepend(prev:LinkedList2):LinkedList2 {
        if(prev != null) {
            if(!isFirst)
                this._prev._next = prev;
            prev._prev = this._prev;
            prev._next = this;
            this._prev = prev;
        }
        return this;
    }

    public function appendToLast(link:LinkedList2):LinkedList2 {
        var ln:LinkedList2 = this;
        while(!ln.isLast) {
            ln = ln._next;
        }
        ln._next = link;
        link._prev = ln;
        link._next = null;
        return this;
    }

    public function prependToFirst(link:LinkedList2):LinkedList2 {
        var lp:LinkedList2 = this;
        while(!lp.isFirst) {
            lp = lp._prev;
        }
        lp._prev = link;
        link._prev = null;
        link._next = lp;
        return this;
    }

    public function remove():LinkedList2 {
        if(!isFirst)
            this._prev._next = this._next;
        if(!isLast)
            this._next._prev = this._prev;
        this._prev = null;
        this._next = null;
        return this;
    }

    public function removeNext():LinkedList2 {
        if(isLast) return null;

        var ln:LinkedList2 = this._next;
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

    public function removePrev():LinkedList2 {
        if(isFirst) return null;

        var lp:LinkedList2 = this._prev;
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
