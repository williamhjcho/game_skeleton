<?php
require_once "_header.php";

$stage = isset($_GET['stage']) ? $_GET['stage'] : 1;
$orderBy = ($stage == 3) ? " order by 14;" : " order by 1;";
$filterBy = isset($_GET['filter']) ? $_GET['filter'] : 'all';
$searchArgument = isset($_GET['search']) ? $_GET['search'] : '';


//SQL SELECTOR

$filterDesc = "
AND ( ( content.id IN (SELECT content.id
                                              FROM   content
                                                     INNER JOIN content_commentes
                                                             ON ( content.id = content_commentes.content_id )
                                                     INNER JOIN commentes
                                                             ON ( content_commentes.commentes_id = commentes.id )
                                              WHERE  ( ( commentes.text LIKE '%$searchArgument%' )
                                                        OR ( commentes.users_id IN (SELECT id
                                                                                    FROM   users
                                                                                    WHERE  ( ( users.login LIKE '%$searchArgument%' )
                                                                                              OR ( users.nickname LIKE '%$searchArgument%' ) )) ) )) )
                              OR ( content.id IN(SELECT content.id
                                                 FROM   content
                                                 WHERE  content.users_id IN (SELECT id
                                                                             FROM   users
                                                                             WHERE  ( ( users.login LIKE '%$searchArgument%' )
                                                                                       OR ( users.nickname LIKE '%$searchArgument%' ) ))) )
                              OR ( content.title LIKE '%$searchArgument%' )
                              OR ( content.description LIKE '%$searchArgument%' )
                              OR ( content.evaluationtext LIKE '%$searchArgument%' )
                              OR ( content.text LIKE '%$searchArgument%' ) ) ";
$sqlBase = "SELECT DISTINCT  content.id,
                   content.date_publish,
                   content.users_id,
                   content.title,
                   content.subtitle,
                   content.description,
                   content.evaluationText,
                   content.text,
                   COALESCE(content.rating, -1)            AS rating,
                   COALESCE(content.evaluation, -1)        AS evaluation,
                   content.delete_request,
                   users.nickname,
                   content.status,
                   COALESCE(content.parent_id, content.id) AS ordem,
                   content.parent_id
            FROM   content
                   LEFT OUTER JOIN users
                                ON ( content.users_id = users.id )
            WHERE  content.content_type_id = $stage ";


