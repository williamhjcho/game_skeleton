<?php
/**
 * Created by IntelliJ IDEA.
 * User: filipe
 * Date: 27/06/13
 * Time: 16:19
 * To change this template use File | Settings | File Templates.
 */

class Parameters
{
    static $db_server = 'localhost';
    static $db_user = 'root';
    static $db_pass = '';
    static $db = 'mon01';
    static $domain="/mon/mon01/game";

    //mail
    static $mailHost = '200.219.212.5';
    static $mailUserName = 'suporte@aennova.com.br';
    static $mailPassword = 'aen@2012';
    static $mailMailer = 'smtp';
    static $mailPort = 25;
    static $mailSMTPAuth = true;


    const SAVE_STATUS_OPEN ='aberto';
    const SAVE_STATUS_GAME_OVER ='gameover';
    const SAVE_STATUS_FINISHED = 'finalizado';


    const MODULE_STATUS_OPEN ='aberto';
    const MODULE_STATUS_EXPIRED ='expirado';
    const MODULE_STATUS_CLOSED ='fechado';


    const DEFAULT_USER= 'user1';
    const DEFAULT_PASS = 'senha1';
    const DEFAULT_HASH = 'hash';

}