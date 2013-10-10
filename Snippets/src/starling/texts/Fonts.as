/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/10/13
 * Time: 9:38 AM
 * To change this template use File | Settings | File Templates.
 */
package starling.texts {
import flash.text.Font;

public class Fonts {

    [Embed(source="../../../output/fonts/Ubuntu-R.ttf", embedAsCFF="false", fontName="Ubuntu-R")]
    private static const UBUNTU_CLASS:Class;
    public static const Ubuntu:Font = new UBUNTU_CLASS();

    [Embed(source="../../../output/fonts/KaushanScript-Regular.otf", embedAsCFF="false", fontName="Kashuan_Script")]
    private static const KASHUAN_SCRIPT:Class;
    public static const Kashuan_Script:Font = new KASHUAN_SCRIPT();


}
}
