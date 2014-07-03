/**
 * Created by William on 1/14/14.
 */
package testing.sudoku {
import flash.display.Graphics;
import flash.display.Sprite;
import flash.text.TextField;

import utils.toollib.color.ToolColor;

public class SBlock extends Sprite {

    private var _size:uint;
    private var _color:uint;
    private var _textWidth:Number = 40;
    private var _textHeight:Number = 40;

    private var _data:Vector.<uint>;
    private var _texts:Vector.<STextField>;

    public function SBlock(size:uint, color:int = -1) {
        super();

        _size = size;

        _data = new Vector.<uint>();
        _texts = new Vector.<STextField>();
        _data.length = _texts.length = _size * _size;
        _data.fixed = _texts.fixed = true;
        for (var i:int = 0; i < _size * _size; i++) {
            _data[i] = 0;
            _texts[i] = new STextField("", _textWidth, _textHeight);
            _texts[i].x = (i%_size) * _texts[i].width;
            _texts[i].y = int(i/_size) * _texts[i].height;
            addChild(_texts[i]);
        }

        this.color = (color == -1)? ToolColor.random() : color;
    }

    //==================================
    //  Internal
    //==================================
    internal function getTextFieldAt(i:uint):TextField { return _texts[i]; }
    internal function getDigitAt(i:uint):uint { return _data[i]; }
    internal function getDigitCoordinates(d:uint):SCoordinates {
        for (var i:int = 0; i < _data.length; i++) {
            if(_data[i] == d)
                return new SCoordinates(i, i % _size, i / _size);
        }
        return null;
    }
    internal function get isComplete():Boolean {
        var repeated:Vector.<uint> = new Vector.<uint>();
        for each (var data:uint in _data) {
            if(data == 0 || data > 9 || repeated.indexOf(data) != -1) return false;
            repeated.push(data);
        }
        return true;
    }

    internal function hasDigitInLine(digit:uint, line:uint):Boolean {
        for (var i:int = 0; i < _size; i++) {
            if(_data[line * _size + i] == digit)
                return true;
        }
        return false;
    }

    internal function hasDigitInColumn(digit:uint, column:uint):Boolean {
        for (var i:int = 0; i < _size; i++) {
            if(_data[column + _size * i] == digit)
                return true;
        }
        return false;
    }


    //==================================
    //  Public
    //==================================
    public function setInitialValues(v:Vector.<uint>):void {
        for (var i:int = 0; i < _data.length; i++) {
            if((i < v.length) && (v[i] != 0) && (v[i] <= 9)) {
                _data[i] = v[i];
                _texts[i].disable();
                _texts[i].text = _data[i].toString();
            } else {
                _data[i] = 0;
                _texts[i].enable();
                _texts[i].text = "";
            }
        }
    }

    public function hasDigit(d:uint):Boolean {
        for each (var data:uint in _data)
            if(data == d) return true;
        return false;
    }

    public function get length():uint { return _size * _size; }

    public function set color(v:uint):void {
        _color = v;
        var g:Graphics = this.graphics;
        g.clear();
        g.lineStyle(3, _color);
        g.beginFill(_color, 0.5);
        g.drawRect(0, 0, _size * (_textWidth), _size * (_textHeight));
        g.endFill();
    }



}
}
