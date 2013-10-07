<?php
require_once "_header.php";


?>

<div class="well pagination-centered">
    <h3>Suporte</h3>
</div>


<br>




<?php
$sql = "SELECT
              users.nickname,
              users.id as userID,
              messages.id,
              messages.users_id,
              messages.id_registro,
              messages.tabela,
              messages.assunto,
              messages.tipo,
              messages.destinatario,
              messages.texto,
              messages.created,
              messages.modified,
              messages.publish
            FROM
              messages
              INNER JOIN users ON (messages.users_id = users.id)
               WHERE messages.tipo NOT  IN ('relatoriodiario','alerta' )
               AND parent_id IS null
              ORDER BY messages.created ASC";


// While a row of data exists, put that row in $row as an associative array
// Note: If you're expecting just one row, no need to use a loop
// Note: If you put extract($row); inside the following loop, you'll
//WHERE
//       content.content_type_id =1
//       then create $userid, $fullname, and $userstatus

$response = exec_SQL($sql);


if ($response["code"] == 0) {
    foreach ($response["result"] as $key => $row) {
        $leID = $row['id'];
        ?>
        <table class="table table-bordered">

            <thead style="background-color: #cccccc;">
            <tr>
                <th width="4.33%">ID</th>
                <th width="8.33%">Dr. Criação</th>
                <th width="8.33%">Usuário</th>
                <th width="8.33%">Tipo</th>
                <th width="62.35%">Texto</th>
                <th width="8.33%">Editar</th>
            </tr>
            </thead>
            <tbody id="messageTable">

            <tr>

                <td> <?php echo $row['id']; ?> </td>
                <td><?php $date = new DateTime($row['created']);
                    echo $date->format('d.m.Y'); ?></td>
                <td><?php echo $row['userID'].'/'.$row['nickname']; ?></td>
                <td><?php echo $row['tipo']; ?></td>
                <td> <?php echo $row['texto']; ?> </td>
                <td>
                    <button type="button" data-dismiss="modal" class="btn btn-danger btnAnswer"
                            data-id="<?php echo $row['id']; ?>">
                        Responder
                    </button>
                </td>

            </tr>

            </tbody>
        </table>




        <div class="pull-right" style="width: 95%">


        <?php
        //************************************************************************CONTEUDO RELACIONADO
        $idRegistro = $row['id_registro'];
        if ($row['tipo'] == 'apagar') {
            if ($row['tabela'] == 'content') {
                //*********************************************************************COUNTEUDO CONTENT
                $sqlContent = "SELECT
                                  content.id,content.date_publish, content.users_id,
                                  content.title, content.subtitle,content.description, content.evaluationText,
                                  content.text, coalesce(content.rating, -1) AS rating,  coalesce(content.evaluation, -1) AS evaluation ,
                                  content.delete_request, users.nickname, content.status,
                                   coalesce(content.parent_id,  content.id) AS ordem
                                FROM
                                  content
                                  LEFT OUTER JOIN users ON (content.users_id = users.id)
                                WHERE
                                  content.id= $idRegistro;";

                $responseContent = exec_SQL($sqlContent);

                if ($responseContent["code"] == 0) {
                    foreach ($responseContent["result"] as $key => $row) {
                        $lRating = intval($row['evaluation']);
                        ?>
                        <table class="table table-bordered">


                            <tbody>

                            <tr style="background-color: #eaeaea;">

                                <td width="4.33%" id="tdIdContent<?php echo $row['id']; ?>"
                                    style="vertical-align: middle; background-color:<?php echo $lRating == -1 ? "#FF6363;" : " #cccccc;"; ?>; ">
                                    <?php echo $row['id']; ?>
                                </td>
                                <td width="62.35%"><h4
                                        id="titleContent<?php echo $row['id']; ?>"><?php echo $row['title']; ?></h4>
                                </td>
                                <td colspan="2" style="vertical-align: middle">
                                    User: <?php echo $row['users_id'] . '/' . $row['nickname']; ?></td>

                                <td colspan="2" style="vertical-align: middle"
                                    id="date_publishContent<?php echo $row['id']; ?>">
                                    Data: <?php $date = new DateTime($row['date_publish']);
                                    echo $date->format('d.m.Y'); ?></td>


                            </tr>
                            <tr data-id="<?php echo $row['id']; ?>">

                                <td colspan="2">
                                    <p><b>Texto:</b><br>

                                    <div id="textContent<?php echo $row['id']; ?>"> <?php echo $row['text']; ?></div>
                                    </p><p><b>Texto Avaliativo:</b><br>

                                    <div
                                        id="evaluationTextContent<?php echo $row['id']; ?>"><?php echo $row['evaluationText']; ?></div>
                                    </p>
                                </td>


                                <td>Rating<br><select class="span1 ratingContent" id="select<?php echo $row['id']; ?>"
                                                      data-id="<?php echo $row['id']; ?>">
                                        <?php
                                        $lRating = intval($row['rating']);
                                        for ($i = -1; $i <= 10; $i++) {
                                            if ($i == $lRating) {

                                                ?>
                                                <option value="<?php echo $i; ?>"
                                                        selected="selected"><?php echo $i == -1 ? "" : $i; ?></option>";
                                            <?php } else { ?>
                                                <option
                                                    value="<?php echo $i; ?>"><?php echo $i == -1 ? "" : $i; ?></option>
                                            <?php
                                            }
                                        }

                                        ?>
                                    </select></td>

                                <td>Avaliação<br><select class="span1 evaluationContent"
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
                                                <option
                                                    value="<?php echo $i; ?>"><?php echo $i == -1 ? "" : $i; ?></option>
                                            <?php
                                            }
                                        }

                                        ?>
                                    </select></td>



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




                                <td>Status<br>
                                    <button class="btn btn-bg-o hideContentButton " alt="editar"
                                            id="hideContentButton<?php echo $row['id']; ?>"
                                            data-id="<?php echo $row['id']; ?>">
                                        <div id="olhoContent<?php echo $row['id']; ?>"
                                             class="olhoOcultar <?php echo $eyeIcon; ?>"></div>
                                    </button>

                                    <div class="badge <?php echo $btnRemove; ?>"
                                         id="badgeHideContent<?php echo $row['id']; ?>">
                                        <div class="icon-ban-circle"></div>
                                    </div>


                                </td>
                                <td> Editar<br>
                                    <button class="btn btn-warning editContentButton" alt="editar"
                                            id="editContent<?php echo $row['id']; ?>"
                                            data-id="<?php echo $row['id']; ?>">
                                        <div class="icon-edit btEdit"></div>
                                    </button>
                                </td>
                            </tr>

                            </tbody>
                        </table>





                    <?php
                    }
                }
            } else {
                //*********************************************************************COUNTEUDO COMMENT

                $sqlComment = "
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
                           commentes.id= $idRegistro;";

                $responseComment = exec_SQL($sqlComment);


                if ($responseComment["code"] == 0) {

                    foreach ($responseComment["result"] as $key => $row) {

                        $lRating = intval($row['evaluation']);

                        ?>



                        <table class="table table-bordered">
                            <tbody>
                            <tr id="trComment<?php echo $row['id']; ?>"
                                style="background-color:<?php echo $lRating == -1 ? "#EDAFAF;" : " #D6F7D0;"; ?>">

                                <td width='4.33%'>
                                    <a name="#phpComment<?php echo $row['id']; ?>"><?php echo $row['id']; ?></a></td>
                                <td width="62.35%"
                                    id="textComment<?php echo $row['id']; ?>"><?php echo $row['text']; ?></td>
                                <td><?php echo $row['users_id'] . '/' . $row['nickname']; ?></td>

                                <td id="createdComment<?php echo $row['id']; ?>"><?php $date = new DateTime($row['created']);
                                    echo $date->format('d.m.Y'); ?></td>

                                <td width='8.33%'>

                                    <select class="span1 evaluationComment"
                                            id="evaluationComment<?php echo $row['id']; ?>"
                                            data-id="<?php echo $row['id']; ?>">
                                        <?php

                                        for ($i = -1; $i <= 10; $i++) {
                                            if ($i == $lRating) {

                                                ?>
                                                <option value="<?php echo $i; ?>"
                                                        selected="selected"><?php echo $i == -1 ? "" : $i; ?></option>";
                                            <?php } else { ?>
                                                <option
                                                    value="<?php echo $i; ?>"><?php echo $i == -1 ? "" : $i; ?></option>
                                            <?php
                                            }
                                        }

                                        ?>
                                    </select>

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
                                    <button class="btn btn-bg-o hideCommentButton  " alt="editar"
                                            id="hideComment<?php echo $row['id']; ?>"
                                            data-id="<?php echo $row['id']; ?>">
                                        <div id="olhoComment<?php echo $row['id']; ?>"
                                             class="olhoOcultar <?php echo $eyeIcon; ?>"></div>
                                    </button>


                                    <div class="badge  <?php echo $btnRemove; ?> "
                                         id="badgeHideComment<?php echo $row['id']; ?>">
                                        <div class="icon-ban-circle"></div>
                                    </div>


                                </td>
                                <td>
                                    <button class="btn btn-warning editButtonComment" alt="editar"
                                            id="editar<?php echo $row['id']; ?>"
                                            data-id="<?php echo $row['id']; ?>">
                                        <div class="icon-edit btEdit"></div>
                                    </button>


                                </td>
                            </tr>
                            </tbody>
                        </table>









                    <?php
                    }
                }
                ?>

            <?php
            }
            ?>

        <?php
        }
        ?>






















        <?php
        //*****************************************************RESPOSTAS

        $sqlAnswers = "SELECT
              users.nickname,
              messages.id,
              messages.users_id,
              messages.id_registro,
              messages.tabela,
              messages.assunto,
              messages.tipo,
              messages.destinatario,
              messages.texto,
              messages.created,
              messages.modified,
              messages.publish
            FROM
              messages
              INNER JOIN users ON (messages.users_id = users.id)
               WHERE parent_id= $leID
              ORDER BY messages.created ASC";
        $responseAnswers = exec_SQL($sqlAnswers);


        if ($responseAnswers["code"] == 0) {
            if (sizeof($responseAnswers["result"]) > 0) {
                ?>

                <h4>Respostas</h4>
                <table class="table table-bordered">

                    <thead>
                    <tr>
                        <th width="4.33%">ID</th>
                        <th width="8.33%">Dr. Criação</th>
                        <th width="8.33%">Usuário</th>
                        <th width="8.33%">Tipo</th>
                        <th width="70.68%">Texto</th>

                    </tr>
                    </thead>
                    <tbody id="messageTable">


                    <?php
                    foreach ($responseAnswers["result"] as $key => $row) {
                        ?>
                        <tr>
                            <td> <?php echo $row['id']; ?> </td>
                            <td><?php $date = new DateTime($row['created']);
                                echo $date->format('d.m.Y'); ?></td>
                            <td><?php echo $row['users_id'] . '/' . $row['nickname']; ?></td>
                            <td><?php echo $row['tipo']; ?></td>
                            <td> <?php echo $row['texto']; ?> </td>

                        </tr>


                    <?php
                    } ?>
                    </tbody>
                </table>
            <?php


            }

        }


        ?>


        </div>

    <?php
    }
} else {
    echo $response["result"];
}
?>





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
        <button type="button" data-dismiss="modal" class="btn"> Fechar </button>
        <button type="button" data-dismiss="modal" class="btn btn-primary" id="saveComment"> Salvar </button>

    </div>
