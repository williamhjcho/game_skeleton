<?php
require_once Config::basePath() . "includes/Config.php";

header('Cache-Control: no-cache, must-revalidate');
header('Expires: Sat, 10 Apr 2007 23:30:00 GMT');


class DB
{
    public static $conn;

    private static function    connect()
    {
        if (!DB::$conn) {
            DB::$conn = mysql_connect(Config::$db_server, Config::$db_user, Config::$db_pass) or die('mysql_connect=DB_ERROR');
            mysql_select_db(Config::$db, DB::$conn) or die('mysql_select_db=DB_ERROR=> ' . Config::$db);

            mysql_query("SET NAMES 'utf8'");
            mysql_query('SET character_set_connection=utf8');
            mysql_query('SET character_set_client=utf8');
            mysql_query('SET character_set_results=utf8');
        }


//$conn=mysql_connect('localhost', 'root', '');
//if(!mysql_select_db("cetip",$conn)){echo ("Cannot select database.\n");}

    }

    static function exec_SQL($sql)
    {
        DB::connect();
        $r = mysql_query($sql);

        if (!$r) {
            echo(base64_encode("Erro de execução ($sql) DB: " . mysql_error()));
            die();

        }
        $lines = array();
        if (mysql_num_rows($r) == 0) {

            return $lines;
        }


        while ($l = mysql_fetch_assoc($r)) {
            $lines[] = $l;
        }

        return $lines;


    }

    static function exec_SQLRow($sql)
    {
        DB::connect();
        $r = mysql_query($sql);

        if (!$r) {
            echo(base64_encode("Erro de execução ($sql) DB: " . mysql_error()));
            die();
        }
        $lines = null;
        if (mysql_num_rows($r) > 0) {

            return mysql_fetch_assoc($r);
        }

        return null;


    }

    static function exec_SQLCommand($sql)
    {
        DB::connect();
        $r = mysql_query($sql);
        if (!$r) {
            echo(base64_encode("Erro de execução ($sql) DB: " . mysql_error()));
            die();
        }
        return 0;


    }

    static function saveObj($obj)
    {
        DB::connect();


    }
}


?>