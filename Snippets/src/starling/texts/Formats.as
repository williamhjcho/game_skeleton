/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/10/13
 * Time: 9:49 AM
 * To change this template use File | Settings | File Templates.
 */
package starling.texts {
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class Formats {

    private static const _format1:TextFormat = new TextFormat(Fonts.Kashuan_Script.fontName, 30, 0x0ff0000, false, false, false, null, null, TextFormatAlign.CENTER, null, null, null, null);

    public static function get Format1():TextFormat {
        return _format1;
    }

}
}
