/**
 * Created by William on 4/22/2014.
 */
package testing {
public class AnimationChain {

    public var f:Vector.<Function>;

    public function AnimationChain(...functions) {
        f = new Vector.<Function>();
        for each (var fo:* in functions) {
            f.push(fo);
        }
    }


}
}
