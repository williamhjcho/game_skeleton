/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 10/8/13
 * Time: 2:28 PM
 * To change this template use File | Settings | File Templates.
 */
package starling {
import flash.utils.Dictionary;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class TextureManager {

    private static var textures:Dictionary = new Dictionary();
    private static var atlases:Dictionary = new Dictionary();
    private static var XMLs:Dictionary = new Dictionary();


    /** Loading Methods **/
    public static function loadTexture(path:String, key:*):void {

    }


    /** Expanding Methods **/
    public static function addTexture(texture:Texture, key:*):void {
        if(!texture || !key) throw new Error("Texture and key cannot be null.");
        textures[key] = texture;
    }

    public static function addAtlas(atlas:TextureAtlas, key:*):void {
        if(!atlas || !key) throw new Error("Atlas and key cannot be null.");
        atlases[key] = atlas;
    }

    public static function addXML(xml:XML, key:*):void {
        if(!xml || !key) throw new Error("Xml and key cannot be null.");
        XMLs[key] = xml;
    }


    /** Retrieving Methods **/
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