switch ($filterBy) {
    case 'null':
        $texto = 'Não Avaliados';
        $sql = $sqlBase . "

                        AND ( content.id IN (SELECT content.id
                                                 FROM   content
                                                        INNER JOIN content_commentes
                                                                ON ( content.id = content_commentes.content_id )
                                                        INNER JOIN commentes
                                                                ON ( content_commentes.commentes_id = commentes.id )
                                                 WHERE  commentes.evaluation IS NULL)
                                   OR content.evaluation IS NULL ) ";

        break;
    case '0':

        $texto = 'Avaliados com 0';
        $sql = $sqlBase . "

                        AND ( content.id IN (SELECT content.id
                                                 FROM   content
                                                        INNER JOIN content_commentes
                                                                ON ( content.id = content_commentes.content_id )
                                                        INNER JOIN commentes
                                                                ON ( content_commentes.commentes_id = commentes.id )
                                                 WHERE  commentes.evaluation = 0)
                                   OR content.evaluation = 0 ) ";
        break;
    case '1':
        $texto = 'Avaliados com 1';
        $sql = $sqlBase . "

                        AND ( content.id IN (SELECT content.id
                                                 FROM   content
                                                        INNER JOIN content_commentes
                                                                ON ( content.id = content_commentes.content_id )
                                                        INNER JOIN commentes
                                                                ON ( content_commentes.commentes_id = commentes.id )
                                                 WHERE  commentes.evaluation = 1)
                                   OR content.evaluation = 1 ) ";
        break;
    case '2':
        $texto = 'Notas maiores que 1 ';
        $sql = $sqlBase . "

                        AND ( content.id IN (SELECT content.id
                                                 FROM   content
                                                        INNER JOIN content_commentes
                                                                ON ( content.id = content_commentes.content_id )
                                                        INNER JOIN commentes
                                                                ON ( content_commentes.commentes_id = commentes.id )
                                                 WHERE  commentes.evaluation > 1)
                                   OR content.evaluation > 1) ";
        break;


        break;
    case 'search':
        $texto = "Pesquisando por:'$searchArgument'";
        $searchArgument = intval($searchArgument);
        if ($stage != 3) {
            $sql = $sqlBase . "
                           AND ( ( content.id IN (SELECT content.id
                                                  FROM   content
                                                         INNER JOIN content_commentes
                                                                 ON ( content.id = content_commentes.content_id )
                                                         INNER JOIN commentes
                                                                 ON ( content_commentes.commentes_id = commentes.id )
                                                  WHERE  ( commentes.users_id = $searchArgument )) )
                                  OR ( content.id IN(SELECT content.id
                                                     FROM   content
                                                     WHERE  content.users_id = $searchArgument) ) )

                                 ";
        } else {
            $sql = $sqlBase . "
                           AND ( ( content.id IN (SELECT content.id
                                                  FROM   content
                                                         INNER JOIN content_commentes
                                                                 ON ( content.id = content_commentes.content_id )
                                                         INNER JOIN commentes
                                                                 ON ( content_commentes.commentes_id = commentes.id )
                                                  WHERE  ( commentes.users_id = $searchArgument )

                                                  union all

                                                  SELECT content.parent_id
                                                  FROM   content
                                                         INNER JOIN content_commentes
                                                                 ON ( content.id = content_commentes.content_id )
                                                         INNER JOIN commentes
                                                                 ON ( content_commentes.commentes_id = commentes.id )
                                                  WHERE  ( commentes.users_id = $searchArgument )

                                                  )
                                  )


                                  OR ( content.id IN(SELECT content.id
                                                     FROM   content
                                                     WHERE  content.users_id = $searchArgument
                                                     union all

                                                     SELECT content.parent_id
                                                     FROM   content
                                                     WHERE  content.users_id = $searchArgument
                                                     )
                                      )
                               )

                                 ";
        }

        break;
    case 'all':
    default:
        $sql = $sqlBase;
        $texto = 'Todos';

        break;
}
$sql = $sql . $orderBy;


/*
echo "<pre>$sql</pre>";
echo "<pre>$filterBy</pre>";
echo "<pre>$searchArgument</pre>";
/*
* title
* text
* date_publish
* evaluation_text
* //TODO: midias_ID (ver com ira)
*
*    icon-trash
* */


list($theLink, $theParams) = preg_split("/[?]/", curPageURL());


?>

<div class="well pagination-centered">
    <h3>Lista de conteúdos do estágio <?php echo $stage . ' / ' . $texto; ?></h3>
</div>


<div class="btn-toolbar">
    <div class="btn-group">
        <a type="button" data-dismiss="modal" class="btn btn-primary"
           href="<?php echo "$theLink?stage=$stage&filter=all"; ?>"> TODOS </a>
        <a type="button" data-dismiss="modal" class="btn btn-primary"
           href="<?php echo "$theLink?stage=$stage&filter=null"; ?>"> Não avaliados </a>
        <a type="button" data-dismiss="modal" class="btn btn-primary"
           href="<?php echo "$theLink?stage=$stage&filter=0"; ?>"> Avaliados com 0 </a>
        <a type="button" data-dismiss="modal" class="btn btn-primary"
           href="<?php echo "$theLink?stage=$stage&filter=1"; ?>"> Avaliados com 1 </a>
        <a type="button" data-dismiss="modal" class="btn btn-primary"
           href="<?php echo "$theLink?stage=$stage&filter=2"; ?>"> Notas moiores que 1 </a>
    </div>
    <div class="pull-right form-inline">

        <label class="help-inline ">Digite o código do usuário:&nbsp;</label>

        <div class="input-append ">

            <input class="span1" id="txtSearch" type="text" placeholder="">
            <a class="btn" type="button" id="btnSearch">
                <div class=" icon-search"></div>
            </a>
            <a class="btn" type="button" id="btnSearchUser">
                <div class=" icon-user"></div>
            </a>
        </div>


    </div>
</div>

<table class="table table-bordered">
<colgroup>
    <col class="span1">
    <col class="span7">
    <col class="span1">
    <col class="span1">
    <col class="span1">
    <col class="span1">

