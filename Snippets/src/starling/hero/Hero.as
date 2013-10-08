/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/8/13
 * Time: 3:00 PM
 * To change this template use File | Settings | File Templates.
 */
package starling.hero {
import starling.core.Starling;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class Hero extends Sprite {

    public static const LEFT:uint = 0, RIGHT:uint = 1;


    [Embed(source="../../../output/walk_animation.png")]
    private static const SpriteSheet:Class;

    [Embed(source="../../../output/walk_animation.xml", mimeType="application/octet-stream")]
    private static const SpriteSheetXML:Class;

    public static var TEXTURE       :Texture      = Texture.fromBitmap(new SpriteSheet());
    public static var TEXTURE_XML   :XML          = XML(new SpriteSheetXML());
    public static var ATLAS         :TextureAtlas = new TextureAtlas(TEXTURE, TEXTURE_XML);

    private var currentAnimation:MovieClip = null;
    private var anim_walk:MovieClip;

    public var isMoving:Boolean = false;
    public var orientation:uint = 1; //left,right,up,down

    public function Hero() {
        super();

        anim_walk = new MovieClip(ATLAS.getTextures(), 12); Starling.juggler.add(anim_walk);
        anim_walk.x = -anim_walk.width/2;
        anim_walk.y = -anim_walk.height;
        anim_walk.loop = true;
        anim_walk.pause();
        addChild(anim_walk);


        currentAnimation = anim_walk;
    }

    public function walk(orientation:uint):void {
        currentAnimation = anim_walk;
        anim_walk.play();
        switch (orientation) {
            case LEFT: setLeft(); break;
            case RIGHT: setRight(); break;
        }
    }

    public function stop():void {
        currentAnimation.stop();
    }

    public function jump():void {

    }



    public function setLeft():void {
        if(orientation != LEFT) {
            scaleX = -1;
            orientation = LEFT;
        }
    }

    public function setRight():void {
        if(orientation != RIGHT) {
            scaleX = 1;
            orientation = RIGHT;
        }
    }


    private function set animation(anim:MovieClip):void {
        currentAnimation = anim;
    }

}
}
