var isDebugging = true;
function debug (msg){
	if(isDebugging){
		document.getElementById("debugText").value += "-------------------------------------------\n";
		document.getElementById("debugText").value +=  msg + "\n";
	}
}
function init() {
	
	startSCO();		
}

function commit(){
	computeTime();
	doLMSCommit();
	thisWrapper().commited();
}

function exit() {
	closeSCO();
	thisWrapper().terminated();
}

// Auxiliar JSON para caracteres especiais
/*
 * function urlencode(str) { str = escape(str); str = str.replace('+', '%2B');
 * str = str.replace('%20', '+'); str = str.replace('*', '%2A'); str =
 * str.replace('/', '%2F'); str = str.replace('@', '%40'); return str; }
 * 
 * function urldecode(str) { str = str.replace('+', ' '); str = unescape(str);
 * return str; }
 */
	
// General auxiliary functions
function getQuery() {
	var query = new QueryObject(location.search);
	return query;
}

function quit() {
	self.close();
}

function isSCORM() {
	return _isSCORM;
}

function initialize(){
	debug("initialize");
	init();
	
	var cmi = new Cmi();

	 startTimer();
	var srlzd = classyJSON.stringify(cmi);
	debug(" out initialized srlzd: "+srlzd);
	// alert(srlzd);
	debug(" out initialized thisWrapper(): "+thisWrapper());
	//thisWrapper().initialized(srlzd);
	var swf = thisWrapper();
	debug(swf);
	
	//swf.terminated();
	
	swf.initialized(srlzd);
	
	// thisWrapper().initialized("oiiii");
	
}

// SCORM auxiliary functions
function startSCO() {
	debug("startSCO");
	var result = doLMSInitialize();
	var status = doLMSGetValue("cmi.core.lesson_status");
	debug("startSCO status: "+ status);
	if (status == "not attempted") {

		setCoreLessonStatus("incomplete");

		doLMSSetValue("cmi.core.lesson_location", "");

	}
	exitPageStatus = false;
	debug("out startSCO");
}

function closeSCO() {
	debug("closeSCO  ");
	exitPageStatus = true;
	doLMSCommit();
	doLMSSetValue("cmi.core.exit", "");
	doLMSFinish();
	debug("out closeSCO  ");
}

function completeSCO() {
	debug("completeSCO  ");
	var status = doLMSGetValue("cmi.core.lesson_status");
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao completar o SCO.");
	} else if (status != "completed") {
		setCoreLessonStatus("completed");
		doLMSCommit();
	}
	debug("out completeSCO  ");
}

// set value LMS
function setAll(value){
	debug("setAll value: "+ value);
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro no set CMI - 'auxfn.js'."); 
		return "";
	}
	
	doLMSSetValue(field, value);
	debug("out setAll value: "+ value);
}

function setCoreLessonLocation(value) {
	debug("setCoreLessonLocation value: "+ value);
	var data = String(value);
	if (data.length<=256) {
		doLMSSetValue("cmi.core.lesson_location", data);
	}
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao gravar a posição.");
	}
	debug("out setCoreLessonLocation data: "+ data);
}

function setCoreLessonStatus(value) {
	debug("setCoreLessonStatus value: "+ value);
	var data = String(value);
	if ((data=="browsed") || (data=="failed" )||( data=="not attempted" )||( data=="incomplete" )||( data=="completed")||( data=="passed")) {

		doLMSSetValue("cmi.core.lesson_status", data);
	}else{
		alert("valor do LessonStatus errado:" + data); 
	}
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao recuperar o status."); 
		return "";
	}
	debug(" out setCoreLessonStatus data: "+ data);
}

function setCoreScoreRaw(score) {
	debug("setCoreScoreRaw score: "+ String(parseInt(score)));
	if ((parseInt(score) >= 0 && parseInt(score) <= 100)) {
		doLMSSetValue("cmi.core.score.raw", String(parseInt(score)));	
	}
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao gravar a nota.");
	}
	debug("out setCoreScoreRaw score: "+ score);
}

function setCoreScoreMax(score) {
	debug("setCoreScoreMax score: "+ score);
	if ((parseInt(score) >= 0 && parseInt(score) <= 100)) {
		doLMSSetValue("cmi.core.score.max", String(score));	
	}
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao gravar a nota maxima.");
	}
	debug("out setCoreScoreMax score: "+ score);
}

function setCoreScoreMin(score) {
	debug("setCoreScoreMin score: "+ score);
	if ((parseInt(score) >= 0 && parseInt(score) <= 100)) {
		doLMSSetValue("cmi.core.score.min", String(score));	
	}
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao gravar a nota minima.");
	}
	debug("out setCoreScoreMin score: "+ score);
}

function setCoreSessionTime(score) {
	debug("setCoreSessionTime score: "+ score);
	doLMSSetValue("cmi.core.session_time", score);	
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao gravar o session time.");
	}
	debug("out setCoreSessionTime score: "+ score);
}

function setCoreSuspendData(score) {
	debug("setCoreSuspendData score: "+ score);
	var data = String(score);
	if(data.length<=4096){
		doLMSSetValue("cmi.suspend_data", data);
	}
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao gravar o suspend data.");
	}
	debug("out setCoreSuspendData score: "+ score);
}

function setCoreComments(score) {
	debug("setCoreComments score: "+ score);
	var data = String(score);
	// alert("score comments: "+ data);
	if(data.length<=4096){
		// doLMSSetValue("cmi.comments", "asdasdaasd");
		// doLMSSetValue("cmi.comments", data);
	}
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao gravar o comentário.");
	}
	debug("out setCoreComments score: "+ score);
}

