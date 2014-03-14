/**
 * william.cho
 */
package utils.toollib {

public final class ToolString {

    public static function wordCount(s:String):int {
        if(s == null) return 0;
        return s.match(/\bw+\b/g).length;
    }

    public static function replaceExtraSpaces(s:String):String {
        return s.replace(/( )*/g," ");
    }

    public static function between(s:String, start:String, end:String):String {
        var r:String = "";
        if(s == null) return r;
        var i:int = s.indexOf(start);
        if(i != -1) {
            i += start.length;
            var j:int = s.indexOf(end, i);
            if(j != -1) r = s.substr(i, j - i);
        }
        return r;
    }

    public static function addPrefix(text:String, maxLength:uint, pattern:String = " "):String {
        while(text.length < maxLength) {
            text = pattern + text;
        }
        return text;
    }

    public static function addPostfix(text:String, maxLength:uint, pattern:String = " "):String {
        while(text.length < maxLength) {
            text += pattern;
        }
        return text;
    }

    public static function contains(s:String, match:String):Boolean {
        if(s == null) return false;
        return s.indexOf(match) != -1;
    }

    public static function isNumeric(s:String):Boolean {
        var r:RegExp = /^[+-]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
        return r.test(s);
    }

    public static function concatLeft(s:String, pattern:String, n:int):String {
        while(n-- > 0) { s = pattern + s; }
        return s;
    }

    public static function concatRight(s:String, pattern:String, n:int):String {
        while(n-- > 0) { s = s.concat(pattern); }
        return s;
    }

    public static function addQuotes(s:String, singleQuote:Boolean = false):String {
        var q:String = singleQuote ? "\'" : "\"";
        return q + s.concat(q);
    }

    public static function reverse(s:String):String {
        if(s == null) return null;
        return s.split("").reverse().join("");
    }

    public static function isPalindrome(txt:String):Boolean {
        if(txt.length <= 1) return true;
        var i:int = 0, j:int = txt.length - 1;
        while(i < j) {
            if(txt.charAt(i++) != txt.charAt(j--)) return false;
        }
        return true;
    }

    public static function repeatPattern(pattern:String,  repetition:int):String {
        var result:String = "";
        while(repetition-- > 0) { result = result.concat(pattern); }
        return result;
    }

    public static function verticalize(words:Vector.<String>):String {
        var output:String = "";
        var n:uint = words.length;
        var max:uint = 0;
        words.forEach(function(word:String, index:int, vect:Vector.<String>):void {
            max = Math.max(max, word.length);
        });

        for (var i:int = 0; i < max; i++) {
            for each (var word:String in words) {
                output += (i < word.length)? word.charAt(i) : " ";
            }
            output += "\n";
        }
        return output;
    }

    public static function replace(text:String, pattern:String, replacePattern:String):String {
        return text.replace(new RegExp(pattern),replacePattern);
    }

    public static function replaceAll(text:String, pattern:String, replacePattern:String):String {
        return text.replace(new RegExp(pattern,'g'),replacePattern);
    }

    public static function insert(text:String, insertText:String, index:int):String {
        return text.substring(0,index) + insertText + text.substring(index);
    }

    public static function remove(text:String, start:int, end:int):String {
        end = Math.max(start,end);
        return text.substring(0,start) + text.substring(end+1);
    }

    public static function extract_date(date:String, format:String, divisors:String = "\\-/:;=_ ", options:* = null):Object {
        //m -> number, M -> name
        //format : mm dd yy, arranged in any order, and yy can be yyyy
        //format : ex: mm/dd/yy MM T (01/01/01 January 2001)
        //setup patterns for extraction(they are defined as groups for extracting via regex)
        var dayPattern  :String = "(0[1-9]|[1-2][0-9]|3[0-1])"; //[30-31][10-29][01-09]
        var monthPattern:RegExp = /([^\-]0[1-9]|1[0-2])/;       //[01-09][10-12]
        var yearPattern :RegExp = /(\d{2}(\d{2})?)/;            //any number ranging from 2 digits OR 4 digits (doesn't accept 3)
        var weekDay     :RegExp = /(mon(day)?|tue(sday)?|wed(nesday)?|thu(rsday)?|fri(day)?|sat(urday)?|sun(day)?)/i;
        var monthName   :RegExp = /(jan(uary)?|feb(ruary)?|mar(ch)?|apr(il)?|may|jun(e)?|jul(y)?|aug(ust)?|sep(tember)?|oct(ober)?|nov(ember)?|dec(ember)?)/i;
        var time        :RegExp = /((([0-1][0-9])|(2[0-4])):([0-5][0-9]):([0-5][0-9]))/; //[00-24]:[00-59]:[00-59]

        var day:String = date.replace(new RegExp(".*?"+dayPattern+".*"),"$1"); trace(day);

        return {day:0,month:0,year:0};
    }


}
}
