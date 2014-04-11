/**
 * Created by William on 4/1/14.
 */
package utils.misc.creditCard {
import utils.toollib.ToolMath;

public class CreditCardValidator {

    public static function isValid(card:String):Boolean {
        return  (getMajorIndustryIdentifier(card) != null) &&
                (getIssuerIdentificationNumber(card) != null) &&
                (checksum(card) % 10 == 0);
    }

    public static function getMajorIndustryIdentifier(card:String):String {
        card = clearCardNumber(card);
        if(card == null) return null;
        switch(card.charAt(0)) {
            case '1':
            case '2': return MajorIndustryIdentifier.AIRLINES;
            case '3': return MajorIndustryIdentifier.TRAVEL_ENTERTAINMENT;
            case '4':
            case '5': return MajorIndustryIdentifier.BANKING_FINANCIAL;
            case '6': return MajorIndustryIdentifier.MERCHANDIZING_BANKING;
            case '7': return MajorIndustryIdentifier.PETROLEUM;
            case '8': return MajorIndustryIdentifier.TELECOMMUNICATIONS;
            case '9': return MajorIndustryIdentifier.NATIONAL_ASSIGNMENT;
            default: return null;
        }
    }

    public static function getIssuerIdentificationNumber(card:String):String {
        card = clearCardNumber(card);
        for each (var provider:String in IssuerIdentificationNumber.LIST) {
            var range:Array = CardRanges[provider];
            for each (var r:Array in range) {
                var start:int = r[0];
                var end:int = (r.length > 1) ? r[1] : start;
                for (var i:int = start; i <= end; i++) {
                    if(new RegExp("^" + r[0]).test(card))
                        return provider;
                }
            }
        }
        return null;
    }

    public static function checksumDigit(card:String):int {
        card = clearCardNumber(card);
        if(card.length < 7) return -1;
        return int(card.charAt(card.length - 1));
    }

    public static function checksum(card:String):int {
        card = clearCardNumber(card);
        if(card.length < 7) return -1;
        var sum:int = 0;
        for (var i:int = 0; i < 16; i++) {
            var digit:int = int(card.charAt(i));
            sum += (i % 2 == 0)? ToolMath.sumDigits(digit * 2) : digit;
        }
        return sum;
    }

    public static function clearCardNumber(card:String):String {
        return card.replace(/[ -,._]/g, "").replace(/\D/g,"");
    }

}
}

class CardRanges {
    public static const AMERICAN_EXPRESS:Array = [
        [34],
        [37]
    ];

    public static const CHINA_UNIONPAY:Array = [
        [62],
        [88]
    ];

    public static const DINERS_CLUB_CARTE_BLANCHE:Array = [
        [300,305]
    ];

    public static const DINERS_CLUB_INTERNATIONAL:Array = [
        [300,305],
        [309],
        [36],
        [38,39]
    ];

    public static const DINERS_CLUB:Array = [
        [54],
        [55]
    ];

    public static const DISCOVER_CARD:Array = [
        [6001],
        [622126,622925],
        [644,649],
        [65]
    ];

    public static const JCB:Array = [
        [3528,3589]
    ];

    public static const LASER:Array = [
        [6304,6706,6771,6709]
    ];

    public static const MAESTRO:Array = [
        [5018],
        [5020],
        [5038],
        [5612],
        [5893],
        [6304],
        [6759],
        [6761],
        [6762],
        [6763],
        [0604],
        [6390]
    ];

    public static const DANKORT:Array = [
        [5019]
    ];

    public static const MASTERCARD:Array = [
        [50,55]
    ];

    public static const VISA:Array = [
        [4]
    ];

    public static const VISA_ELECTRON:Array = [
        [4026],
        [417500],
        [4405],
        [4508],
        [4844],
        [4913],
        [4917]
    ];
}
