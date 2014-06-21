/**
 * Created by William on 6/17/2014.
 */
package gameplataform.controller.utils {
import utils.commands.getClass;

public class ManageableList {

    private var _classType:Class;
    private var _list:Array;

    public function ManageableList(classType:Class) {
        _classType = classType;
        _list = [];
    }

    public function get(index:int):*                                            { return _list[index]; }
    public function pop():*                                                     { return _list.pop(); }
    public function join(sep:* = null):String                                   { return _list.join(sep); }
    public function reverse():Array                                             { return _list.reverse(); }
    public function concat(...rest):Array                                       { return _list.concat.apply(this, rest); }
    public function shift():*                                                   { return _list.shift(); }
    public function slice(A:* = 0,B:* = NaN):Array                              { return _list.slice(A, B); }
    public function unshift(...rest):uint                                       { return _list.unshift.apply(this, rest); }
    public function splice(...rest):*                                           { return _list.splice.apply(this, rest); }
    public function sort(...rest):*                                             { return _list.sort.apply(this, rest); }
    public function sortOn(names:*,options:* = 0,... rest):*                    { return _list.sortOn.apply(this, [names, options].concat(rest)); }
    public function indexOf(searchElement:*,fromIndex:* = 0):int                { return _list.indexOf(searchElement, fromIndex); }
    public function lastIndexOf(searchElement:*,fromIndex:* = 2147483647):int   { return _list.lastIndexOf(searchElement, fromIndex); }
    public function every(callback:Function,thisObject:* = null):Boolean        { return _list.every(callback, thisObject); }
    public function filter(callback:Function,thisObject:* = null):Array         { return _list.filter(callback, thisObject); }
    public function forEach(callback:Function,thisObject:* = null):void         { _list.forEach(callback, thisObject); }
    public function map(callback:Function,thisObject:* = null):Array            { return _list.map(callback, thisObject); }
    public function some(callback:Function,thisObject:* = null):Boolean         { return _list.some(callback, thisObject); }

    public function removeNulls():ManageableList {
        var len:int = _list.length;
        var currentIndex:int = 0;
        for (var i:int = 0; i < len; i++) {
            if(_list[i] != null) {
                //pushing down through gaps
                if(currentIndex != i) {
                    _list[currentIndex] = _list[i];
                    _list[i] = null;
                }
                currentIndex++;
            }
        }

        if(currentIndex != i) {
            len = _list.length;
            while(i < len) {
                _list[currentIndex++] = _list[i++];
            }
            _list.length = currentIndex;
        }
        return this;
    }

    public function push(...rest):void {
        for each (var obj:Object in rest) {
            if(check(obj)) {
                _list.push(obj);
            } else {
                throw new ArgumentError("Invalid class/subclass. [" + getClass(obj) + "] : " + obj.toString());
            }
        }
    }

    public function set(index:int, obj:Object):void {
        if(check(obj)) {
            _list[index] = obj;
        } else {
            throw new ArgumentError("Invalid class/subclass. [" + getClass(obj) + "] : " + obj.toString());
        }
    }

    public function check(obj:Object):Boolean {
        return getClass(obj) is _classType;
    }
}
}
