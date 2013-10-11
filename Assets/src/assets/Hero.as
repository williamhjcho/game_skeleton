/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 3:53 PM
 * To change this template use File | Settings | File Templates.
 */
package assets {
public class Hero {
    [Embed(source="../../sheets/hero.png")]
    public static const SPRITE_CLASS:Class;
    [Embed(source="../../sheets/hero.xml" , mimeType="application/octet-stream")]
    public static const XML_CLASS:Class;

}
}
