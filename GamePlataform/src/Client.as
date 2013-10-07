/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/4/13
 * Time: 11:43 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.display.MovieClip;

import utils.managers.serializer.SerializerManager;

[SWF(width=800, height=600, backgroundColor=0x808080, frameRate=60, pageTitle="BLAHBLASDF")]
public class Client extends MovieClip {

    public function Client() {
        var str:String = "{\"a\":0,\"b\":[0,0,0]}";
        var obj:Object = SerializerManager.decodeFromString(str);
        trace(obj.a, "////", obj.b);
        trace(SerializerManager.encodeAndStringfy(obj));

    }

}
}
