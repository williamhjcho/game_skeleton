/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/8/13
 * Time: 12:28 PM
 * To change this template use File | Settings | File Templates.
 */
package starling.images {
import starling.display.MovieClip;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class GifMovieClip extends MovieClip {

    [Embed(source="../../../output/anim1.png")]
    private static const SpriteSheet:Class;

    [Embed(source="../../../output/anim1.xml", mimeType="application/octet-stream")]
    private static const SpriteSheetXML:Class;

    public static var TEXTURE       :Texture      = Texture.fromBitmap(new SpriteSheet());
    public static var TEXTURE_XML   :XML          = XML(new SpriteSheetXML());
    public static var ATLAS         :TextureAtlas = new TextureAtlas(TEXTURE, TEXTURE_XML);


    public function GifMovieClip() {
        super(ATLAS.getTextures(), 30);
        this.loop = true;
    }
}
}
