<?php
/**
 * Created by IntelliJ IDEA.
 * User: filiperp
 * Date: 19/07/13
 * Time: 16:53
 * To change this template use File | Settings | File Templates.
 */

require_once "../includes/Parameters.php";
require_once "../includes/auth.php";
require_once "../includes/DB.php";
require_once "../includes/Functions.php";
require_once "../includes/SendError.php";

if (isset($_POST['function'])) {

    $_POST['function']();
} else {

    echo SendError::msg('Erro ap executar a função ajax: ');
}
