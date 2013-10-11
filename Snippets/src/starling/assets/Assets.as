/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/11/13
 * Time: 8:40 AM
 * To change this template use File | Settings | File Templates.
 */
package starling.assets {
import com.greensock.loading.LoaderMax;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.utils.Dictionary;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class Assets  extends Sprite {

    internal static const SPRITE_CLASS  :String = "SPRITE_CLASS";
    internal static const XML_CLASS     :String = "XML_CLASS";


    /* HERO */
    private static var bitmaps      :Dictionary = new Dictionary();
    private static var XMLs         :Dictionary = new Dictionary();
    private static var textures     :Dictionary = new Dictionary();
    private static var atlases      :Dictionary = new Dictionary();
    private static var initialized  :Boolean = false;

    private static var LOADED_ASSET:*;

    public static function initialize():void {
        LOADED_ASSET = LoaderMax.getContent("assets").rawContent;

         if(!initialized) {
             HeroAssets.initialize();
         }
    }

    public static function getFromAsset(name:*):* {
        return LOADED_ASSET[name];
    }

    /** Expanding Methods **/
    public static function addBitmap(data:Bitmap, key:*):void {
        if(data == null || key == null) throw new Error("Bitmap and key cannot be null.");
        bitmaps[key] = data;
        textures[key] = Texture.fromBitmap(data);
    }

    public static function addTexture(data:Texture, key:*):void {
        if(data == null || key == null) throw new Error("Texture and key cannot be null.");
        textures[key] = data;
    }

    public static function addAtlas(data:TextureAtlas, key:*):void {
        if(data == null || key == null) throw new Error("Atlas and key cannot be null.");
        atlases[key] = data;
    }

    public static function addXML(data:XML, key:*):void {
        if(data == null || key == null) throw new Error("Xml and key cannot be null.");
        XMLs[key] = data;
    }

    /** Generating **/
    public static function generateAtlas(key:*, textureKey:*, xmlKey:* = null):TextureAtlas {
        xmlKey ||= textureKey;
        var texture:Texture = textures[textureKey], xml:XML = XMLs[xmlKey];
        if(!texture || !xml)
            throw new ArgumentError("Texture and/or XML not found for key:"+textureKey+" and xmlKey:"+xmlKey);

        atlases[key] = new TextureAtlas(texture, xml);
        return atlases[key];
    }


    /** Retrieving Methods **/
    public static function getBitmap(key:*):Bitmap {
        return bitmaps[key];
    }
    public static function getTexture(key:*):Texture {
        return textures[key];
    }

    public static function getAtlas(key:*):TextureAtlas {
        return atlases[key];
    }

    public static function getXML(key:*):XML {
        return XMLs[key];
    }


}
}
