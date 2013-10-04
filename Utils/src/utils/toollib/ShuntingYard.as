/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 9/20/13
 * Time: 2:41 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib {
import flash.utils.Dictionary;

public class ShuntingYard {

    private static const LEFT:int = 0;
    private static const RIGHT:int = 1;
    private static var OPERATORS:Dictionary = generateOperators();
    public static const SYNTAX_BREAKERS:Vector.<String> = new <String>[' ','\t','\n'];

    private static function generateOperators():Dictionary {
        var d:Dictionary = new Dictionary();
        d['+'] = [0 ,LEFT];
        d['-'] = [0 ,LEFT];
        d['*'] = [5 ,LEFT];
        d['/'] = [5 ,LEFT];
        d['%'] = [5 ,LEFT];
        d['^'] = [10,RIGHT];
        d['='] = [0 ,RIGHT];
        return d;
    }

    /**  **/
    public static function isOperator(token:String):Boolean {
        return (OPERATORS[token] != null) && (OPERATORS[token] != undefined);
    }

    public static function isAssociativeTo(token:String, associativity:int):Boolean {
        if(!isOperator(token)) return false;
        return OPERATORS[token][1] == associativity;
    }

    public static function comparePrecedence(token1:String, token2:String):int {
        if(!isOperator(token1) || !isOperator(token2)) throw new Error("Invalid operators: \""+token1 + "\", \""+token2+"\".");
        return OPERATORS[token1][0] - OPERATORS[token2][0];
    }

    /** **/
    public static function tokenize(expression:String):Vector.<String> {
        var tokens:Vector.<String> = new Vector.<String>();
        var i:int = 0;
        var token:String = "", ch:String;

        while(i < expression.length) {
            ch = expression.charAt(i);
            if(SYNTAX_BREAKERS.indexOf(ch) != -1) {
                if(token != "") {
                    tokens.push(token);
                    token = "";
                }
            } else if(isOperator(ch) || ch == '(' || ch == ')') {
                if(token != "") {
                    tokens.push(token);
                    token = "";
                }
                tokens.push(ch);
            } else {
                if(isOperator(token)) {
                    tokens.push(token);
                    token = "";
                }
                token += ch;
            }
            i++;
        }
        if(token != "")
            tokens.push(token);

        return tokens;
    }

    public static function toRPN(tokens:*):Vector.<String> {
        var output:Vector.<String> = new Vector.<String>();
        var stack:Vector.<String> = new Vector.<String>();

        for each (var token:String in tokens) {
            if(isOperator(token)) {
                while(stack.length > 0 && isOperator(stack[stack.length-1])) {
                    if(isAssociativeTo(token, LEFT) && comparePrecedence(token, stack[stack.length-1]) <= 0 || (isAssociativeTo(token, RIGHT) && comparePrecedence(token, stack[stack.length-1]) < 0)) {
                        output.push(stack.pop());
                        continue;
                    }
                    break;
                }
                stack.push(token);
            } else if(token == "(") {
                stack.push(token);
            } else if(token == ")") {
                while(stack.length > 0 && stack[stack.length-1] != '(') {
                    output.push(stack.pop());
                }
                stack.pop();
            } else {
                output.push(token);
            }
        }

        while(stack.length > 0) output.push(stack.pop());

        return output;
    }

    public static function solveRPN(rpn:*):Number {
        var stack:Vector.<Number> = new Vector.<Number>();
        for each (var token:String in rpn) {
            if(isOperator(token)) {
                var a:Number = stack.pop(), b:Number = stack.pop();
                switch (token) {
                    case '+': stack.push(a + b); break;
                    case '-': stack.push(a - b); break;
                    case '*': stack.push(a * b); break;
                    case '/': stack.push(b / a); break;
                    case '%': stack.push(b % a); break;
                    case '^': stack.push(Math.pow(a,b)); break;
                    case '=':
                }
            } else {
                stack.push(Number(token));
            }
        }
        return stack.pop();
    }
}
}
