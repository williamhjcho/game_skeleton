package utils.manager {
import flash.external.ExternalInterface;
import flash.system.Capabilities;

/**
 * @author Rafael Belvederese
 */
public class EnvironmentManager {

    public static var isLocal           :Boolean = true;
    public static var isLocalSWF        :Boolean = true;
    public static var isDebuggerPlayer  :Boolean = true;
    public static var isLocalServer     :Boolean = false;
    public static var isStandalone      :Boolean = false;
    public static var isPlugin          :Boolean = false;
    public static var isWeb             :Boolean = false;
    public static var isSCORM           :Boolean = false;
    public static var isMac             :Boolean = false;
    public static var isUnix            :Boolean = false;
    public static var isWin             :Boolean = false;

    public static var localServerDomainOrIp:String = "";

    /**
     * Detects various aspects of the enviroment in which the applicantion is held.<br/>
     * The <i>url</i> parameter, helps to detect some of these aspects.
     * @param url The url of the application. You may user the <b>LoaderInfo</b> class to retrieve this information.
     * @param LocalServerDomainOrIp local server domain or IP!
     * initialize(loaderInfo.url,"192.168.0.5");
     */

    public static function initialize(url:String, LocalServerDomainOrIp:String = null):void {
        localServerDomainOrIp = (LocalServerDomainOrIp == null || LocalServerDomainOrIp == "")? "localhost" : LocalServerDomainOrIp;
        var extension:String = url.substr(url.length - 3, 3);

        isLocal = (url.substr(0,4) == "file");

        if (url.indexOf("127.0.0.1") != -1 || url.indexOf("localhost") != -1 || url.indexOf(localServerDomainOrIp) != -1) {
            isLocalServer = true;
        }

        if (Capabilities.playerType == "StandAlone" && (extension != "swf")) {
            isLocalSWF = false;
            isStandalone = true;
        }

        if (Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX") {
            isLocalSWF = false;
            isPlugin = true;
        }
        isDebuggerPlayer = Capabilities.isDebugger;

        isWeb = (isPlugin && !isLocal);

        if (ExternalInterface.available) {
            isSCORM = Boolean(ExternalInterface.call("isSCORM"));
        }

        var os:String = Capabilities.version.substring(0, Capabilities.version.indexOf(" ")).toLowerCase();
        switch (os) {
            case "mac":     { isMac = true; break; }
            case "unix":    { isUnix = true; break; }
            case "win":     { isWin = true; break; }
        }
    }

}
}
