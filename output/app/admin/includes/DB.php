<?php
 require_once "SendError.php";
require_once "Parameters.php";

header('Cache-Control: no-cache, must-revalidate');
header('Expires: Sat, 10 Apr 2007 23:30:00 GMT');


class DB
{
    public static $conn;

    private static function    connect()
    {
        if (!DB::$conn) {
            DB::$conn = mysql_connect(Parameters::$db_server, Parameters::$db_user, Parameters::$db_pass) or die('mysql_connect=DB_ERROR');
            mysql_select_db(Parameters::$db, DB::$conn) or die('mysql_select_db=DB_ERROR=> '.Parameters::$db);

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
             SendError::msg(base64_encode("Erro de execução ($sql) DB: " . mysql_error()));

        }
        $lines = array();
        if (mysql_num_rows($r) == 0) {

            return  $lines;
        }


        while ($l = mysql_fetch_assoc($r)) {
            $lines[] = $l;
        }

        return   $lines;


    }

    static function exec_SQLRow($sql)
    {
        DB::connect();
        $r = mysql_query($sql);

        if (!$r) {
            SendError::msg(base64_encode("Erro de execução ($sql) DB: " . mysql_error()));
        }
        $lines =null;
        if (mysql_num_rows($r) > 0) {

            return  mysql_fetch_assoc($r);
        }

        return  null;


    }

    static function exec_SQLCommand($sql)
    {
        DB::connect();
        $r = mysql_query($sql);
        if (!$r) {
            SendError::msg(base64_encode("Erro de execução ($sql) DB: " . mysql_error()));
        }
        return 0;


    }
}


?>