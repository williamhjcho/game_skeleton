/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/10/13
 * Time: 11:53 AM
 * To change this template use File | Settings | File Templates.
 */
package starling.hero {
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class HeroAssets {
    [Embed(source="../../../output/sheets/hero.png")]
    public static const HERO_SPRITE:Class;
    [Embed(source="../../../output/sheets/hero_walk.xml", mimeType="application/octet-stream")]
    public static const XML_WALK:Class;
    [Embed(source="../../../output/sheets/hero_jump.xml", mimeType="application/octet-stream")]
    public static const XML_JUMP:Class;
    [Embed(source="../../../output/sheets/hero_front.xml", mimeType="application/octet-stream")]
    public static const XML_FRONT:Class;
    [Embed(source="../../../output/sheets/hero_idle.xml", mimeType="application/octet-stream")]
    public static const XML_IDLE:Class;

    public static const TEXTURE       :Texture       = Texture.fromBitmap(new HERO_SPRITE());
    public static const TEXTURE_WALK  :XML           = XML(new XML_WALK());
    public static const TEXTURE_JUMP  :XML           = XML(new XML_JUMP());
    public static const TEXTURE_FRONT :XML           = XML(new XML_FRONT());
    public static const TEXTURE_IDLE  :XML           = XML(new XML_IDLE());
    public static const ATLAS_WALK    :TextureAtlas  = new TextureAtlas(TEXTURE, TEXTURE_WALK);
    public static const ATLAS_JUMP    :TextureAtlas  = new TextureAtlas(TEXTURE, TEXTURE_JUMP);
    public static const ATLAS_FRONT   :TextureAtlas  = new TextureAtlas(TEXTURE, TEXTURE_FRONT);
    public static const ATLAS_IDLE    :TextureAtlas  = new TextureAtlas(TEXTURE, TEXTURE_IDLE);
}
}