</div>



<div id="responsiveWindowEditAnswer" class="modal hide fade" tabindex="-1" data-width="760">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3>Responder</h3>
    </div>
    <div class="modal-body">

        <form class="form">
            <fieldset>


                <!-- Textarea -->
                <input type="hidden" id="answer_id" name="answer_id">
                <div class="control-group">


                    <div class="controls">
                        <textarea id="answer_text" name="answer_text"
                                  style="margin: 0px; height: 73px; width: 715px;"></textarea>

                    </div>



            </fieldset>
        </form>

    </div>
    <div class="modal-footer">
        <button type="button" data-dismiss="modal" class="btn">Fechar</button>
        <button type="button" data-dismiss="modal" class="btn btn-primary" id="saveAnswer">Responder</button>

    </div>
</div>




<script type="text/javascript">
/*
 'elementID' => $elementID,
 'result' => $response['code'] == 0 ? true : false,
 'value' => $value,
 "title"=>  $response['title'],
 "text"=>  $response['text'],
 "date_publish"=>  $response['date_publish'],
 "evaluation_text"=>  $response['evaluation_text'],
 'id' => $id
 * */
$(function () {
    var  defaultAnswer ="";

    $.fn.modalmanager.defaults.resize = true;



    $('.btnAnswer').click(function () {

        $("#answer_id").val($(this).data('id'));
        $("#answer_text").val(defaultAnswer);
        $("#responsiveWindowEditAnswer").modal();
        console.log( $("#answer_id").val());
    });





    $('#saveAnswer').click(function () {

        $.ajax({
            url: "_ajax_support.php",
            type: "POST",
            data: { 'id': $(this).data('id'),
                'function': 'saveAnswer',
                'id': $("#answer_id").val(),
                'answer':  $("#answer_text").val()
            }
        }).done(function (data) {
             location.reload();
              /*  // $("#full-width").html(data);
                data = $.parseJSON(data);
                $("#content_title").val(data.title);
                $("#content_text").val(data.text);
                $("#content_id").val(data.id);
                $("#content_date_publish").val(data.date_publish);
                $("#content_evaluation_text").val(data.evaluation_text);

                $("#responsiveWindowEditContent").modal(); */
            });

        //
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

        //
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

        //
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
    //trContent  tdIdContent   "#FF6363;" : " #cccccc;"; ?>;

});
</script>


<?php
require_once "_footer.php";
?>
