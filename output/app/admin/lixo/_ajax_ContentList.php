<?php
/**
 * Created by IntelliJ IDEA.
 * User: filipe
 * Date: 04/06/13
 * Time: 16:05
 * To change this template use File | Settings | File Templates.
 */

require_once 'includes/functions.php';
require_once 'includes/connect.php';

if (isset($_POST['function'])) {

    $_POST['function']();
} else {
    echo "erro";
}

function searchUser(){
    $value = $_POST['argument'];
    $sql = "
      select id, login, nickname from users where login like '%$value%' or nickname like '%$value%'";

    $response = exec_SQL($sql);
    $row['data'] = "";
    $row['count'] =0;

    if ($response["code"] == 0) {

        $row['data'] = $response["result"];
        $row['count'] = count($response["result"]);





    }  else{
        echo mysql_error();
    }
    echo json_encode($row );
}

function ratingContent()
{
    $id = $_POST['id'];
    $value = $_POST['value'];
    $elementID = $_POST['elementID'];
    $theValue = $value == -1 ? "NULL" : $value;

    $sql = "
       UPDATE content
       SET content.rating= $theValue
        WHERE
           id=$id";

    $response = exec_SQLCommand($sql);

    echo json_encode(array(
        'elementID' => $elementID,
        'result' => $response['code'] == 0 ? true : false,
        'value' => $value,
        'id' => $id
    ));


}

function editComment()
{
    $id = $_POST['id'];

    $elementID = $_POST['elementID'];


    $sql = "
      SELECT  id,text, created
      FROM commentes
        WHERE
           id=$id";

    $response = exec_SQLRow($sql);

    if ($response["code"] == 0) {
        $row = $response["result"];
        echo json_encode(array(
            'elementID' => $elementID,
            'result' => $response['code'] == 0 ? true : false,
            "text" => $row['text'],
            "id" => $row['id'],
            "created" => $row['created'],
            'id' => $id
        ));


    }
}


function editContent()
{
    $id = $_POST['id'];

    $elementID = $_POST['elementID'];


    $sql = "
      SELECT  id,title,text, date_publish, evaluationText
      FROM content
        WHERE
           id=$id";

    $response = exec_SQLRow($sql);

    if ($response["code"] == 0) {
        $row = $response["result"];
        echo json_encode(array(
            'elementID' => $elementID,
            'result' => $response['code'] == 0 ? true : false,
            "title" => $row['title'],
            "text" => $row['text'],
            "id" => $row['id'],
            "date_publish" => $row['date_publish'],
            "evaluation_text" => $row['evaluationText'],
            'id' => $id
        ));


    }
}

function saveEditContent()
{
    $id = $_POST['id'];
    $elementID = $_POST['elementID'];
    $title = $_POST['title'];
    $text = $_POST['text'];
    $date_publish = $_POST['date_publish'];
    $evaluationText = $_POST['evaluationText'];


    $sql = "
        UPDATE content
        SET
        title ='$title',
        text= '$text',
        date_publish = '$date_publish',
        evaluationText = '$evaluationText'

        WHERE
           id=$id";

    $response = exec_SQLCommand($sql);
    editContent();

}

function saveEditComment()
{
    $id = $_POST['id'];
    $elementID = $_POST['elementID'];
    $text = $_POST['text'];
    $created = $_POST['created'];


    $sql = "
        UPDATE commentes
        SET

        text= '$text',
        created = '$created'

        WHERE
           id=$id";

    $response = exec_SQLCommand($sql);
    editComment();

}


