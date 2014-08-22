/**
 * Created by William on 6/13/2014.
 */
package utils.event {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import utils.commands.execute;

/**
 *
 */
public class EventController {

    private var pProperties:Dictionary = new Dictionary();

    public function EventController() {
    }

    //==================================
    //  Public
    //==================================
    public function addActivate                       (target:EventDispatcher, listener:Function):void { add(target, listener, Event.ACTIVATE);                       }
    public function addAdded                          (target:EventDispatcher, listener:Function):void { add(target, listener, Event.ADDED);                          }
    public function addAdded_to_stage                 (target:EventDispatcher, listener:Function):void { add(target, listener, Event.ADDED_TO_STAGE);                 }
    public function addCancel                         (target:EventDispatcher, listener:Function):void { add(target, listener, Event.CANCEL);                         }
    public function addChange                         (target:EventDispatcher, listener:Function):void { add(target, listener, Event.CHANGE);                         }
    public function addClear                          (target:EventDispatcher, listener:Function):void { add(target, listener, Event.CLEAR);                          }
    public function addClose                          (target:EventDispatcher, listener:Function):void { add(target, listener, Event.CLOSE);                          }
    public function addComplete                       (target:EventDispatcher, listener:Function):void { add(target, listener, Event.COMPLETE);                       }
    public function addConnect                        (target:EventDispatcher, listener:Function):void { add(target, listener, Event.CONNECT);                        }
    public function addCopy                           (target:EventDispatcher, listener:Function):void { add(target, listener, Event.COPY);                           }
    public function addCut                            (target:EventDispatcher, listener:Function):void { add(target, listener, Event.CUT);                            }
    public function addDeactivate                     (target:EventDispatcher, listener:Function):void { add(target, listener, Event.DEACTIVATE);                     }
    public function addEnter_frame                    (target:EventDispatcher, listener:Function):void { add(target, listener, Event.ENTER_FRAME);                    }
    public function addFrame_constructed              (target:EventDispatcher, listener:Function):void { add(target, listener, Event.FRAME_CONSTRUCTED);              }
    public function addExit_frame                     (target:EventDispatcher, listener:Function):void { add(target, listener, Event.EXIT_FRAME);                     }
    public function addId3                            (target:EventDispatcher, listener:Function):void { add(target, listener, Event.ID3);                            }
    public function addInit                           (target:EventDispatcher, listener:Function):void { add(target, listener, Event.INIT);                           }
    public function addMouse_leave                    (target:EventDispatcher, listener:Function):void { add(target, listener, Event.MOUSE_LEAVE);                    }
    public function addOpen                           (target:EventDispatcher, listener:Function):void { add(target, listener, Event.OPEN);                           }
    public function addPaste                          (target:EventDispatcher, listener:Function):void { add(target, listener, Event.PASTE);                          }
    public function addRemoved                        (target:EventDispatcher, listener:Function):void { add(target, listener, Event.REMOVED);                        }
    public function addRemoved_from_stage             (target:EventDispatcher, listener:Function):void { add(target, listener, Event.REMOVED_FROM_STAGE);             }
    public function addRender                         (target:EventDispatcher, listener:Function):void { add(target, listener, Event.RENDER);                         }
    public function addResize                         (target:EventDispatcher, listener:Function):void { add(target, listener, Event.RESIZE);                         }
    public function addScroll                         (target:EventDispatcher, listener:Function):void { add(target, listener, Event.SCROLL);                         }
    public function addText_interaction_mode_change   (target:EventDispatcher, listener:Function):void { add(target, listener, Event.TEXT_INTERACTION_MODE_CHANGE);   }
    public function addSelect                         (target:EventDispatcher, listener:Function):void { add(target, listener, Event.SELECT);                         }
    public function addSelect_all                     (target:EventDispatcher, listener:Function):void { add(target, listener, Event.SELECT_ALL);                     }
    public function addSound_complete                 (target:EventDispatcher, listener:Function):void { add(target, listener, Event.SOUND_COMPLETE);                 }
    public function addTab_children_change            (target:EventDispatcher, listener:Function):void { add(target, listener, Event.TAB_CHILDREN_CHANGE);            }
    public function addTab_enabled_change             (target:EventDispatcher, listener:Function):void { add(target, listener, Event.TAB_ENABLED_CHANGE);             }
    public function addTab_index_change               (target:EventDispatcher, listener:Function):void { add(target, listener, Event.TAB_INDEX_CHANGE);               }
    public function addUnload                         (target:EventDispatcher, listener:Function):void { add(target, listener, Event.UNLOAD);                         }
    public function addFullscreen                     (target:EventDispatcher, listener:Function):void { add(target, listener, Event.FULLSCREEN);                     }

    public function removeActivate                       (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.ACTIVATE);                       }
    public function removeAdded                          (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.ADDED);                          }
    public function removeAdded_to_stage                 (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.ADDED_TO_STAGE);                 }
    public function removeCancel                         (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.CANCEL);                         }
    public function removeChange                         (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.CHANGE);                         }
    public function removeClear                          (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.CLEAR);                          }
    public function removeClose                          (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.CLOSE);                          }
    public function removeComplete                       (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.COMPLETE);                       }
    public function removeConnect                        (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.CONNECT);                        }
    public function removeCopy                           (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.COPY);                           }
    public function removeCut                            (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.CUT);                            }
    public function removeDeactivate                     (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.DEACTIVATE);                     }
    public function removeEnter_frame                    (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.ENTER_FRAME);                    }
    public function removeFrame_constructed              (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.FRAME_CONSTRUCTED);              }
    public function removeExit_frame                     (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.EXIT_FRAME);                     }
    public function removeId3                            (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.ID3);                            }
    public function removeInit                           (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.INIT);                           }
    public function removeMouse_leave                    (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.MOUSE_LEAVE);                    }
    public function removeOpen                           (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.OPEN);                           }
    public function removePaste                          (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.PASTE);                          }
    public function removeRemoved                        (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.REMOVED);                        }
    public function removeRemoved_from_stage             (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.REMOVED_FROM_STAGE);             }
    public function removeRender                         (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.RENDER);                         }
    public function removeResize                         (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.RESIZE);                         }
    public function removeScroll                         (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.SCROLL);                         }
    public function removeText_interaction_mode_change   (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.TEXT_INTERACTION_MODE_CHANGE);   }
    public function removeSelect                         (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.SELECT);                         }
    public function removeSelect_all                     (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.SELECT_ALL);                     }
    public function removeSound_complete                 (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.SOUND_COMPLETE);                 }
    public function removeTab_children_change            (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.TAB_CHILDREN_CHANGE);            }
    public function removeTab_enabled_change             (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.TAB_ENABLED_CHANGE);             }
    public function removeTab_index_change               (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.TAB_INDEX_CHANGE);               }
    public function removeUnload                         (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.UNLOAD);                         }
    public function removeFullscreen                     (target:EventDispatcher, listener:Function):void { remove(target, listener, Event.FULLSCREEN);                     }

    public function add(target:EventDispatcher, listener:Function, type:String, useCapture:Boolean = false, priority:uint = 0, useWeakReference:Boolean = false):void {
        if(listener == null) throw new ArgumentError("Listener cannot be null.");
        if(type == null) throw new ArgumentError("Type cannot be null.");

        var etp:EventTargetProperty = (pProperties[target] ||= new EventTargetProperty());
        etp.add(type, listener);
        target.addEventListener(type, onEvent, useCapture, priority, useWeakReference);
    }

    public function remove(target:EventDispatcher, listener:Function, type:String):void {
        if(listener == null) throw new ArgumentError("Listener cannot be null.");
        var etp:EventTargetProperty = pProperties[target];
        if(etp == null) return; //target was never added before
        var v:Vector.<Function> = etp.getFunctions(type);
        if(v != null && v.length <= 1) { //removing the event only if there is no other listener to it
            target.removeEventListener(type, onEvent);
        }
        etp.remove(type, listener);
    }

    public function removeType(target:EventDispatcher, type:String):void {
        if(target == null) throw new ArgumentError("Target cannot be null.");
        var etp:EventTargetProperty = pProperties[target];
        if(etp == null) return; //target was never added before
        etp.removeType(type);
        target.removeEventListener(type, onEvent);
    }

    public function removeAllFrom(target:EventDispatcher):void {
        if(target == null) throw new ArgumentError("Target cannot be null.");
        var etp:EventTargetProperty = pProperties[target];
        if(etp == null) return; //target was never added before
        var v:Vector.<String> = etp.allTypes;
        for each (var type:String in v) { //removing all known types associated to this target
            target.removeEventListener(type, onEvent);
        }
        etp.removeAll();
        delete pProperties[target];
    }

    public function isEnabled(target:EventDispatcher):Boolean {
        return pProperties[target] == null? false : EventTargetProperty(pProperties[target]).enabled;
    }

    public function enable (target:EventDispatcher):void { setEnabled(target, true); }
    public function disable(target:EventDispatcher):void { setEnabled(target, false); }
    public function setEnabled(target:EventDispatcher, status:Boolean):void {
        if(pProperties[target] != null)
            EventTargetProperty(pProperties[target]).enabled = status;
    }

    public function contains(target:EventDispatcher):Boolean { return target in pProperties; }

    //==================================
    //  Private
    //==================================
    private function onEvent(e:Event):void {
        var eventType:String = e.type;
        var target:EventDispatcher = e.currentTarget as EventDispatcher;
        var etp:EventTargetProperty = pProperties[target];
        if(!etp.enabled) return;

        var v:Vector.<Function> = etp.getFunctions(eventType);
        var p:Array = [e];

        var len:int = v.length;
        var currentIndex:int = 0;
        for (var i:int = 0; i < len; i++) {
            if(v[i] != null) {
                if(currentIndex != i) {
                    v[currentIndex] = v[i];
                    v[i] = null;
                }

                execute(v[i], p);
                currentIndex++;
            }
        }

        if(currentIndex != i) {
            len = v.length;
            while(i < len) {
                v[currentIndex++] = v[i++];
            }
            v.length = currentIndex;
        }

    }

    //==================================
    //  Protected
    //==================================


}
}

class EventTargetProperty {

    public var enabled:Boolean = true;
    public var functions:Object = {};

    public function add(type:String, f:Function):void {
        var v:Vector.<Function> = (functions[type] ||= new Vector.<Function>);
        if(v.indexOf(f) == -1)
            v.push(f);
    }

    public function remove(type:String, f:Function):void {
        var v:Vector.<Function> = functions[type];
        if(v != null) {
            var index:int = v.indexOf(f);
            if(index != -1)
                v[index] = null;
        }
    }

    public function removeType(type:String):void {
        delete functions[type];
    }

    public function removeAll():void {
        for (var type:String in functions) {
            delete functions[type];
        }
    }

    public function getFunctions(type:String):Vector.<Function> {
        return functions[type];
    }

    public function get allTypes():Vector.<String> {
        var v:Vector.<String> = new Vector.<String>();
        for (var type:String in functions) {
            v.push(type);
        }
        return v;
    }

    public function destroy():void {
        functions = {};
    }

}