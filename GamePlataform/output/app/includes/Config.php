<?php
/**
 * Created by IntelliJ IDEA.
 * User: filipe
 * Date: 27/06/13
 * Time: 16:19
 * To change this template use File | Settings | File Templates.
 */

class Config
{
    static $db_server = 'localhost';
    static $db_user = 'root';
    static $db_pass = 'mysql';
    static $db = 'glc01';
    static $baseDeployFolderName="gameskeleton";

    static function basePath (){
        $absolute_path = __FILE__;
        $path_to_file = explode(Config::$baseDeployFolderName, $absolute_path );
        return $path_to_file[0]. Config::$baseDeployFolderName. "/";
    }

    //mail
    static $mailHost = '200.219.212.5';
    static $mailUserName = 'suporte@aennova.com.br';
    static $mailPassword = 'aen@2012';
    static $mailMailer = 'smtp';
    static $mailPort = 25;
    static $mailSMTPAuth = true;




}