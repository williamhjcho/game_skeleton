/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 11/05/13
 * Time: 10:14
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.model {
import flash.utils.Dictionary;

/**
 * This class should contain OUTER-GAME variables only
 */
public class Config {

    public var allowedDomain:String;
    public var serverTest   :String;

    /**
     * Dictionary where the key is a string referred in class AssetKey
     */
    public var assets       :Dictionary;

    /**
     * Relative path to main.swf
     */
    public var preLoaderPath:String;


    public var showStats    :Boolean;
}
}