</colgroup>
<thead>

</thead>
<tbody>


<?php





// While a row of data exists, put that row in $row as an associative array
// Note: If you're expecting just one row, no need to use a loop
// Note: If you put extract($row); inside the following loop, you'll
//WHERE
//       content.content_type_id =1
//       then create $userid, $fullname, and $userstatus

$response = exec_SQL($sql);

$lastParent = -1;
if ($response["code"] == 0) {
    foreach ($response["result"] as $key => $row) {
        $lRating = intval($row['evaluation']);
        ?>



        <?php
        if ($stage == 3) {
            if ($lastParent != $row['ordem']) {
                $lastParent = $row['ordem']
                ?>
                <tr style="background-color: #333333;">

                    <td colspan="6"><h4 class="pagination-centered" style="color: #dddddd">
                            Idéia <?php echo $row['id']; ?> </h4></td>
                </tr>

            <?php
            }
        }
        ?>


        <tr style="background-color: #cccccc;">

            <td id="tdIdContent<?php echo $row['id']; ?>"
                style="vertical-align: middle; background-color:<?php echo $lRating == -1 ? "#FF6363;" : " #cccccc;"; ?>; ">
                <a name="#phpContent<?php echo $row['id']; ?>"><?php echo $row['id']; ?></a>
            </td>
            <td><h4 id="titleContent<?php echo $row['id']; ?>"><?php echo $row['title']; ?></h4></td>
            <td colspan="2" style="vertical-align: middle">
                User: <?php echo $row['users_id'] . '/' . $row['nickname']; ?></td>

            <td colspan="2" style="vertical-align: middle" id="date_publishContent<?php echo $row['id']; ?>">
                Data: <?php $date = new DateTime($row['date_publish']);
                echo $date->format('d.m.Y'); ?></td>


        </tr>
        <tr style="background-color: #eeeeee;" data-id="<?php echo $row['id']; ?>">

            <td></td>

            <td><p><b>Texto:</b><br>

                <div id="textContent<?php echo $row['id']; ?>"> <?php echo $row['text']; ?></div>
                </p><p><b>Texto Avaliativo:</b><br>

                <div id="evaluationTextContent<?php echo $row['id']; ?>"><?php echo $row['evaluationText']; ?></div>
                </p>
            </td>


            <td><?php if ($stage == 3 && $row['parent_id'] == null) { ?>Multiplicador<br>Investimento<br><select
                    class="span1 ratingContent" id="select<?php echo $row['id']; ?>"
                    data-id="<?php echo $row['id']; ?>">
                    <?php
                    $lRating = intval($row['rating']);
                    for ($i = -1; $i <= 10; $i++) {
                        if ($i == $lRating) {

                            ?>
                            <option value="<?php echo $i; ?>"
                                    selected="selected"><?php echo $i == -1 ? "" : $i; ?></option>";
                        <?php } else { ?>
                            <option value="<?php echo $i; ?>"><?php echo $i == -1 ? "" : $i; ?></option>
                        <?php
                        }
                    }

                    ?>
                    </select><?php } ?></td>

            <td><?php if ($stage < 3) { ?>Avaliação<br>Qualitativa<br><select class="span1 evaluationContent"
                                                                              id="evaluation<?php echo $row['id']; ?>"
                                                                              data-id="<?php echo $row['id']; ?>">
                    <?php
                    $lRating = intval($row['evaluation']);
                    for ($i = -1; $i <= 10; $i++) {
                        if ($i == $lRating) {

                            ?>
                            <option value="<?php echo $i; ?>"
                                    selected="selected"><?php echo $i == -1 ? "" : $i; ?></option>";
                        <?php } else { ?>
                            <option value="<?php echo $i; ?>"><?php echo $i == -1 ? "" : $i; ?></option>
                        <?php
                        }
                    }

                    ?>
                    </select><?php } ?></td>



            <?php
            $eyeIcon = "";
            if ($row['status'] != 1) {
                $eyeIcon = "icon-remove";
            } else {
                $eyeIcon = "icon-eye-open";
            }

            $btnRemove = "";
            if ($row['delete_request'] == 1) {
                $btnRemove = "badge-important";
            } else {
                $btnRemove = "";
            }
            ?>




            <td colspan="2">
                Esconder/Editar<br>
                <button class=" btn btn-bg-o hideContentButton " alt="editar"
                        id="hideContentButton<?php echo $row['id']; ?>"
                        data-id="<?php echo $row['id']; ?>">
                    <div id="olhoContent<?php echo $row['id']; ?>" class="olhoOcultar <?php echo $eyeIcon; ?>"></div>
                </button>

                <div class="badge <?php echo $btnRemove; ?>" id="badgeHideContent<?php echo $row['id']; ?>">
                    <div class="icon-ban-circle"></div>
                </div>


                <button class=" btn btn-warning editContentButton" alt="editar"
                        id="editContent<?php echo $row['id']; ?>"
                        data-id="<?php echo $row['id']; ?>">
                    <div class="icon-edit btEdit"></div>
                </button>
            </td>
        </tr>
        <tr>
            <td colspan="6" style="text-align: center;"><b>Comentários</b></td>
        </tr>





        <tr>

            <th>Id</th>
            <th>Texto</th>
            <th>Usuário</th>
            <th>Data</th>

            <th>Avaliação</th>
            <th>Editar</th>


        </tr>


        <?php
        /**
         * Created by IntelliJ IDEA.
         * User: filipe
         * Date: 04/06/13
         * Time: 16:05
         * To change this template use File | Settings | File Templates.
         */

        $id = $row['id'];


        $sql = "
                        SELECT
                          commentes.id,
                          commentes.created,
                          commentes.users_id,
                          commentes.`text`,
                          commentes.delete_request,
                           coalesce(commentes.evaluation, -1) AS evaluation ,
                          commentes.`status`,
                          users.nickname,
                          content_commentes.content_id
                        FROM
                          commentes
                          LEFT OUTER JOIN users ON (commentes.users_id = users.id)
                          LEFT OUTER JOIN content_commentes ON (commentes.id = content_commentes.commentes_id)
                        WHERE
                           content_commentes.content_id= $id
                          ORDER BY 1";
        // While a row of data exists, put that row in $row as an associative array
        // Note: If you're expecting just one row, no need to use a loop
        // Note: If you put extract($row); inside the following loop, you'll
        //       then create $userid, $fullname, and $userstatus

        $response = exec_SQL($sql);
        if ($response["code"] == 0) {
            foreach ($response["result"] as $key => $row) {
                $lRating = intval($row['evaluation']);
                ?>

                <tr id="trComment<?php echo $row['id']; ?>"
                    style="background-color:<?php echo $lRating == -1 ? "#EDAFAF;" : " #D6F7D0;"; ?>">

                    <td>
                        <a name="#phpComment<?php echo $row['id']; ?>"><?php echo $row['id']; ?></a></td>
                    <td id="textComment<?php echo $row['id']; ?>"><?php echo $row['text']; ?></td>
                    <td><?php echo $row['users_id'] . '/' . $row['nickname']; ?></td>

                    <td id="createdComment<?php echo $row['id']; ?>"><?php $date = new DateTime($row['created']);
                        echo $date->format('d.m.Y'); ?></td>

                    <td colspan="2">

                        <select class="span1 evaluationComment" id="evaluationComment<?php echo $row['id']; ?>"
                                data-id="<?php echo $row['id']; ?>">
                            <?php

                            for ($i = -1; $i <= 10; $i++) {
                                if ($i == $lRating) {

                                    ?>
                                    <option value="<?php echo $i; ?>"
                                            selected="selected"><?php echo $i == -1 ? "" : $i; ?></option>";
                                <?php } else { ?>
                                    <option value="<?php echo $i; ?>"><?php echo $i == -1 ? "" : $i; ?></option>
                                <?php
                                }
                            }

                            ?>
                        </select>
                        <br>

                        <?php
                        $eyeIcon = "";
                        if ($row['status'] != 1) {
                            $eyeIcon = "icon-remove";
                        } else {
                            $eyeIcon = "icon-eye-open";
                        }

                        $btnRemove = "";
                        if ($row['delete_request'] == 1) {
                            $btnRemove = "badge-important";
                        } else {
                            $btnRemove = "";
                        }
                        ?>





                        <button class=" btn btn-bg-o hideCommentButton  " alt="editar"
                                id="hideComment<?php echo $row['id']; ?>"
                                data-id="<?php echo $row['id']; ?>">
                            <div id="olhoComment<?php echo $row['id']; ?>"
                                 class="olhoOcultar <?php echo $eyeIcon; ?>"></div>
                        </button>


                        <div class="badge  <?php echo $btnRemove; ?> " id="badgeHideComment<?php echo $row['id']; ?>">
                            <div class="icon-ban-circle"></div>
                        </div>


                        <button class=" btn  btn-warning editButtonComment" alt="editar"
                                id="editar<?php echo $row['id']; ?>"
                                data-id="<?php echo $row['id']; ?>">
                            <div class="icon-edit btEdit"></div>
                        </button>


                    </td>


                </tr>



            <?php

            }
        } else {
            echo "<tr>   <td></td><td>" . $response["result"] . "</td> <td></td>  <td></td>  <td></td>  <td></td> </tr>";
        }

        ?>




        </tr>



        <tr style=" ">
            <td colspan="6" style="text-align: center; "><br/><br/></td>
        </tr>

    <?php
    }
} else {
    echo $response["result"];
}
?>

