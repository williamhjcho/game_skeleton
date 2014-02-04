/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 11/05/13
 * Time: 10:14
 * To change this template use File | Settings | File Templates.
 */
package gameplataform.model {

/**
 * This class should contain OUTER-GAME variables only
 */
public class Config {

    public var allowedDomain:String;
    public var serverTest   :String;
    public var saveLink     :String;
    public var loadLink     :String;

    public var assets       :Vector.<String>;

    public var preLoaderPath:String;
    public var showStats    :Boolean;
}
}
