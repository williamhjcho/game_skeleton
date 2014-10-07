<?php
/**
 * Created by IntelliJ IDEA.
 * User: filiperp
 * Date: 20/01/14
 *
 * Time: 17:43
 */

require_once "includes/Config.php";
require_once "includes/DB.php";


//echo Config::basePath();

$obj = DB::exec_SQL("select * from usuarios where id=1");

$vars = new StdClass();

$vars->nome = "filipe";
$vars->idade = "fiiiiilipe";
$vars->sexo = "sssssssfilipe";
 trace( $vars->nome);
trace(is_object($vars)?"sim": "false");

foreach($vars as $key => $value) {
    trace( "$key => $value\n");
}

$v2['nome']= 'filipe2';
$v2['idade']= 'filipiiiiiie2';
$v2['sexi']= 'filipasdfadfadfe2';
trace($v2['nome']);

foreach($v2 as $key => $value) {
    trace( "$key => $value\n");
}
trace(is_object($v2)?"sim": "false");




function trace($m){
    echo $m .  "\n";
}