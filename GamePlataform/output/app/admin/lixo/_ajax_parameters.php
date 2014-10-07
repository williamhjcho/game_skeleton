<?php
/**
 * Created by IntelliJ IDEA.
 * User: filipe
 * Date: 18/06/13
 * Time: 18:47
 * To change this template use File | Settings | File Templates.
 */


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


function saveParameter(){
  /*  'function':'saveParameter',
                    'param': $(this).data('param'),
                    'value':$("#editParam_"+$(this).data('param')).val()   */

   $param= $_POST['param'];
    $value= $_POST['value'];

    $sql =  "update parameters set value= '$value' where name = '$param'";

    exec_SQLCommand($sql);
     echo $sql;
    die();

        echo 'OK';

}




?>