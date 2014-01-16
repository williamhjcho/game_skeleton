/**
 * Created by William on 1/15/14.
 */
package testing.sudoku {
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

internal class STextField extends TextField {

    private var _enabled:Boolean = false;
    private var _format:TextFormat;

    public function STextField(text:String = "", width:Number = 20, height:Number = 20) {
        super();
        super.type              = TextFieldType.DYNAMIC;
        super.maxChars          = 1;
        super.restrict          = "1-9";
        super.wordWrap          = false;
        super.multiline         = false;
        super.border            = true;
        super.width             = width;
        super.height            = height;
        super.text              = text;
        _format = new TextFormat(null, 32, null, null, null, null, null, null, TextFormatAlign.CENTER, null, null, null, null);
        enable();
    }

    public function enable():void {
        if(_enabled) return;
        _enabled = true;
        super.mouseEnabled = true;
        super.selectable = true;
        super.type = TextFieldType.INPUT;
        super.setTextFormat(_format);
    }

    public function disable():void {
        if(!_enabled) return;
        _enabled = false;
        super.mouseEnabled = false;
        super.selectable = false;
        super.type = TextFieldType.DYNAMIC;
        super.setTextFormat(_format);
    }

    public function set enabled(v:Boolean):void {
        if(v)   enable();
        else    disable();
    }


}
}
