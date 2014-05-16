/**
 * Created by William on 5/16/2014.
 */
package utils.commands {
/**
 * AS3's function constructor manipulation is NON-EXISTENT, this is the only workaround to that problem
 * @param cls class to be instantiated
 * @param parameters parameters to the constructor
 * @return instantiated object
 */
public function executeConstructor(cls:Class, parameters:Array):* {
    if(cls == null) return null;
    if(parameters == null) return new cls();
    switch(parameters.length) {
        case 0: return new cls();
        case 1: return new cls(parameters[0]);
        case 2: return new cls(parameters[0],parameters[1]);
        case 3: return new cls(parameters[0],parameters[1],parameters[2]);
        case 4: return new cls(parameters[0],parameters[1],parameters[2],parameters[3]);
        case 5: return new cls(parameters[0],parameters[1],parameters[2],parameters[3],parameters[4]);
        case 6: return new cls(parameters[0],parameters[1],parameters[2],parameters[3],parameters[4],parameters[5]);
    }
}
}
