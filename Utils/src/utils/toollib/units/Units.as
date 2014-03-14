/**
 * Created with IntelliJ IDEA.
 * User: William
 * Date: 29/01/13
 * Time: 15:39
 * To change this template use File | Settings | File Templates.
 */
package utils.toollib.units {
import flash.utils.Dictionary;

public final class Units {

    public static var CELCIUS   :String = "CELCIUS"     ;
    public static var FAHRENHEIT:String = "FAHRENHEIT"  ;
    public static var KELVIN    :String = "KELVIN"      ;

    public static var INCH      :String = "INCH" ;
    public static var METER     :String = "METER";
    public static var FEET      :String = "FEET" ;
    public static var YARD      :String = "YARD" ;
    public static var KNOT      :String = "KNOT" ;
    public static var MILE      :String = "MILE" ;

    public static var SECOND    :String = "SECOND";
    public static var MINUTE    :String = "MINUTE";
    public static var HOUR      :String = "HOUR";
    public static var DAY       :String = "DAY";
    public static var YEAR      :String = "YEAR";
    public static var DECADE    :String = "DECADE";
    public static var CENTURY   :String = "CENTURY";
    public static var MILLENIUM :String = "MILLENIUM";

    public static const HEX_CHARS      :Dictionary = initializeHexCharacters();

    private static const unitGlossary     :Dictionary = initializeUnits();
    private static const prefixGlossary   :Dictionary = initializePrefixes();


    private static function initializeUnits():Dictionary {
        var units:Dictionary = new Dictionary();

        /** MIN = water's triple point, MAX = water's boiling point **/
        units[CELCIUS]       = [0,100];
        units[FAHRENHEIT]    = [32,212];
        units[KELVIN]        = [273.15,373.15];

        /** Everything has to be at the ISU(International System of Units)'s base **/
        /** All values are in METERS **/
        units[METER]     = 1;
        units[INCH]      = 39.3700787;
        units[FEET]      = 3.2808399;
        units[YARD]      = 1.0936133;
        units[KNOT]      = 0.000539956803;
        units[MILE]      = 0.000621371192;
        return units;
    }

    private static function initializePrefixes():Dictionary {
        var prefixes:Dictionary = new Dictionary();
        prefixes["yocto"] = prefixes["y"] = -24;
        prefixes["zepto"] = prefixes["z"] = -21;
        prefixes["atto" ] = prefixes["a"] = -18;
        prefixes["femto"] = prefixes["f"] = -15;
        prefixes["pico" ] = prefixes["p"] = -12;
        prefixes["nano" ] = prefixes["n"] = -9 ;
        prefixes["micro"] = prefixes["μ"] = -6 ;
        prefixes["mili" ] = prefixes["m"] = -3 ;
        prefixes["centi"] = prefixes["c"] = -2 ;
        prefixes["deci" ] = prefixes["d"] = -1 ;
        prefixes["default"] =  0 ;
        prefixes["deca" ] = prefixes["da"] =  1 ;
        prefixes["hecto"] = prefixes["h"] =  2 ;
        prefixes["kilo" ] = prefixes["k"] =  3 ;
        prefixes["mega" ] = prefixes["M"] =  6 ;
        prefixes["giga" ] = prefixes["G"] =  9 ;
        prefixes["tera" ] = prefixes["T"] =  12;
        prefixes["peta" ] = prefixes["P"] =  15;
        prefixes["exa"  ] = prefixes["E"] =  18;
        prefixes["zetta"] = prefixes["Z"] =  21;
        prefixes["yotta"] = prefixes["Y"] =  24;
        return prefixes;
    }

    private static function initializeHexCharacters():Dictionary {
        var hex:Dictionary = new Dictionary();
        hex['0'] = 0;               hex[ 0] = '0';
        hex['1'] = 1;               hex[ 1] = '1';
        hex['2'] = 2;               hex[ 2] = '2';
        hex['3'] = 3;               hex[ 3] = '3';
        hex['4'] = 4;               hex[ 4] = '4';
        hex['5'] = 5;               hex[ 5] = '5';
        hex['6'] = 6;               hex[ 6] = '6';
        hex['7'] = 7;               hex[ 7] = '7';
        hex['8'] = 8;               hex[ 8] = '8';
        hex['9'] = 9;               hex[ 9] = '9';
        hex['a'] = hex['A'] = 10;   hex[10] = 'A';
        hex['b'] = hex['B'] = 11;   hex[11] = 'B';
        hex['c'] = hex['C'] = 12;   hex[12] = 'C';
        hex['d'] = hex['D'] = 13;   hex[13] = 'D';
        hex['e'] = hex['E'] = 14;   hex[14] = 'E';
        hex['f'] = hex['F'] = 15;   hex[15] = 'F';
        return hex;
    }

    //==================================
    //  Core
    //==================================
    public static function addUnit(unit:String, value:Number):void {
        unit = getUnitKey(unit);
        if(unitExists(unit)) {
            //todo error msg
        } else {
            unitGlossary[unit] = value;
        }
    }

    public static function addTemperatureUnit(unit:String, minValue:Number, maxValue:Number):void {
        unit = getUnitKey(unit);
        if(unitExists(unit)) {
            //todo error msg
        } else {
            unitGlossary[unit] = [minValue,maxValue];
        }
    }

    public static function convertTo(value:Number, from:String = "meter", to:String = "inch"):Number {
        from = getUnitKey(from);
        to   = getUnitKey(to);

        if(!unitExists(from))   return -99999; //todo error msg
        if(!unitExists(to))     return -99999;

        var cf:Number = unitGlossary[from];
        var ct:Number = unitGlossary[to];

        return value * ct / cf;
    }

    public static function getPrefixValue(prefix:String):int {
        prefix = getPrefixKey(prefix);
        return prefixGlossary[prefix];
    }

    public static function getPrefixDifference(prefixFrom:String = "", prefixTo:String = "kilo"):Number {
        if(!prefixExists(prefixFrom))   return -99999; //todo error msg
        if(!prefixExists(prefixTo))     return -99999;
        return getPrefixValue(prefixTo) - getPrefixValue(prefixFrom);
    }

    public static function getTemperature(value:Number, from:String="CELCIUS", to:String="KELVIN"):Number {
        var minF:Number, maxF:Number; //from
        var minT:Number, maxT:Number; //to
        var tUnit:String;

        tUnit = getUnitKey(from);
        if(!unitExists(tUnit)) return -99999; //todo error msg
        minF = unitGlossary[tUnit][0];
        maxF = unitGlossary[tUnit][1];

        tUnit = getUnitKey(to);
        if(!unitExists(tUnit)) return -99999; //todo error msg
        minT = unitGlossary[tUnit][0];
        maxT = unitGlossary[tUnit][1];

        return minT + ((value - minF) * (maxT - minT) / (maxF - minF));
    }

    public static function hasUnit(unit:String):Boolean {
        unit = getUnitKey(unit);
        return unitExists(unit);
    }

    public static function hasPrefix(prefix:String):Boolean {
        prefix = getPrefixKey(prefix);
        return prefixExists(prefix);
    }


    //==================================
    //  Private
    //==================================
    private static function getUnitKey(unit:String):String {
        return unit.toUpperCase();
    }

    private static function getPrefixKey(prefix:String = ""):String {
        return (prefix == "") ? "default" : prefix.toLowerCase();
    }

    private static function unitExists(unit:String):Boolean {
        return (unitGlossary[unit] != null && unitGlossary[unit] != undefined);
    }

    private static function prefixExists(prefix:String):Boolean {
        return (prefixGlossary[prefix] != null && prefixGlossary[prefix] != undefined);

    }


    //==================================
    //  Constants
    //==================================
    public static const BERNOULLI:Vector.<Number> = new <Number>[
        1
        ,-1/2
        ,1/6                                                                                        ,0
        ,-1/30                                                                                      ,0
        ,1/42                                                                                       ,0
        ,-1/30                                                                                      ,0
        ,5/66                                                                                       ,0
        ,-691/2730                                                                                  ,0
        ,7/6                                                                                        ,0
        ,-3617/510                                                                                  ,0
        ,43867/798                                                                                  ,0
        ,-174611/330                                                                                ,0
        ,854513/138                                                                                 ,0
        ,-236364091/2730                                                                            ,0
        ,8553103/6                                                                                  ,0
        ,-23749461029/870                                                                           ,0
        ,8615841276005/14322                                                                        ,0
        ,-7709321041217/510                                                                         ,0
        ,2577687858367/6                                                                            ,0
        ,-26315271553053477373/1919190                                                              ,0
        ,2929993913841559/6                                                                         ,0
        ,-261082718496449122051/13530                                                               ,0
        ,1520097643918070802691/1806                                                                ,0
        ,-27833269579301024235023/690                                                               ,0
        ,596451111593912163277961/282                                                               ,0
        ,-5609403368997817686249127547/46410                                                        ,0
        ,495057205241079648212477525/66                                                             ,0
        ,-801165718135489957347924991853/1590                                                       ,0
        ,29149963634884862421418123812691/798                                                       ,0
        ,-2479392929313226753685415739663229/870                                                    ,0
        ,84483613348880041862046775994036021/354                                                    ,0
        ,-1215233140483755572040304994079820246041491/56786730                                      ,0
        ,12300585434086858541953039857403386151/6                                                   ,0
        ,-106783830147866529886385444979142647942017/510                                           ,0
        ,1472600022126335654051619428551932342241899101/64722                                      ,0
        ,-78773130858718728141909149208474606244347001/30                                          ,0
        ,1505381347333367003803076567377857208511438160235/4686                                   ,0
        ,-5827954961669944110438277244641067365282488301844260429/140100870                        ,0
        ,34152417289221168014330073731472635186688307783087/6                                      ,0
        ,-24655088825935372707687196040585199904365267828865801/30                                 ,0
        ,414846365575400828295179035549542073492199375372400483487/3318                            ,0
        ,-4603784299479457646935574969019046849794257872751288919656867/230010                     ,0
        ,1677014149185145836823154509786269900207736027570253414881613/498                         ,0
        ,-2024576195935290360231131160111731009989917391198090877281083932477/3404310              ,0
        ,660714619417678653573847847426261496277830686653388931761996983/6                         ,0
        ,-1311426488674017507995511424019311843345750275572028644296919890574047/61410             ,0
        ,1179057279021082799884123351249215083775254949669647116231545215727922535/ 272118         ,0
        ,-1295585948207537527989427828538576749659341483719435143023316326829946247/1410           ,0
        ,1220813806579744469607301679413201203958508415202696621436215105284649447/6               ,0
        ,-211600449597266513097597728109824233673043954389060234150638733420050668349987259/4501770,0
        ,67908260672905495624051117546403605607342195728504487509073961249992947058239/6           ,0
        ,-94598037819122125295227433069493721872702841533066936133385696204311395415197247711/33330,0
    ];
}
}
