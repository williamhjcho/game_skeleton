<?php
/**
 * Created by IntelliJ IDEA.
 * User: filipe
 * Date: 17/06/13
 * Time: 13:05
 * To change this template use File | Settings | File Templates.
 */

require_once 'includes/functions.php';
require_once 'includes/connect.php';

if (isset($_POST['function'])) {

    $_POST['function']();
} else {
    echo "erro";
}


function removeMessage(){
    $id = $_POST['id'];
    $sql = "
       delete from  messages where id = $id";



    exec_SQLCommand($sql);

    $sql = "SELECT
              messages.id,
              messages.created,
              messages.publish,
               messages.tipo,
              messages.texto


            FROM
              messages
             WHERE tipo IN ('relatoriodiario','alerta' )
              ORDER BY created ASC";


    $response = exec_SQL($sql);
    if ($response["code"] == 0) {
        echo json_encode(exec_SQL($sql));
    }else{
        echo "ERRRRRO". mysql_error();

    }


}

function saveMessage(){

    $date = $_POST['date'];
    $tipo = $_POST['tipo'];
    $texto = $_POST['texto'];
    $id = $_POST['id'];
    $id = $id+0;


    if($id==0){
        $sql = "
        INSERT INTO
              `messages`
            (
              `id`,`users_id`,`id_registro`,`tabela`,`assunto`,`texto`,`destinatario`,`tipo`,`created`,`modified`,`publish`
            )
             VALUE(null,1,1,'','','$texto','','$tipo',now(),now(),'$date');";

    }else{
        $sql = "
       update
              messages set  publish = '$date', tipo = '$tipo', texto= '$texto' where id= $id";


    }


    exec_SQLCommand($sql);

    $sql = "SELECT
              messages.id,
              messages.created,
              messages.publish,
               messages.tipo,
              messages.texto


            FROM
              messages
             WHERE tipo IN ('relatoriodiario','alerta' )
              ORDER BY created ASC";


    $response = exec_SQL($sql);
    if ($response["code"] == 0) {
        echo json_encode(exec_SQL($sql));
    }else{
         echo "ERRRRRO". mysql_error();

    }



}


