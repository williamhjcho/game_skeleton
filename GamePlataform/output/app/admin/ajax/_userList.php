<?php
/**
 * Created by IntelliJ IDEA.
 * User: filiperp
 * Date: 04/07/13
 * Time: 15:01
 * To change this template use File | Settings | File Templates.
 */
require_once "_headerAjax.php";

function listUsers()
{
    $sql = "SELECT
          usuario.id,
          usuario.nome,
          usuario.email,
          usuario.cpf,
          usuario.login,
          COALESCE( jogadas.contador,0) AS qtdJogadas,
          COALESCE(finalizados.contador,0) AS finalizados
        FROM
          usuario
          LEFT OUTER JOIN ( SELECT usuario, count(id) AS contador
                            FROM savegame ) AS jogadas ON (usuario.id = jogadas.usuario)

          LEFT OUTER JOIN ( SELECT usuario, count(id) AS contador
                            FROM savegame
                            WHERE status ='gameover' ) AS finalizados ON (usuario.id = finalizados.usuario) ";
    $result = DB::exec_SQL($sql);

    echo json_encode($result);
    die();
}



function findUser()
{
    $id = $_POST['id'];
    $sql = "select  *  from usuario  where id=$id";
    $result = DB::exec_SQLRow($sql);

    echo json_encode($result);
    die();
}

function updateUser()
{
    $obj = json_decode($_POST['data']);

    DB::exec_SQLCommand("
                        UPDATE usuario
                        SET
                          nome='$obj->content_nome',
                          email='" . $obj->content_email . "',
                          cpf='" . $obj->content_cpf . "',
                          login='" . $obj->content_login . "',
                          senha='" . $obj->content_senha . "'
                        WHERE
                           id=" . $obj->content_id);
    $id = $obj->content_id;
    $sql = "select *  from usuario  where id=$id";
    $result = DB::exec_SQLRow($sql);

    echo json_encode($result);
    die();
}


function insertUser()
{
    $obj = json_decode($_POST['data']);

    DB::exec_SQLCommand("
                 INSERT INTO usuario(
                      id,nome,email,cpf,login,senha)
                 VALUE(
                 null,
                 '$obj->content_nome',
                 '$obj->content_email',
                 '$obj->content_cpf',
                 '$obj->content_login',
                 '$obj->content_senha'); ");

    echo json_encode($obj);
    die();
}

