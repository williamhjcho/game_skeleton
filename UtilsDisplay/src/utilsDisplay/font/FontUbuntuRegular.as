/**
 * Created with IntelliJ IDEA.
 * User: Filipe
 * Date: 04/09/13
 * Time: 22:10
 * To change this template use File | Settings | File Templates.
 */
package utilsDisplay.font {
import flash.text.TextFormat;

public class FontUbuntuRegular {
   /*[Embed(source="Z:/DESENVOLVIMENTO/projetos_GIT/filiperp_project_skeleton/Utils/assets/Ubuntu-R.ttf",
             fontName="UbuntuRegular",
            fontStyle = "normal",
            fontWeight = "normal",
            unicodeRange = "U+0020-003C,U+003E-007E,U+00A0,U+00A3,U+00A9,U+00AC,U+00AE,U+00BA,U+2013,U+2018-2019,U+201C-201D,U+20AC",
            mimeType = "application/x-font",
            advancedAntiAliasing = true
            ,embedAsCFF=false)]   */
    public var  ubuntu:Class;

    public function FontUbuntuRegular() {

    }

    public static function getFormat(size:int = 12, color:uint = 0xFFFFFF):TextFormat {
        var r:TextFormat = new TextFormat();
        r.font = "UbuntuRegular";
        r.color = color;
        r.size = size;
        return r;
    }

    /*
    * [Embed(source="../../assets/Ubuntu-R.ttf",
     fontName="UbuntuRegular",
     mimeType="application/x-font",
     fontWeight="normal",
     fontStyle="normal",

     advancedAntiAliasing="true",
     embedAsCFF="false")]
    * */

}
}
