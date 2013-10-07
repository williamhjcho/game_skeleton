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


function saveAnswer()
{

    $id = $_POST['id'];
    $answer = $_POST['answer'];


    $sql = "UPDATE messages SET answered=1 WHERE id = $id";
    exec_SQLCommand($sql);

    $response = exec_SQLCommand($sql);


    $sql = " SELECT * FROM messages WHERE id = $id";

    $response = exec_SQLRow($sql);


    if ($response["code"] == 0) {
        $res = $response['result'];
        $resUser = $res['users_id'];
        $resTipo = $res['tipo'];
        $sqlInsert = "INSERT INTO `messages`
        (`id`,`users_id`,`id_registro`,`tabela`,`assunto`,`texto`,`destinatario`,`tipo`,`created`,`modified`,`publish`,`parent_id`,`answered`)
        VALUE(null,1,$id,'','resposta','$answer',$resUser,'$resTipo',now(),now(),now(),$id,1);";
        exec_SQLCommand($sqlInsert);

        $sql = " SELECT * FROM users WHERE id = $resUser";

        $responseEmail = exec_SQLRow($sql);
        if ($responseEmail["code"] == 0) {
            $resEmail = $responseEmail['result'];
            sendMailAdmin('[suporte] - Nova Mensagem',$answer ,$resEmail['login'],$resEmail['nickname']);

        }

    } else {
        echo "ERRRRRO" . mysql_error();

    }


}


