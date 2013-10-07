<?php
/**
 * Created by IntelliJ IDEA.
 * User: filipe
 * Date: 04/06/13
 * Time: 22:35
 * To change this template use File | Settings | File Templates.
 */

require_once 'includes/functions.php';
require_once 'includes/connect.php';



$dados =  json_decode($_POST['dados']);


foreach ($dados as $key => $row) {
    $start= $row->start;
    $end=  $row->end;

    $sql = "
   update stages
   set start= '$start', end='$end'
    WHERE
       id=$key";
    $response = exec_SQLCommand($sql);
    $result[]=$sql;
}



echo  json_encode($result);

