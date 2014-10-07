<?php
/**
 * Created by IntelliJ IDEA.
 * User: filiperp
 * Date: 20/06/13
 * Time: 17:03
 * To change this template use File | Settings | File Templates.
 */
session_start();
$_SESSION['userID']= null;
session_destroy();
header('Location: login.php');

?>
