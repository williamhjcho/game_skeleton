/**
 * Created by William on 5/16/2014.
 */
package utils.data {
import utils.commands.callConstructor;
import utils.commands.getClass;
import utils.commands.getClassName;

/**
 * The class that subclasses this, MUST BE A SINGLETON
 * AS3's capabilities to abstract classes are NON-EXISTENT
 */
public class ResourcePool {

    private var _type:Class;
    private var _pool:Array = [];

    public function ResourcePool(type:Class) {
        this._type = type;
        this._pool = [];
    }

    /**
     * retrieving instances, if needed can be over written
     * @return instance of the class this pool controls
     */
    public function getElement(...parameters):* {
        if(_pool.length == 0) return callConstructor(_type, parameters);
        return _pool.pop();
    }

    /**
     * returns an instanced element to the pool
     * @param element element to be returned
     * @return current pool length
     */
    public function returnElement(element:*):int {
        if(element is _type) {
            _pool.push(element);
            return _pool.length;
        } else {
            throw new ArgumentError("Invalid element returned. Classes do not match:" + getClassName(element) + ", expected " + getClass(_type));
        }
    }

    /**
     * @return current pool length
     */
    public function get length():int {
        return _pool.length;
    }
}
}