</tbody>
</table>


<div id="responsiveWindow" class="modal hide fade" tabindex="-1" data-width="760">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 id="responsiveTitle">Mensagem</h3>
    </div>
    <div id="responsiveBody" class="modal-body">
    </div>
    <div class="modal-footer">
        <button type="button" data-dismiss="modal" class="btn">Fechar</button>

    </div>
</div>


<div id="responsiveWindowEditContent" class="modal hide fade" tabindex="-1" data-width="760">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3>Editar Conteúdo</h3>
    </div>
    <div class="modal-body">

        <form class="form-horizontal">
            <fieldset>

                <div class="control-group">
                    <label class="control-label">Id:</label>

                    <div class="controls">
                        <input id="content_id" name="content_id" type="text" placeholder="" class="input-small"
                               disabled="disabled">
                    </div>
                </div>

                <!-- Text input-->
                <div class="control-group">
                    <label class="control-label">Título</label>

                    <div class="controls">
                        <input id="content_title" name="content_title" type="text" placeholder="" class="input-xlarge">

                    </div>
                </div>

                <!-- Textarea -->
                <div class="control-group">
                    <label class="control-label">Texto</label>

                    <div class="controls">
                        <textarea id="content_text" name="content_text"
                                  style="margin: 0px; height: 72px; width: 511px;"></textarea>
                    </div>
                </div>
                <Br>
                <!-- Text input-->
                <div class="control-group">
                    <label class="control-label">Publicado</label>

                    <div class="controls">
                        <div class=" datetimepicker input-append date">
                            <input id="content_date_publish" data-format="yyyy-MM-dd hh:mm:ss" type="text">
                            <span class="add-on">
                              <i data-time-icon="icon-time" data-date-icon="icon-calendar">
                              </i>
                            </span>
                        </div>
                    </div>
                </div>
                <!-- Textarea -->
                <div class="control-group">
                    <label class="control-label">Texto Avaliativo</label>

                    <div class="controls">
                        <textarea id="content_evaluation_text" name="content_evaluation_text"
                                  style="margin: 0px; height: 72px; width: 511px;"></textarea>
                    </div>
                </div>
            </fieldset>
        </form>
    </div>
    <div class="modal-footer">
        <button type="button" data-dismiss="modal" class="btn">Fechar</button>
        <button type="button" data-dismiss="modal" class="btn btn-primary" id="saveContent">Salvar</button>
    </div>
