<?php

if (!isset($_GET['msg'])) {
    header('Location: index.php');
} else {
    $msg = base64_decode($_GET['msg']);
}

?>
    <div class="well alert-error"><h4><?php echo '<pre>' . $msg . "</pre>"; ?></h4></div>
    <div class="well alert-error"><h4><?php echo "SERVER"; ?></h4></div>
    <div class="well alert-error"><h4><?php var_dump($_SERVER); ?></h4></div>
    <div class="well alert-error"><h4><?php echo "POST"; ?></h4></div>
    <div class="well alert-error"><h4><?php var_dump($_POST); ?></h4></div>
    <div class="well alert-error"><h4><?php echo "GET"; ?></h4></div>
    <div class="well alert-error"><h4><?php var_dump($_GET); ?></h4></div>

<?php
?>