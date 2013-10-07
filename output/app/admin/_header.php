<?php
/**
 * Created by IntelliJ IDEA.
 * User: filiperp
 * Date: 03/06/13
 * Time: 14:51
 * To change this template use File | Settings | File Templates.
 */

//if(!isset($_SESSION)){
// session_start();
//}

require_once 'includes/auth.php';
require_once 'includes/Functions.php';
require_once 'includes/DB.php';


?>

<!DOCTYPE html>
<!--[if lt IE 7]>
<html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>
<html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>
<html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="no-js"> <!--<![endif]-->
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title></title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width">

    <link rel="stylesheet" href="css/bootstrap.min.css">
    <style>
        body {
            padding-top: 60px;
            padding-bottom: 40px;
        }

    </style>
    <link rel="stylesheet" href="css/bootstrap-responsive.min.css">
    <link rel="stylesheet" href="css/dropdown.css">
    <link rel="stylesheet" href="css/bootstrap-modal.css"/>
    <link rel="stylesheet" href="css/bootstrap-datetimepicker.min.css"/>
    <link rel="stylesheet" href="css/watable.css"/>
    <link rel="stylesheet" href="css/main.css">

    <script src="js/vendor/modernizr-2.6.2-respond-1.1.0.min.js"></script>
    <script src="js/vendor/jquery-1.9.1.min.js"></script>
    <script src="js/vendor/bootstrap.min.js"></script>

    <script src="js/moment.js"></script>
    <script src="js/date.js"></script>
    <script src="js/bootstrap-modalmanager.js"></script>
    <script src="js/bootstrap-modal.js"></script>
    <script src="js/bootstrap-datetimepicker.min.js"></script>
    <script src="js/jquery.watable.js"></script>

</head>
<body>


<?php require_once "_menu.php"; ?>

<script type="text/javascript">

    $(".collapse").collapse();
</script>

<div class="container">
    <div class="row">

