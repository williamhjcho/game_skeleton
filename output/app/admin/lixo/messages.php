<?php
require_once "_header.php";


?>

<div class="well pagination-centered">
    <h3>Relatórios diário e alertas</h3>
</div>

<div class="">
    <button type="button" data-dismiss="modal" class="btn btn-primary" id="newMessage">Novo</button>
</div>
<br>

<table class="table table-bordered">
    <colgroup>
        <col class="span1">
        <col class="span1">
        <col class="span1">
        <col class="span1">
        <col class="span7">
        <col class="span1">
    </colgroup>
    <thead>
    <tr>
        <th>ID</th>
        <th>Dr. Criação</th>
        <th>Dt. Public.</th>
        <th>Tipo</th>
        <th>Texto</th>
        <th>Editar</th>
    </tr>
    </thead>
    <tbody id="messageTable">


    <?php
    $sql = "SELECT
                  `id`,
                  `users_id`,
                  `id_registro`,
                  `tabela`,
                  `assunto`,
                  `texto`,
                  `destinatario`,
                  `tipo`,
                  `created`,
                  `modified`,
                  `publish`
                FROM
                  `messages`
             WHERE tipo IN ('relatoriodiario','alerta' )
              ORDER BY created ASC";


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


            ?>

            <tr>

                <td width="4%"> <?php echo $row['id']; ?> </td>
                <td><?php $date = new DateTime($row['created']);
                    echo $date->format('d.m.Y'); ?></td>
                <td><?php $date = new DateTime($row['publish']);
                    echo $date->format('d.m.Y'); ?></td>
                <td>
                    <?php if ($row['tipo'] == 'relatoriodiario') { ?>
                        <div class="badge badge-info">
                            <div class=" icon-book"></div>
                        </div>
                    <?php } else { ?>
                        <div class="badge badge-warning">
                            <div class=" icon-bell"></div>
                        </div>
                    <?php } ?>
                </td>
                <td id="messageText<?php echo $row['id'];?>"> <?php echo $row['texto']; ?> </td>
                <td  width="10%">
                    <button type="button" data-dismiss="modal" class="btn btn-danger btnRemove"
                            data-id="<?php echo $row['id']; ?>">
                        <div class="icon-trash"></div>
                    </button>
                    <button class="btn btn-warning editMessageButton" alt="editar" id="editMessage<?php echo $row['id']; ?>" data-id="<?php echo $row['id']; ?>"
                        data-tipo="<?php echo $row['tipo']; ?>" data-publish="<?php echo $row['publish']; ?>" >
                        <div class="icon-edit btEdit"></div>
                    </button>
                </td>

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
        <h3>NovaMensagem</h3>
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
                    <label class="control-label">Publicar em:</label>

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

                <!-- Multiple Radios (inline) -->
                <div class="control-group">
                    <label class="control-label">Inline Radios</label>

                    <div class="controls">
                        <label class="radio inline">
                            <input type="radio" name="radios" id="radio_relatoriodiario" value="relatoriodiario" checked="checked">

                            <div class="badge badge-info">
                                <div class=" icon-book"></div>
                            </div> Relatório diário
                        </label>
                        <label class="radio inline">
                            <input type="radio" name="radios" id="radio_alerta" value="alerta">

                            <div class="badge badge-warning">
                                <div class=" icon-bell"></div>
                            </div> Alerta
                        </label>

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


            </fieldset>
        </form>

    </div>
    <div class="modal-footer">
        <button type="button" data-dismiss="modal" class="btn">Fechar</button>
        <button type="button" data-dismiss="modal" class="btn btn-primary" id="saveContent">Salvar</button>

    </div>
</div>


<script type="text/javascript">

    $(function () {

        $.fn.modalmanager.defaults.resize = true;

        $("#newMessage").click(function () {
            $("#content_id").val("");
            $("#content_date_publish").val(moment().format('YYYY-MM-DD hh:mm:ss'));
            $('#radio_alerta').prop('checked', false);
            $('#radio_relatoriodiario').prop('checked', true);

            $("#content_text").val('');
            $('#responsiveWindowEditContent').modal();
        });




        $("#saveContent").click(function () {
            $.ajax({
                url: "_ajax_messages.php",
                type: "POST",
                data: {
                    'function': 'saveMessage',
                    'date': $("#content_date_publish").val(),
                    'tipo': $('input[name=radios]:checked').val(),
                    'texto': $("#content_text").val(),
                    'id':  $("#content_id").val()
                }
            }).done(function (data) {
                    console.log($.parseJSON(data));
                    data = $.parseJSON(data);
                    if (!data.result) {
                        $('#responsiveBody').html('Erro ao gravar');
                        $('#responsiveWindow').modal();
                    } else {

                        refreshMessageTable(data.result);

                    }


                });
        });

        $('.datetimepicker').datetimepicker({
            language: 'pt-BR'
        });
        onclickBtns();
        //trContent  tdIdContent   "#FF6363;" : " #cccccc;"; ?>;

    });


    function refreshMessageTable(dataSet) {
        $("#messageTable").html('');

        $.each(dataSet, function (index, value) {
            var badge = '<div class="badge badge-warning"><div class=" icon-bell"></div></div>';

            if (value.tipo == 'relatoriodiario') {
                badge = '<div class="badge badge-info"> <div class=" icon-book"></div></div>';
            }


            $("#messageTable").append(
                '<tr>' +
                    '<td  width="4%">' + value.id + '</td>' +
                    '<td>' + value.created + '</td>' +
                    '<td>' + value.publish + '</td>' +
                    '<td>' + badge + '</td>' +
                    '<td>' + value.texto + '</td>' +
                    '<td  width="10%">' +
                    '       <button type="button" data-dismiss="modal" class="btn btn-danger btnRemove" data-id="' + value.id + '" >' +
                    '           <div class="icon-trash"></div>' +
                    '       </button>' +
                    '       <button class="btn btn-warning editMessageButton" alt="editar" ' +
                    '                   id="editMessage' + value.id + '" ' +
                    '                   data-id="' + value.id + '" ' +
                    '                   data-tipo="' + value.tipo + '" ' +
                    '                   data-publish="' + value.publish + '" >' +
                    '           <div class="icon-edit btEdit"></div>' +
                    '       </button>' +
                    '</td>'
            );

        });
        onclickBtns();


    }
    function onclickBtns() {
        $(".btnRemove").unbind('click');
        $(".btnRemove").click(function () {

            console.log("asdfasdfa");
            $.ajax({
                url: "_ajax_messages.php",
                type: "POST",
                data: {
                    'function': 'removeMessage',
                    'id': $(this).data("id")

                }
            }).done(function (data) {
                    console.log($.parseJSON(data));
                    data = $.parseJSON(data);
                    if (!data.result) {
                        $('#responsiveBody').html('Erro ao gravar');
                        $('#responsiveWindow').modal();
                    } else {

                        refreshMessageTable(data.result);

                    }


                });
        });

        $(".editMessageButton").click(function () {
            $("#content_id").val($(this).data('id'));
            $("#content_text").html(  $("#messageText"+$(this).data('id')).html()  );
            $('#radio_relatoriodiario').prop('checked', false);
            $('#radio_alerta').prop('checked', false);
            $('#radio_'+$(this).data("tipo")).prop('checked', true);
            $("#content_date_publish").val(moment($(this).data('publish')).format('YYYY-MM-DD hh:mm:ss'));
            $('#responsiveWindowEditContent').modal();
        });

    }
</script>

<?php
require_once "_footer.php";
?>
