/**
 * User: William
 */
package {

public class EventCM {

    //identifiers
    public var id                   :String = "";

    public var type                 :String = "";
    public var npc_ID               :String = "";
    public var store_ID             :String = "";

    public var isActive             :Boolean = false;

    //time
    public var start                :int = 0;
    public var duration             :int = 0;
    public var time_cost            :int = 0;

    //reconhecer, advertir, demitir
    public var correctIndex         :int = -1;
    public var tablePositive        :Array;
    public var tableNegative        :Array;

    //pdv alterar, novo, fechar
    public var store_demand         :int;
    public var store_competence     :Vector.<int>;
    public var store_description    :String;
    public var store_size           :String;
    public var store_lojaPerfeita   :Number;

    public var feedbacks            :Vector.<String>;

    public var message              :String;
    //popup
    public var messageButton        :String;
    public var messageTitle         :String;

    //noticia com botao
    public var nextEvent            :Vector.<EventCM> = null;

}
}
