/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 2:37 PM
 * To change this template use File | Settings | File Templates.
 */
package {
import assets.Ball;
import assets.Hero;

import flash.display.Sprite;
import flash.net.registerClassAlias;

public class Assets extends Sprite {


    public function Assets() {
        registerClassAlias("custom_hero_class", Hero);
        registerClassAlias("custom_ball_class", Ball);
    }
}
}
