/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 3:11 PM
 * To change this template use File | Settings | File Templates.
 */
package starling.assets {
import flash.display.Bitmap;
import flash.net.getClassByAlias;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class HeroAssets {

    private static const PREFIX_WALK    :String = "walking_";
    private static const PREFIX_JUMP    :String = "jump_";
    private static const PREFIX_IDLE    :String = "side_";
    private static const PREFIX_FRONT   :String = "front_";


    internal static function initialize():void {
        var assetClass:Class        = getClassByAlias(Aliases.HERO);
        var bitmap  :Bitmap         = new assetClass[Assets.SPRITE_CLASS]();
        var xml     :XML            = XML(new assetClass[Assets.XML_CLASS]());
        var texture :Texture        = Texture.fromBitmap(bitmap);
        var atlas   :TextureAtlas   = new TextureAtlas(texture, xml);

        //Assets.addBitmap(Assets.getFromAsset(HERO_BITMAP) as Bitmap, HERO_BITMAP);
        //Assets.addXML(Assets.getFromAsset(HERO_XML) as XML, HERO_XML);
        //Assets.generateAtlas(HERO, HERO_BITMAP, HERO_XML);
        Assets.addTexture(texture, HeroAssets);
        Assets.addXML(xml, HeroAssets);
        Assets.addAtlas(atlas, HeroAssets);
    }

    public static function get textures_walk    ():Vector.<Texture> { return Assets.getAtlas(HeroAssets).getTextures(PREFIX_WALK); }
    public static function get textures_jump    ():Vector.<Texture> { return Assets.getAtlas(HeroAssets).getTextures(PREFIX_JUMP); }
    public static function get textures_idle    ():Vector.<Texture> { return Assets.getAtlas(HeroAssets).getTextures(PREFIX_IDLE); }
    public static function get textures_front   ():Vector.<Texture> { return Assets.getAtlas(HeroAssets).getTextures(PREFIX_FRONT); }
}
}
