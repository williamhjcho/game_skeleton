/**
 * Created by William on 4/1/14.
 */
package utils.misc.creditCard {
public class IssuerIdentificationNumber {

    public static const AMERICAN_EXPRESS          :String = "AMERICAN_EXPRESS"         ;
    public static const CHINA_UNIONPAY            :String = "CHINA_UNIONPAY"           ;
    public static const DINERS_CLUB_CARTE_BLANCHE :String = "DINERS_CLUB_CARTE_BLANCHE";
    public static const DINERS_CLUB_INTERNATIONAL :String = "DINERS_CLUB_INTERNATIONAL";
    public static const DINERS_CLUB               :String = "DINERS_CLUB"              ;
    public static const DISCOVER_CARD             :String = "DISCOVER_CARD"            ;
    public static const JCB                       :String = "JCB"                      ;
    public static const LASER                     :String = "LASER"                    ;
    public static const MAESTRO                   :String = "MAESTRO"                  ;
    public static const DANKORT                   :String = "DANKORT"                  ;
    public static const MASTERCARD                :String = "MASTERCARD"               ;
    public static const VISA                      :String = "VISA"                     ;
    public static const VISA_ELECTRON             :String = "VISA_ELECTRON"            ;

    internal static const LIST:Vector.<String> = new <String>[
        AMERICAN_EXPRESS         ,
        CHINA_UNIONPAY           ,
        DINERS_CLUB_CARTE_BLANCHE,
        DINERS_CLUB_INTERNATIONAL,
        DINERS_CLUB              ,
        DISCOVER_CARD            ,
        JCB                      ,
        LASER                    ,
        MAESTRO                  ,
        DANKORT                  ,
        MASTERCARD               ,
        VISA                     ,
        VISA_ELECTRON
    ];
}
}