function hideContent()
{

    $id = $_POST['id'];
    $value = $_POST['value'];
    $elementID = $_POST['elementID'];
    $theValue = $value == -1 ? "NULL" : $value;

    $del_request = "";

    $sql = "
            SELECT
              content.id,
              content.status, delete_request
            FROM
              content

            WHERE
               content.id= $id;";


    $response = exec_SQL($sql);
    if ($response["code"] == 0) {
        foreach ($response["result"] as $key => $row) {
            $value = intval($row['status']);
            $del_request = intval($row['delete_request']);
        }
    }


    if ($value == 1) {

        $sql = "    UPDATE content SET status=0, delete_request=0 WHERE id=$id;  ";
        exec_SQLCommand($sql);
        $sql = "    UPDATE actions_users SET old_value = value WHERE id_content=$id AND value <> 0;  ";
        exec_SQLCommand($sql);
        $sql = "   UPDATE actions_users SET value = 0 WHERE id_content=$id;  ";
        exec_SQLCommand($sql);


        $value = 0;

    } else {
        $sql = "   UPDATE content SET status=1 WHERE id=$id;  ";
        exec_SQLCommand($sql);
        $sql = "   UPDATE actions_users SET value = old_value   WHERE id_content=$id AND old_value <> 0 ;   ";
        exec_SQLCommand($sql);
        $sql = "  UPDATE actions_users SET old_value = 0 WHERE id_content=$id;   ";
        exec_SQLCommand($sql);


        $value = 1;
    }


    $sql = "
            SELECT
              content.id,
              content.status, delete_request
            FROM
              content

            WHERE
               content.id= $id;";


    $response = exec_SQL($sql);
    if ($response["code"] == 0) {
        foreach ($response["result"] as $key => $row) {
            $value = intval($row['status']);
            $del_request = intval($row['delete_request']);
        }
    }


    echo json_encode(array(
        'elementID' => $elementID,
        'result' => $response['code'] == 0 ? true : false,
        'value' => $value,
        'delete_request' => $del_request,
        'id' => $id
    ));
}

function hideComment()
{

    $id = $_POST['id'];
    $value = $_POST['value'];
    $elementID = $_POST['elementID'];
    $theValue = $value == -1 ? "NULL" : $value;
    $del_request = '';

    $sql = "
            SELECT
              commentes.id,
              commentes.status,
              commentes.delete_request
            FROM
              commentes

            WHERE
               commentes.id= $id;";


    $response = exec_SQL($sql);
    if ($response["code"] == 0) {
        foreach ($response["result"] as $key => $row) {
            $value = intval($row['status']);
            $del_request = intval($row['delete_request']);
        }
    }


    if ($value == 1) {

        $sql = "   UPDATE commentes SET status=0, delete_request=0 WHERE id  =$id;  ";
        exec_SQLCommand($sql);
        $sql = "  UPDATE actions_users SET old_value = value WHERE id_commentes=$id AND value <> 0;   ";
        exec_SQLCommand($sql);
        $sql = "   UPDATE actions_users SET value = 0 WHERE id_commentes=$id;  ";
        exec_SQLCommand($sql);


        $response = exec_SQLCommand($sql);
    } else {

        $sql = "  UPDATE commentes SET status=1 WHERE id  =$id;   ";
        exec_SQLCommand($sql);
        $sql = "   UPDATE actions_users SET value= old_value WHERE id_commentes=$id AND old_value <> 0;     ";
        exec_SQLCommand($sql);
        $sql = "   UPDATE actions_users SET value = 0 WHERE id_commentes=$id;   ";
        exec_SQLCommand($sql);


        $response = exec_SQLCommand($sql);
    }

    $sql = "
            SELECT
              commentes.id,
              commentes.status,
              commentes.delete_request
            FROM
              commentes

            WHERE
               commentes.id= $id;";
    $response = exec_SQL($sql);
    if ($response["code"] == 0) {
        foreach ($response["result"] as $key => $row) {
            $value = intval($row['status']);
            $del_request = intval($row['delete_request']);
        }
    }


    echo json_encode(array(
        'elementID' => $elementID,
        'result' => $response['code'] == 0 ? true : false,
        'value' => $value,
        'delete_request' => $del_request,
        'id' => $id
    ));
}


function evaluationContent()
{
    $id = $_POST['id'];
    $value = $_POST['value'];
    $elementID = $_POST['elementID'];
    $theValue = $value == -1 ? "NULL" : $value;

    $sql = "
       UPDATE content
       SET content.evaluation= $theValue
        WHERE
           id=$id";

    $response = exec_SQLCommand($sql);

    echo json_encode(array(
        'elementID' => $elementID,
        'result' => $response['code'] == 0 ? true : false,
        'value' => $value,
        'id' => $id
    ));


}


function evaluationComment()
{
    $id = $_POST['id'];
    $value = $_POST['value'];
    $elementID = $_POST['elementID'];
    $theValue = $value == -1 ? "NULL" : $value;

    $sql = "
       UPDATE commentes
       SET commentes.evaluation= $theValue
        WHERE
           id=$id";

    $response = exec_SQLCommand($sql);

    echo json_encode(array(
        'elementID' => $elementID,
        'result' => $response['code'] == 0 ? true : false,
        'value' => $value,
        'id' => $id
    ));
}