function setCoreObjectiveId(value, _id) {
	debug("setCoreObjectiveId value: "+ value + " / id: "+ _id);
	var objective = String(value);
	var id = String(_id);
	doLMSSetValue("cmi.objectives."+objective+".id", id);
	
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao gravar o Objetivo Id.");
	}
	debug("out setCoreObjectiveId value: "+ value + " / id: "+ _id);
}

function setCoreObjectiveScoreMax(value, _max) {
	debug("setCoreObjectiveScoreMax value: "+ value + " / _max: "+ _max);
	var objective = String(value);
	var max = String(_max);
	
	doLMSSetValue("cmi.objectives."+objective+".score.max", max);
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao gravar o Objetivo Score Max.");
	}
	debug("out setCoreObjectiveScoreMax value: "+ value + " / _max: "+ _max);
}

function setCoreObjectiveScoreMin(value, _min) {
	debug("setCoreObjectiveScoreMin value: "+ value + " / _min: "+ _min);
	var objective = String(value);
	var min = String(_min);
	
	doLMSSetValue("cmi.objectives."+objective+".score.min", min);
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao gravar o Objetivo Score Min.");
	}
	debug("out setCoreObjectiveScoreMin value: "+ value + " / _min: "+ _min);
}

function setCoreObjectiveScoreRaw(value, _raw) {
	debug("setCoreObjectiveScoreMin value: "+ value + " / _raw: "+ _raw);
	var objective = String(value);
	var raw = String(_raw);
	
	doLMSSetValue("cmi.objectives."+objective+".score.raw", raw);
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao gravar o Objetivo Score Raw.");
	}
	debug("out setCoreObjectiveScoreMin value: "+ value + " / _raw: "+ _raw);
}

function setCoreObjectiveStatus(value, _status) {
	debug("setCoreObjectiveStatus value: "+ value + " / _status: "+ _status);
	var objective = String(value);
	var status = String(_status);
	
	if(status != "")doLMSSetValue("cmi.objectives."+objective+".status", status);
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao gravar o Objetivo Score Status.");
	}
	debug("out setCoreObjectiveStatus value: "+ value + " / _status: "+ _status);
}

function setCoreSaveGameVars(score) {
	debug("setCoreSaveGameVars score: "+ score );
	var data = String(score);
	if(data.length<=4096){
		doLMSSetValue("cmi.suspend_data", data);
	}
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao gravar o suspend data Game Vars.");
	}
	
	thisWrapper().setCoreSaveGameVarsJs(data);
	debug("out setCoreSaveGameVars score: "+ score );
}

// get´s value LMS
function Cmi(){		
	debug("Cmi " );
	// Core
	this.core = new Core();
	// suspendData
	this.suspend_data = doLMSGetValue("cmi.suspend_data");
	// Comments
	this.comments = doLMSGetValue("cmi.comments");
	// Objectives
	var arrObjectives = new Array();
	if(doLMSGetValue("cmi.objectives._count")>0){	
		for(i=0; i< doLMSGetValue("cmi.objectives._count"); i++){
			arrObjectives[i] = new Objectives(i);
		}
	}
	
	this.objectives = arrObjectives;
	debug("out Cmi" + this );
}
	
function Core(){
	debug("core " );
	// StudentId
	this.student_id = doLMSGetValue("cmi.core.student_id");
	// StudentName
	this.student_name = doLMSGetValue("cmi.core.student_name");
	// LessonLocation
	this.lesson_location = doLMSGetValue("cmi.core.lesson_location");
	// LessonStatus
	this.lesson_status = doLMSGetValue("cmi.core.lesson_status");
	// TotalTime
	this.total_time = doLMSGetValue("cmi.core.total_time");
	// score
	this.score = new Score();
	debug("out core: "+ this );
}

function Score(){
	debug("Score " );
	this.max = doLMSGetValue("cmi.core.score.max");
	this.raw = doLMSGetValue("cmi.core.score.raw");
	this.min = doLMSGetValue("cmi.core.score.min");
	debug("out Score " );
}

function ScoreObj(field){
	debug("ScoreObj field:  " + field );
	this.max = doLMSGetValue("cmi.objectives."+field+".score.max");
	this.raw = doLMSGetValue("cmi.objectives."+field+".score.raw");
	this.min = doLMSGetValue("cmi.objectives."+field+".score.min");
	debug("out ScoreObj field:  " + field );
	
}

function Objectives(field){
	debug("Objectives field:  " + field );
	// Id
	this.id = doLMSGetValue("cmi.objectives."+field+".id");
	// Score
	this.score = new ScoreObj(field);
	// Status
	this.status = doLMSGetValue("cmi.objectives."+field+".status");
	debug("out Objectives field:  " + field );
}

function getCoreSaveGameVars() {
	debug("getCoreSaveGameVars" );
	startSCO();
	var data = doLMSGetValue("cmi.suspend_data");
	if (doLMSGetLastError() != "0") {
		alert("Ocorreu um erro ao carregar o suspend data Game Vars.");
	}
	thisWrapper().getCoreSaveGameVarsJs(data);
	debug("out getCoreSaveGameVars" );
}

// Movie a receber o callBack
function thisMovie(movieName) {
	debug("thisMovie movieName: "+ movieName );
    if (navigator.appName.indexOf("Microsoft") != -1) {
        return window[movieName];
    } else {
        return document.getElementById(movieName);
    }
    debug("out thisMovie movieName: "+ movieName );
}

function thisWrapper() {
	debug("thisWrapper" );
	/*
	if (window.document["main"]) {
		return window.document["main"];
	}
	if (navigator.appName.indexOf("Microsoft Internet")==-1){
		if (document.embeds && document.embeds["main"])
			return document.embeds["main"]; 
		}else{
			return document.getElementById("main");
	}*/
	

	return $("#main").get(0);
}
// DEBUG alert
function debugAlert(value){
	alert("DEBUG --> "+value);
}
