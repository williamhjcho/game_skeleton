/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 11/05/13
 * Time: 10:14
 * To change this template use File | Settings | File Templates.
 */
package game.model {

/**
 * This class should contain OUTER-GAME variables only
 */
public class Config {

    public var allowed_domain:String;
    public var server_test   :String;

    /**
     * Dictionary where the key is a string referred in class AssetKey
     */
    public var assets_path:String;

    /**
     * Relative path to main.swf
     */
    public var preloader_path:String;
}
}
