<?php
require_once "SendError.php";
$usersAdm = array(
    'teste'=> 'teste',
    'aennova'=> 'secreto2013#$'
);
session_start();
$_SESSION['userID'] = "teste";
if (!isset($_SESSION['userID'])) {
    if(!isset($_POST['login']) ||!isset($_POST['password']) ) {

        header("Location: login.php?msg=errorLogin");
    } else{
        $leUser = $_POST['login'];
        $lePass = $_POST['password'];
        if(isset($usersAdm[$leUser])){
            if($usersAdm[$leUser]==$lePass){
                $_SESSION['userID']=  'aennova' ;
            }else{
                header("Location: login.php?msg=errorAuth");


            }
        }else{
            header("Location: login.php?msg=errorAuth");
        }
    }
}




?>
