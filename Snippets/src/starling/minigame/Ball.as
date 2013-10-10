/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/8/13
 * Time: 12:07 PM
 * To change this template use File | Settings | File Templates.
 */
package starling.minigame {
import starling.core.Starling;
import starling.display.MovieClip;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

import utils.toollib.vector.v2d;

public class Ball extends MovieClip {

    [Embed(source="../../../output/sheets/ball.png")]
    private static const BALL_SPRITE:Class;
    [Embed(source="../../../output/sheets/ball.xml", mimeType="application/octet-stream")]
    private static const XML_BALL:Class;

    private static var ATLAS:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new BALL_SPRITE()), XML(new XML_BALL()));

    public var identification:String;
    public var isPressed:Boolean = false;
    public var isRolledOver:Boolean = false;

    public var velocity:v2d = new v2d(0,0);

    public function Ball(time:Number) {
        var textures:Vector.<Texture> = ATLAS.getTextures();
        var fps:uint = textures.length / time;
        super(textures, fps);
        this.loop = false;
        Starling.juggler.add(this);
        this.pause();
    }


    public function update():void {
        this.x += velocity.x;
        this.y += velocity.y;
    }
}
}
