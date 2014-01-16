/**
 * Created with IntelliJ IDEA.
 * User: williamwc
 * Date: 2/3/13
 * Time: 12:10 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.managers.crypto {
public class Enigma {

    private static const staticWheel:Array =
    [
        "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","Y","X","Z",
        "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","y","x","z",
        "0","1","2","3","4","5","6","7","8","9",
        " ","!","?",".",",",";",":","+","-","*","/","_","[","]","(",")","'",'"',"@","#","$","%","&","="
    ];
    private static var initialRotorPositions:Array;
    private static var rotors               :Array;
    private static var plugboard            :Array;
    private static var step                 :int;

    private static var isInitialized:Boolean;

    public function Enigma() {
        /** Order of encryption
        > press key
        > rotate rotors by 1 'step'
        > check plug board
        > go through static wheel (used only to check the entrance point)
        > go through adjacent rotors
        > reflect current (reverse wheel order)
        > go through adjacent wheels (reversed order)
        > check plug board
        > display character
        **/
    }

    public static function initialize(n:int=1):Boolean {
        step = 1;
        rotors = []; plugboard = []; initialRotorPositions = [];
        for (var i:int = 0; i < n; i++) {
            var rotor:EnigmaRotor = new EnigmaRotor();
            rotors.push(rotor);
            initialRotorPositions.push(0);
        }
        return true;
    }

    public static function encode(msg:String):String {
        var encodedMsg:String = "";
        for (var c:int = 0; c < msg.length; c++) {
            var chr:String = msg.charAt(c);        //trace("start",chr);
            var idx:int = -1;
            rotateRotors(step);
            chr = checkPlugboard       (chr);     //trace("plug",chr,idx);
            idx = checkStaticRotor     (chr);     //trace("stat",chr,idx);
            idx = checkRotors          (idx);     //trace("roto",chr,idx);
            idx = checkReflector       (idx);     //trace("refl",chr,idx);
            idx = checkRotorsReversed  (idx);     //trace("rotR",chr,idx);
            chr = checkStaticRotor     (idx);     //trace("stat",chr,idx);
            chr = checkPlugboard       (chr);     //trace("plug",chr,idx);
            encodedMsg += chr;
        }
        return encodedMsg;
    }

    public static function decode(msg:String):String {
        var decodedMsg:String = "";
        for (var c:int = 0; c < msg.length; c++) {
            var chr:String = msg.charAt(c);        //trace("start",chr);
            var idx:int = -1;
            rotateRotors(step);
            chr = checkPlugboard       (chr);     //trace("plug",chr,idx);
            idx = checkStaticRotor     (chr);     //trace("stat",chr,idx);
            idx = checkRotors          (idx);     //trace("roto",chr,idx);
            idx = checkReflectorInv    (idx);     //trace("refl",chr,idx);
            idx = checkRotorsReversed  (idx);     //trace("rotR",chr,idx);
            chr = checkStaticRotor     (idx);     //trace("stat",chr,idx);
            chr = checkPlugboard       (chr);     //trace("plug",chr,idx);
            decodedMsg += chr;
        }
        return decodedMsg;
    }



    /** CORE    **/
    private static function rotateRotors(step:int):void {
        //shift positions
        for each(var rotor:EnigmaRotor in rotors) {
            if(!rotor.rotate(step)) {
                return;
            }
        }
    }

    private static function checkPlugboard(char:String):String {
        for each(var connection:Array in plugboard) {
            if(connection[0] == char)       return connection[1];
            else if(connection[1] == char)  return connection[0];
        }
        return char;
    }

    private static function checkStaticRotor(input:*):* {
        return (input is String)? staticWheel.indexOf(input) : staticWheel[input];
    }

    private static function checkRotors(inputIdx:int):int {
        for each(var rotor:EnigmaRotor in rotors) {
            inputIdx = rotor.getOutput(inputIdx);
        }
        return inputIdx;
    }

    private static function checkReflector(inputIdx:int):int {
        inputIdx += staticWheel.length/2;
        inputIdx = (inputIdx >= staticWheel.length) ? inputIdx - staticWheel.length : inputIdx;
        return inputIdx;
    }

    private static function checkReflectorInv(inputIdx:int):int {
        inputIdx -= staticWheel.length/2;
        inputIdx = (inputIdx < 0) ? inputIdx + staticWheel.length : inputIdx;
        return inputIdx;
    }

    private static function checkRotorsReversed(inputIdx:int):int {
        for (var i:int = rotors.length-1; i >= 0; i--) {
            var rotor:EnigmaRotor = rotors[i];
            inputIdx = rotor.getOutputInv(inputIdx);
        }
        return inputIdx;
    }


    /** PUBLIC ACCESS   **/
    public static function setInitialSettings(settings:Array):void {
        plugboard               = settings[0];
        rotors                  = settings[1];
        initialRotorPositions   = settings[2];

        for (var i:int = 0; i < rotors.length; i++) {
            var rotor:EnigmaRotor = rotors[i];
            rotor.rotateTo(initialRotorPositions[i]);
        }
    }

    public static function getInitialSettings():Array {
        //[plugboard, rotors, rotor positions]
        var settings:Array = [plugboard, rotors, initialRotorPositions];
        return settings;
    }

    public static function setRotorPositions(positions:Array):void {
        setInitialSettings([plugboard,rotors,positions]);
    }

    public static function getValidCharacters():Array {
        return staticWheel;
    }
}
}

