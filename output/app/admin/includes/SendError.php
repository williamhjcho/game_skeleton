<?php
/**
 * Created by IntelliJ IDEA.
 * User: filiperp
 * Date: 04/07/13
 * Time: 15:11
 * To change this template use File | Settings | File Templates.
 */
require_once "Parameters.php";
class SendError {
    static function msg($msg){
        $d= Parameters::$domain;
        header("Location: $d/admin/error.php?msg=$msg");
    }
}