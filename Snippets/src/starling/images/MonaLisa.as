/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/8/13
 * Time: 11:32 AM
 * To change this template use File | Settings | File Templates.
 */
package starling.images {

import starling.display.Image;
import starling.textures.Texture;

import utils.toollib.vector.v2d;

public class MonaLisa extends Image {

    [Embed(source="../../../output/mona_lisa.jpg")]
    private static const MONA_LISA:Class;
    private static const TEXTURE:Texture = Texture.fromBitmap(new MONA_LISA());

    public var velocity:v2d = new v2d(0,0);
    public var rot:Number = 0;

    public function MonaLisa() {
        super(TEXTURE);
    }

    public function update():void {
        this.x += velocity.x;
        this.y += velocity.y;
        this.rotation += rot;
    }
}
}
