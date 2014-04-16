/**
 * Created by William on 2/28/14.
 */
package utils.commands {
/**
 * @param arr Array or Vector
 * @param splice remove element from array or not
 * @return random element
 */
public function getRandomElementFrom(arr:Object, splice:Boolean = false):* {
    if(arr.length == 0) return null;
    var index:int = Math.round(Math.random() * (arr.length - 1));
    if(splice)  return arr.splice(index, 1)[0];
    else        return arr[index];
}
}
