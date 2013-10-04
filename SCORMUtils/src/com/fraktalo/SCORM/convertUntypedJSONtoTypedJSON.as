/**
 * Created with IntelliJ IDEA.
 * User: filipe
 * Date: 08/02/13
 * Time: 17:09
 * To change this template use File | Settings | File Templates.
 */
package com.fraktalo.SCORM {
import com.fraktalo.SCORM.vo.CMI;
import com.fraktalo.SCORM.vo.Objective;
import com.fraktalo.SCORM.vo.Score;

import utils.managers.serializer.SerializerManager;

public  function convertUntypedJSONtoTypedJSON(field : String) : String {


    var obj : Object = SerializerManager.JSONparse(field);
    var cmi:CMI =  new CMI();
    //Core
    cmi.core.student_id = obj["core"]["student_id"];
    cmi.core.student_name = obj["core"]["student_name"];
    cmi.core.lesson_location = obj["core"]["lesson_location"];
    cmi.core.lesson_status = obj["core"]["lesson_status"];
    cmi.core.total_time = obj["core"]["total_time"];
    cmi.core.score.max = obj["core"]["score"]["max"];
    cmi.core.score.raw = obj["core"]["score"]["raw"];
    cmi.core.score.min = obj["core"]["score"]["min"];
    //SuspendData
    cmi.suspend_data = obj["suspend_data"];
    //Comments
    cmi.comments = obj["comments"];

    //Objectives
    var arrObjs : Array = obj["objectives"];
    var arrObjective : Array = new Array();

    for (var i : int = 0;i < arrObjs.length;i++) {
        var objective : Objective = new Objective();
        objective.id = arrObjs[i]["id"];

        var scoreObj : Score = new Score();
        scoreObj.max = arrObjs[i]["score"]["max"];
        scoreObj.raw = arrObjs[i]["score"]["raw"];
        scoreObj.min = arrObjs[i]["score"]["min"];
        objective.score = scoreObj;

        objective.status = arrObjs[i]["status"];

        arrObjective[i] = objective;
    }

    cmi.objectives = arrObjective;
    var o:Object = SerializerManager.encode(cmi);
    return SerializerManager.JSONstringfy(o);

}

}