</div>


<div id="responsiveWindowEditComment" class="modal hide fade" tabindex="-1" data-width="760">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3>Editar Cometário</h3>
    </div>
    <div class="modal-body">

        <form class="form-horizontal">
            <fieldset>
                <div class="control-group">
                    <label class="control-label">Id:</label>

                    <div class="controls">
                        <input id="comment_id" name="comment_id" type="text" placeholder="" class="input-small"
                               disabled="disabled">
                    </div>
                </div>
                <!-- Textarea -->
                <div class="control-group">
                    <label class="control-label">Texto</label>

                    <div class="controls">
                        <textarea id="comment_text" name="comment_text"
                                  style="margin: 0px; height: 72px; width: 511px;"></textarea>
                    </div>
                    <Br>
                    <!-- Text input-->
                    <div class="control-group">
                        <label class="control-label">Publicado</label>

                        <div class="controls">
                            <div class=" datetimepicker input-append date">
                                <input id="comment_created" data-format="yyyy-MM-dd hh:mm:ss" type="text">
                            <span class="add-on">
                              <i data-time-icon="icon-time" data-date-icon="icon-calendar">
                              </i>
                            </span>
                            </div>
                        </div>
                    </div>
            </fieldset>
        </form>
    </div>
    <div class="modal-footer">
        <button type="button" data-dismiss="modal" class="btn">Fechar</button>
        <button type="button" data-dismiss="modal" class="btn btn-primary" id="saveComment">Salvar</button>
    </div>
