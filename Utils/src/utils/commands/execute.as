/**
 * Created by William on 3/31/14.
 */
package utils.commands {
public function execute(f:Function, params:Array = null):* {
    if(f == null)
        return null;
    return f.apply(this, params);
}
}
