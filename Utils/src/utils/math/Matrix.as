/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 06/06/13
 * Time: 13:38
 * To change this template use File | Settings | File Templates.
 */
package utils.math {
import flash.errors.IllegalOperationError;
import flash.geom.Rectangle;

import utils.string.ToolString;

public class Matrix {

    private var c:int, r:int;
    protected var data:Vector.<Vector.<Number>>;

    public function Matrix(rows:int, columns:int) {
        this.r = rows;
        this.c = columns;

        data = new Vector.<Vector.<Number>>();
        data.length = rows;
        data.fixed = true;
        for (var i:int = 0; i < rows; i++) {
            data[i] = new Vector.<Number>();
            data[i].length = columns;
            data[i].fixed = true;
        }
    }

    public function setAs(value:*):void {
        //value can be Array or Vector.<Vector.<Number>>
        var minRow:int = Math.min(r, value.length);
        for (var i:int = 0; i < minRow; i++) {
            var minCol:int = Math.min(c, value[i].length);
            for (var j:int = 0; j < minCol; j++) {
                data[i][j] = value[i][j];
            }
        }
    }

    //==================================
    //  Checking / Comparing
    //==================================
    public function get isSquare    ()          :Boolean { return (r == c); }
    public function isCompatible    (m:Matrix) :Boolean { return (c == m.c && r == m.r); }
    public function isMultipliable  (m:Matrix) :Boolean { return (m.c == r); }

    public function isLeftMultipliable(m:Matrix):Boolean  { return (m.c == r);  }
    public function isRightMultipliable(m:Matrix):Boolean { return (c == m.r);  }
    public function hasSameDimensions(m:Matrix):Boolean { return (r == m.r && c == m.c);    }

    public function isTriangularUpper():Boolean {
        for (var j:int = 0; j < c - 1; j++)
            for (var i:int = j + 1; i < r; i++)
                if(data[i][j] != 0) return false;
        return true;
    }

    public function isTriangularLower():Boolean {
        for (var i:int = 0; i < r - 1; i++)
            for (var j:int = i + 1; j < c; j++)
                if(data[i][j] != 0) return false;
        return true;
    }

    public function isZero():Boolean {
        for (var i:int = 0; i < r; i++)
            for (var j:int = 0; j < c; j++)
                if(data[i][j] != 0) return false;
        return true;
    }

    public function isDiagonal():Boolean {
        var i:int, j:int;
        for (i = 0; i < r; i++) {
            for (j = 0; j < i; j++) {
                if(data[i][j] != 0) return false;
            }
            if(data[i][i] == 0) return false;
            for (j = i + 1; j < c; j++) {
                if(data[i][j] != 0) return false;
            }
        }
        return true;
    }

    public function equals(m:Matrix):Boolean {
        if(!hasSameDimensions(m)) return false;

        for (var i:int = 0; i < r; i++) {
            for (var j:int = 0; j < c; j++) {
                if(data[i][j] != m.data[i][j]) return false;
            }
        }
        return true;
    }


    //==================================
    //  Transformations
    //==================================
    public function identity():Matrix {
        for (var i:int = 0; i < r; i++) {
            for (var j:int = 0; j < i; j++)
                data[i][j] = 0;
            data[i][i] = 1;
            for (j = i + 1; j < c; j++)
                data[i][j] = 0;
        }
        return this;
    }

    public function zero():Matrix {
        for (var i:int = 0; i < r; i++) {
            for (var j:int = 0; j < c; j++) {
                data[i][j] = 0;
            }
        }
        return this;
    }

    public function transpose():Matrix {
        for (var i:int = 0; i < this.r; i++)
            for (var j:int = i + 1; j < this.c; j++)
                swap(i,j,j,i);
        return this;
    }

    public function rotateClockWise():Matrix {
        if(!isSquare) throw new IllegalOperationError("Must be square matrix.");

        var r:int = r - 1, c:int = c - 1, temp:*;
        for (var i:int = 0; i < r / 2; i++) {
            for (var j:int = i; j < c - i - 1; j++) {
                temp = data[i][j];
                data[i][j] = data[r-j][i];
                data[r-j][i] = data[r-i][c-j];
                data[r-i][c-j] = data[j][c-i];
                data[j][c-i] = temp;
            }
        }
        return this;
    }

    public function rotateCounterClockWise():Matrix {
        if(!isSquare) throw new IllegalOperationError("Must be square matrix.");

        var r:int = r - 1, c:int = c - 1, temp:*;

        for (var i:int = 0; i < r/2; i++) {
            for (var j:int = i; j < c - i - 1; j++) {
                temp = data[i][j];
                data[i][j] = data[j][c-i];
                data[j][c-i] = data[r-i][c-j];
                data[r-i][c-j] = data[r-j][i];
                data[r-j][i] = temp;
            }
        }

        return this;
    }


    //==================================
    //  Get / Set / Copy
    //==================================
    public function get rows()      :int { return this.r; }
    public function get columns()   :int { return this.c; }
    public function get size()      :int { return r*c;   }

    public function getAt(r:int, c:int)           :Number { return data[r][c]; }
    public function setAt(r:int, c:int, v:Number) :void   { data[r][c] = v;    }

    public function getCopy():Matrix {
        var copy:Matrix = new Matrix(r,c);
        for (var i:int = 0; i < r; i++) {
            for (var j:int = 0; j < c; j++) {
                copy.data[i][j] = data[i][j];
            }
        }
        return copy;
    }

    public function copy(m:Matrix, copyCoordinates:Rectangle = null, applyI:uint = 0, applyJ:uint = 0):void {
        if(copyCoordinates == null) copyCoordinates = new Rectangle(0,0, m.c, m.r);

        var minI:int = Math.min(copyCoordinates.y + copyCoordinates.height, r);
        var minJ:int = Math.min(copyCoordinates.x + copyCoordinates.width , c);
        for (var i:int = copyCoordinates.y, ii:int = applyJ; i < m.r && ii < minI; i++, ii++) {
            for (var j:int = copyCoordinates.x, jj:int = applyI; j < m.c && jj < minJ; j++, jj++) {
                this.data[ii][jj] = m.data[i][j];
            }
        }
    }


    //==================================
    //  Operations
    //==================================
    public function add(m:Matrix):Matrix {
        var minR:int = Math.min(r, m.r), minC:int = Math.min(c, m.c);
        for (var i:int = 0; i < minR; i++) {
            for (var j:int = 0; j < minC; j++) {
                data[i][j] += m.data[i][j];
            }
        }
        return this;
    }

    public function subtract(m:Matrix):Matrix {
        var minR:int = Math.min(r, m.r), minC:int = Math.min(c, m.c);
        for (var i:int = 0; i < minR; i++) {
            for (var j:int = 0; j < minC; j++) {
                data[i][j] -= m.data[i][j];
            }
        }
        return this;
    }

    public function multiplyLeft(m:Matrix):Matrix {
        if(!isLeftMultipliable(m)) return null;

        var result:Matrix = new Matrix(m.r, this.c);

        for (var i:int = 0; i < result.r; i++) {
            for (var j:int = 0; j < result.c; j++) {
                result.data[i][j] = 0;
                for (var k:int = 0; k < m.c; k++) {
                    result.data[i][j] += m.data[i][k] * this.data[k][j];
                }
            }
        }
        return result;
    }

    public function multiplyRight(m:Matrix):Matrix {
        if(!isRightMultipliable(m)) return null;

        var result:Matrix = new Matrix(this.r, m.c);
        for (var i:int = 0; i < this.r; i++) {
            for (var j:int = 0; j < m.c; j++) {
                result.data[i][j] = 0;
                for (var k:int = 0; k < this.c; k++) {
                    result.data[i][j] += this.data[i][k] * m.data[k][j];
                }
            }
        }
        return result;
    }

    public function multiplyBy(c:Number):Matrix {
        for (var i:int = 0; i < r; i++) {
            for (var j:int = 0; j < c; j++) {
                data[i][j] *= c;
            }
        }
        return this;
    }

    public function reduce():Matrix {
        var i:int, j:int, k:int;
        for (i = 0; i < r; i++) {
            //finding first non-zero row (in column col)
            for (k = i; k < r; k++) {
                if(data[k][i] != 0)
                    break;
            }
            if(k != i)
                swapRows(i, k);

            //divide whole row for the first element so the first column will be 1
            if(data[i][i] != 1) {
                for (j = i + 1; j < c; j++) {
                    data[i][j] /= data[i][i];
                }
                data[i][i] = 1; //make it 1 AFTER the operation
            }

            for (k = i + 1; k < r; k++) {
                for (j = i + 1; j < c; j++) {
                    data[k][j] -= data[i][j] * data[k][i];
                }
                data[k][i] = 0;
            }
        }

        return this;
    }

    public function decomposeLU(L:Matrix, U:Matrix):void {
        if(!isSquare)
            throw new IllegalOperationError("Must be square to decompose LU.");
        if(L == null || U == null)
            throw new IllegalOperationError("L and U cannot be null.");
        if(!L.hasSameDimensions(this) || !U.hasSameDimensions(this))
            throw new IllegalOperationError("L and U must have same dimensions as this matrix");

        var r:int, c:int, k:int;
        var sum:Number;
        L.setPrimaryDiagonalAs(1);

        for (r = 0; r < r; r++) {
            for (c = 0; c < r ; c++) {
                sum = 0;
                for (k = 0; k < r; k++) {
                    sum += L.data[r][k] * U.data[k][c];
                }
                L.data[r][c] = (this.data[r][c] - sum) / U.data[c][c];
            }

            for (c = r; c < c; c++) {
                sum = 0;
                for (k = 0; k < r; k++) {
                    sum += L.data[r][k] * U.data[k][c];
                }
                U.data[r][c] = this.data[r][c] - sum;
            }
        }
    }


    //==================================
    //  Eigen Values
    //==================================
    // det(A - LI) = 0 --> At least 1 value on the main diagonal is 0
    public function eigenValues():Array {
        var values:Array = [];
        for (var ij:int = 0; ij < Math.min(r, c); ij++) {
            var add:Boolean = true;
            for (var k:int = 0; k < values.length; k++) {
                if(values[k] == data[ij][ij]) {
                    add = false;
                    break;
                }
            }
            if(add) values.push(data[ij][ij]);
        }
        return values;
    }


    //==================================
    //  Row / Column Operations
    //==================================
    public function getRow(r:int, output:Vector.<Number> = null):Vector.<Number> {
        if(output == null) output = new Vector.<Number>();
        for (var c:int = 0; c < c; c++) { output[c] = data[r][c]; }
        return output;
    }

    public function getColumn(c:int, output:Vector.<Number> = null):Vector.<Number> {
        if(output == null) output = new Vector.<Number>;
        for (var r:int = 0; r < r; r++) { output[r] = data[r][c]; }
        return output;
    }

    public function setRow(r:int, model:Array):Matrix {
        var min:int = Math.min(model.length, c);
        for (var c:int = 0; c < min; c++) { data[r][c] = model[c]; }
        return this;
    }

    public function setColumn(c:int, model:Array):Matrix {
        var min:int = Math.min(model.length, r);
        for (var r:int = 0; r < min; r++) { data[r][c] = model[r]; }
        return this;
    }

    public function setRowAs(r:int, model:Number):Matrix {
        for (var c:int = 0; c < c; c++) { data[r][c] = model; }
        return this;
    }

    public function setColumnAs(c:int, model:Number):Matrix {
        for (var r:int = 0; r < r; r++) { data[r][c] = model; }
        return this;
    }

    public function swapRows(r0:int, r1:int):Matrix {
        var aux:Vector.<Number> = data[r0];
        data[r0] = data[r1];
        data[r1] = aux;
        return this;
    }

    public function swapColumns(c0:int, c1:int):Matrix {
        for (var r:int = 0; r < r; r++) {
            var aux:Number = data[r][c0];
            data[r][c0] = data[r][c1];
            data[r][c1] = aux;
        }
        return this;
    }

    public function removeRow(r:int):Matrix {
        data.splice(r,1);
        r--;
        return this;
    }

    public function removeColumn(c:int):Matrix {
        for (var r:int = 0; r < r; r++) {
            data[r].splice(c,1);
        }
        c--;
        return this;
    }


    //==================================
    //  Diagonals
    //==================================
    public function getPrimaryDiagonal():Vector.<Number> {
        var output:Vector.<Number> = new Vector.<Number>;
        var min:int = Math.min(r, c);
        for (var i:int = 0; i < min; i++) {
            output[i] = data[i][i];
        }
        return output;
    }

    public function getSecondaryDiagonal():Vector.<Number> {
        var output:Vector.<Number> = new Vector.<Number>;
        var i:int = 0, j:int = c-1;
        while(i < r && j >= 0) {
            output[i] = data[i][j];
            i++;
            j--;
        }
        return output;
    }

    public function setPrimaryDiagonal(model:Vector.<Number>):void {
        var min:int = Math.min(r, c, model.length);
        for (var i:int = 0; i < min; i++) {
            data[i][i] = model[i];
        }
    }

    public function setSecundaryDiagonal(model:Vector.<Number>):void {
        var i:int = 0, j:int = c-1;
        while(i < r && j >= 0) {
            data[i][j] = model[i];
            i++;
            j--;
        }
    }

    public function setPrimaryDiagonalAs(value:Number):void {
        var min:int = Math.min(r, c);
        for (var i:int = 0; i < min; i++)
            data[i][i] = value;
    }

    public function setSecundaryDiagonalAs(value:Number):void {
        var i:int = 0, j:int = c-1;
        while(i < r && j >= 0) {
            data[i++][j--] = value;
        }
    }


    //==================================
    //  Tools / Misc
    //==================================
    public function swap(r0:int, c0:int, r1:int, c1:int):void {
        var z:* = data[r0][c0];
        data[r0][c0] = data[r1][c1];
        data[r1][c1] = z;
    }

    public function toString():String {
        var s:String = "[Matrix("+r+", "+c+")]";
        var maxLength:int = 0;
        for (var i:int = 0; i < r; i++) {
            for (var j:int = 0; j < c; j++) {
                var l:int = String(data[i][j].toString()).length;
                if(maxLength < l)
                    maxLength = l;
            }
        }

        for (i = 0; i < r; i++) {
            s += "\n\t";
            for (j = 0; j < c; j++) {
                var v:String = String(data[i][j]);
                v = ToolString.repeatPattern(" ", maxLength - v.length) + v;
                s += v + (j != c-1 ? ", " : "");
            }
        }
        return s;
    }

    public function forEach(f:Function):void {
        for (var i:int = 0; i < r; i++) {
            for (var j:int = 0; j < c; j++) {
                f.call(this, i, j, data[i][j]);
            }
        }
    }

    public function forEachRow(r:int, f:Function):void {
        for (var i:int = 0; i < c; i++)
            f.call(this, r, i, data[r][i]);
    }

    public function forEachColumn(c:int, f:Function):void {
        for (var i:int = 0; i < r; i++)
            f.call(this, i, c, data[i][c]);
    }


    //==================================
    //  Static
    //==================================
    public static function Identity(r:int, c:int):Matrix {
        var idt:Matrix = new Matrix(r,c);
        for (var i:int = 0; i < r; i++) {
            for (var j:int = 0; j < c; j++) {
                idt.data[i][j] = (i == j)? 1: 0;
            }
        }
        return idt;
    }

    public static function Zero(r:int, c:int):Matrix {
        var zero:Matrix = new Matrix(r,c);
        for (var i:int = 0; i < r; i++) {
            for (var j:int = 0; j < c; j++) {
                zero.data[i][j] = 0;
            }
        }
        return zero;
    }

    public static function Flip2D(horizontal:Boolean, vertical:Boolean):Matrix {
        var m:Matrix = new Matrix(2,2);
        var h:int = horizontal? -1 : 1, v:int = vertical? -1 : 1;
        m.setRow(0,[h , 0]);
        m.setRow(1,[0 , v]);
        return m;
    }

    public static function Scale2D(factor:Number):Matrix {
        var m:Matrix = new Matrix(2,2);
        m.setRow(0,[factor,0]);
        m.setRow(1,[0,factor]);
        return m;
    }

    public static function Rotation2D(rad:Number):Matrix {
        var m:Matrix = new Matrix(2,2);
        var cos:Number = Math.cos(rad), sin:Number = Math.sin(rad);
        m.setRow(0,[cos, -sin]);
        m.setRow(1,[sin, cos]);
        return m;
    }

    public static function HorizontalShear2D(factor:Number):Matrix {
        var m:Matrix = new Matrix(2,2);
        m.setRow(0,[1,factor]);
        m.setRow(1,[0,1]);
        return m;
    }

    public static function VerticalShear2D(factor:Number):Matrix {
        var m:Matrix = new Matrix(2,2);
        m.setRow(0,[1,0]);
        m.setRow(1,[factor,1]);
        return m;
    }

    public static function SqueezeMapping2D(factor:Number):Matrix {
        var m:Matrix = new Matrix(2,2);
        m.setRow(0,[factor,0]);
        m.setRow(1,[0,1/factor]);
        return m;
    }
}
}