</div>


<div id="responsiveWindowEditSearchUser" class="modal hide fade span8" tabindex="-1" data-width="760">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3>Localizar Usuário:</h3>
    </div>
    <div class="modal-body" style="height: 500px;">
        <div class="pagination-centered">
            <form class="form-search">
                <input type="text" class="input-xxlarge search-query" id="txtSearchUserArgument">
                <button type="button" class="btn" id="btnSearchUserGo">
                    <div class="icon-search"></div>
                </button>
            </form>
        </div>
        <div class="span7"
             style="height: 450px !important;overflow-y: scroll !important; overflow-x: hidden !important; ">

            <table class="table table-striped table-bordered">
                <thead>
                <tr>
                    <th width="10%">Id</th>
                    <th width="30%">NickName</th>
                    <th width="50%">login</th>
                    <th width="10%"></th>
                </tr>
                </thead>
                <tbody id="tableSearchUser">
                </tbody>
            </table>
        </div>

    </div>
    <div class="modal-footer">
        <button type="button" data-dismiss="modal" class="btn">Fechar</button>
    </div>
</div>


<script type="text/javascript">
$(function () {
    var theLink = '<?php echo $theLink?>';
    var theStage = <?php echo $stage?>;
    $.fn.modalmanager.defaults.resize = true;
    $("#btnSearch").click(function () {
        console.log("foi");
        console.log("foi");
        window.location.href = theLink + '?stage=' + theStage + '&filter=search&search=' + $("#txtSearch").val();
    });

    $("#btnSearchUser").click(function () {
        $("#responsiveWindowEditSearchUser").modal();
    });

    $("#btnSearchUserGo").click(function () {
        $("#tableSearchUser").html('');
        $.ajax({
            url: "_ajax_ContentList.php",
            type: "POST",
            data: { 'id': $(this).data('id'),
                'function': 'searchUser',
                'argument': $("#txtSearchUserArgument").val()}
        }).done(function (data) {
                // $("#full-width").html(data);
                console.log(data);
                data = $.parseJSON(data);
                console.log(data);
                if (data.count > 0) {
                    $.each(data.data, function (k, v) {
                        $("#tableSearchUser").append('<tr>');
                        $("#tableSearchUser").append('    <td>' + v.id + '</td>');
                        $("#tableSearchUser").append('    <td>' + v.nickname + '</td>');
                        $("#tableSearchUser").append('    <td>' + v.login + '</td> ');
                        $("#tableSearchUser").append('    <td><button type="button" data-id="' + v.id + '" class="btn useUserID">Filtrar</button></td> ');
                        $("#tableSearchUser").append('</tr>');
                    })
                    refreshUseUserID();
                } else {
                    $("#tableSearchUser").append('<tr><td colspan="4" class="pull-center"> <h4>sem resultados</h4></td></tr>');
                }
            });
    });

    $('.editContentButton').click(function () {

        $.ajax({
            url: "_ajax_ContentList.php",
            type: "POST",
            data: { 'id': $(this).data('id'),
                'function': 'editContent',
                'elementID': $(this).attr("id")}
        }).done(function (data) {
                // $("#full-width").html(data);
                data = $.parseJSON(data);
                $("#content_title").val(data.title);
                $("#content_text").val(data.text);
                $("#content_id").val(data.id);
                $("#content_date_publish").val(data.date_publish);
                $("#content_evaluation_text").val(data.evaluation_text);

                $("#responsiveWindowEditContent").modal();
            });
    });
    $("#saveContent").click(function () {
        $.ajax({
            url: "_ajax_ContentList.php",
            type: "POST",
            data: {
                'function': 'saveEditContent',
                'elementID': $(this).attr("id"),
                'id': $("#content_id").val(),
                'title': $("#content_title").val(),
                'text': $("#content_text").val(),
                'evaluationText': $("#content_evaluation_text").val(),
                'date_publish': $("#content_date_publish").val()
            }
        }).done(function (data) {
                console.log(data);
                // $("#full-width").html(data);  evaluationTextContent textContent
                data = $.parseJSON(data);
                console.log(data);
                $("#titleContent" + data.id).html(data.title);
                $("#textContent" + data.id).html(data.text);

                var dt = new Date(data.date_publish);
                var curr_date = dt.getDate();
                var curr_month = dt.getMonth() + 1; //Months are zero based
                var curr_year = dt.getFullYear();
                $("#date_publishContent" + data.id).html('Data: ' + curr_date + "." + curr_month + "." + curr_year);
                $("#evaluationTextContent" + data.id).html(data.evaluation_text);
                $('#responsiveBody').html('Dados Salvos!');
                $('#responsiveWindow').modal();
            });
    });


    $('.editButtonComment').click(function () {

        $.ajax({
            url: "_ajax_ContentList.php",
            type: "POST",
            data: { 'id': $(this).data('id'),
                'function': 'editComment',
                'elementID': $(this).attr("id")}
        }).done(function (data) {
                // $("#full-width").html(data);
                data = $.parseJSON(data);
                $("#comment_text").val(data.text);
                $("#comment_id").val(data.id);
                $("#comment_created").val(data.created);

                $("#responsiveWindowEditComment").modal();
            });
    });

    $("#saveComment").click(function () {
        $.ajax({
            url: "_ajax_ContentList.php",
            type: "POST",
            data: {
                'function': 'saveEditComment',
                'elementID': $(this).attr("id"),
                'id': $("#comment_id").val(),
                'text': $("#comment_text").val(),
                'created': $("#comment_created").val()
            }
        }).done(function (data) {
                console.log(data);
                // $("#full-width").html(data);  evaluationTextContent textContent
                data = $.parseJSON(data);
                console.log(data);
                $("#textComment" + data.id).html(data.text);
                var dt = new Date(data.created);
                var curr_date = dt.getDate();
                var curr_month = dt.getMonth() + 1; //Months are zero based
                var curr_year = dt.getFullYear();
                $("#createdComment" + data.id).html(curr_date + "." + curr_month + "." + curr_year);

                $('#responsiveBody').html('Dados Salvos!');
                $('#responsiveWindow').modal();
            });
    });


    //rating content
    $('.ratingContent').change(function () {
        $(this).prop('disabled', 'disabled');
        $.ajax({
            url: "_ajax_ContentList.php",
            type: "POST",
            data: {
                'id': $(this).data('id'),
                'elementID': $(this).attr("id"),
                'value': $(this).val(),
                'function': 'ratingContent'
            }
        }).done(function (data) {
                data = $.parseJSON(data);
                $("#" + data.elementID).removeProp('disabled');

                if (!data.result) {
                    $('#responsiveBody').html('Erro ao gravar');
                    $('#responsiveWindow').modal();
                }

                //$.modal("Erro ao gravar");
            });
    });


    //evaluation Content
    $('.evaluationContent').change(function () {
        $(this).prop('disabled', 'disabled');
        $.ajax({
            url: "_ajax_ContentList.php",
            type: "POST",
            data: {
                'id': $(this).data('id'),
                'elementID': $(this).attr("id"),
                'value': $(this).val(),
                'function': 'evaluationContent'
            }
        }).done(function (data) {
                data = $.parseJSON(data);
                $("#" + data.elementID).removeProp('disabled');

                if (!data.result) {
                    $('#responsiveBody').html('Erro ao gravar');
                    $('#responsiveWindow').modal();
                }
                $("#tdIdContent" + data.id).css("background-color", data.value == -1 ? "#FF6363" : "#cccccc");

            });
    });


    //evaluation Comments
    $('.evaluationComment').change(function () {
        $(this).prop('disabled', 'disabled');
        $.ajax({
            url: "_ajax_ContentList.php",
            type: "POST",
            data: {
                'id': $(this).data('id'),
                'elementID': $(this).attr("id"),
                'value': $(this).val(),
                'function': 'evaluationComment'
            }
        }).done(function (data) {
                console.log($.parseJSON(data));
                data = $.parseJSON(data);
                $("#" + data.elementID).removeProp('disabled');
                $("#trComment" + data.id).css("background-color", data.value == -1 ? "#EDAFAF" : "#D6F7D0");

                if (!data.result) {
                    $('#responsiveBody').html('Erro ao gravar');
                    $('#responsiveWindow').modal();
                }
            });
    });

    //hideContentButton Comments
    $('.hideContentButton').click(function () {
        console.log("foi" + $(this).attr("id"));
        $(this).prop('disabled', 'disabled');
        $.ajax({
            url: "_ajax_ContentList.php",
            type: "POST",
            data: {
                'id': $(this).data('id'),
                'elementID': $(this).attr("id"),
                'value': $(this).val(),
                'function': 'hideContent'
            }
        }).done(function (data) {
                console.log($.parseJSON(data));
                data = $.parseJSON(data);
                if (!data.result) {
                    $('#responsiveBody').html('Erro ao gravar');
                    $('#responsiveWindow').modal();
                } else {

                    $("#" + data.elementID).removeProp('disabled');
                    $("#olhoContent" + data.id).removeClass('icon-remove');
                    $("#olhoContent" + data.id).removeClass('icon-eye-open');

                    var newIcon = data.value == 1 ? ' icon-eye-open ' : 'icon-remove';
                    $("#olhoContent" + data.id).addClass(newIcon);

                    console.log($("#badgeHideContent" + data.id));

                    //  $("#badgeHideContent" + data.id).removeClass('badge-important');
                    //  $("#badgeHideContent" + data.id).removeClass('badge-success');
                    newIcon = data.delete_request == 1 ? 'badge-important' : 'badge-success';

                    $("#badgeHideContent" + data.id).attr("class", "badge " + newIcon);
                    //  $("#badgeHideContent" + data.id).addClass(newIcon);

                    console.log($("#badgeHideContent" + data.id));

                }
            });
    });

    //hideCommentButton Comments
    $('.hideCommentButton').click(function () {
        console.log("foi" + $(this).attr("id"));
        $(this).prop('disabled', 'disabled');
        $.ajax({
            url: "_ajax_ContentList.php",
            type: "POST",
            data: {
                'id': $(this).data('id'),
                'elementID': $(this).attr("id"),
                'value': $(this).val(),
                'function': 'hideComment'
            }
        }).done(function (data) {
                console.log($.parseJSON(data));
                data = $.parseJSON(data);
                if (!data.result) {
                    $('#responsiveBody').html('Erro ao gravar');
                    $('#responsiveWindow').modal();
                } else {
                    $("#" + data.elementID).removeProp('disabled');
                    $("#olhoComment" + data.id).removeClass('icon-remove');
                    $("#olhoComment" + data.id).removeClass('icon-eye-open');

                    var newIcon = data.value == 1 ? ' icon-eye-open ' : 'icon-remove';
                    $("#olhoComment" + data.id).addClass(newIcon);


                    $("#badgeHideComment" + data.id).removeClass('badge-important');
                    $("#badgeHideComment" + data.id).removeClass('badge-success');
                    newIcon = data.delete_request == 1 ? 'badge-important' : 'badge-success';
                    $("#badgeHideComment" + data.id).addClass(newIcon);
                }
            });
    });


    $('.datetimepicker').datetimepicker({
        language: 'pt-BR'
    });

});


function refreshUseUserID() {
    $(".useUserID").click(function () {
        $("#txtSearch").val($(this).data('id'));
        $("#btnSearch").trigger("click");
        $("#responsiveWindowEditSearchUser").modal('hide');
    });
}
</script>

<?php
require_once "_footer.php";
?>
