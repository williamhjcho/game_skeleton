/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 4:06 PM
 * To change this template use File | Settings | File Templates.
 */
package starling.assets {
import flash.display.Bitmap;
import flash.net.getClassByAlias;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class BallAssets {

    internal static function initialize():void {
        var assetClass:Class        = getClassByAlias(Aliases.BALL);
        var bitmap  :Bitmap         = new assetClass[Assets.SPRITE_CLASS]();
        var xml     :XML            = XML(new assetClass[Assets.XML_CLASS]());
        var texture :Texture        = Texture.fromBitmap(bitmap);
        var atlas   :TextureAtlas   = new TextureAtlas(texture, xml);

        Assets.addTexture(texture, HeroAssets);
        Assets.addXML(xml, HeroAssets);
        Assets.addAtlas(atlas, HeroAssets);
    }

    public static function get textures():Vector.<Texture> {
        return null;
    }
}
}
