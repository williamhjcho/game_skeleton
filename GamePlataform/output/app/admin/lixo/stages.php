<?php
require_once "_header.php";
?>
<div class="well text-center">
    <h4>Data dos estágios</h4>
</div>
<table class="table">
    <colgroup>
        <col class="span2">
        <col class="span2">
        <col class="span2">


    </colgroup>
    <thead>
    <tr>
        <th>
            <h4>Estágios</h4>
        </th>
        <th>
            <h4>Início</h4>
        </th>
        <th>
            <h4>Fim</h4>
        </th>
    </tr>
    </thead>
    <tbody>


    <?php
    $sql = "SELECT
          stages.id,
          stages.name,
          stages.start,
          stages.`end`
        FROM
          stages
          ORDER BY 1";


    // While a row of data exists, put that row in $row as an associative array
    // Note: If you're expecting just one row, no need to use a loop
    // Note: If you put extract($row); inside the following loop, you'll
    //WHERE
    //       content.content_type_id =1
    //       then create $userid, $fullname, and $userstatus

    $response = exec_SQL($sql);
    $count = 0;
	
	$stageItems = $response["result"];

	
    if ($response["code"] == 0) {

        foreach ($response["result"] as $key => $row) {

            ?>


            <tr id="stageElement<?php echo $count ?>" data-id="<?php echo $row['id'] ?>">
                <td>ID: <?php echo $row['id'] . " / " . $row['name']; ?> </td>
                <td>
                    <div class=" datetimepicker input-append date">
                        <input id="dateStart<?php echo $count ?>" data-format="yyyy-MM-dd hh:mm:ss" type="text"
                               value="<?php echo $row['start']; ?>">
                            <span class="add-on">
                              <i data-time-icon="icon-time" data-date-icon="icon-calendar">
                              </i>
                            </span>
                    </div>
                </td>
                <td>
                    <div class=" datetimepicker input-append date" data-id="<?php echo $row['id'] ?>">
                        <input id="dateEnd<?php echo $count ?>" data-format="yyyy-MM-dd hh:mm:ss" type="text"
                               value="<?php echo $row['end']; ?>">
                            <span class="add-on">
                              <i data-time-icon="icon-time" data-date-icon="icon-calendar">
                              </i>
                            </span>
                    </div>


                </td>


            </tr>




            <?php
            $count++;
        }
    } else {
        echo $response["result"];
    }
    ?>

    <tr>
        <td colspan="3">
            <div class="pull-right">
                <div id="txtMessage" style="display: inline"></div>
                <button type="button" id="btnSave" class="btn">Salvar</button>
            </div>

        </td>
    </tr>

    </tbody>
</table>

<hr>
<div class="well  text-center">
    <h4>Parâmetros</h4>
</div>


<table class="table table-striped">
    <colgroup>
        <col class="span2">
        <col class="span2">
        <col class="span2">


    </colgroup>
    <thead>
    <tr>
        <th>
            <h4 >Nome</h4>
        </th>
        <th>
            <h4 >Valor</h4>
        </th>
        <th>
            <h4></h4>
        </th>
    </tr>
    </thead>
    <tbody>


    <?php
    $sql = "SELECT
                 name, value
                FROM
                  parameters";


    // While a row of data exists, put that row in $row as an associative array
    // Note: If you're expecting just one row, no need to use a loop
    // Note: If you put extract($row); inside the following loop, you'll
    //WHERE
    //       content.content_type_id =1
    //       then create $userid, $fullname, and $userstatus

    $response = exec_SQL($sql);
    $count = 0;
    if ($response["code"] == 0) {
        foreach ($response["result"] as $key => $row) {
            ?>
            <tr>
                <td>
                    <div class="pull-right"> <?php echo $row['name']; ?>:</div>
                </td>
                <td>
					
					<?php if ($row['name'] == "dataCalculoInvestimento1" || $row['name'] == "dataCalculoInvestimento2" )  { ?>
					
                   
						
						<div class=" datepicker input-append date" data-id="<?php echo $row['name'] ?>">
                        <input id="editParam_<?php echo $row['name']; ?>" data-format="yyyy-MM-dd" type="text"
                               value="<?php echo $row['value']; ?>">
                            <span class="add-on">
                              <i data-time-icon="icon-time" data-date-icon="icon-calendar">
                              </i>
                            </span>
						</div>
						
					<?php } else { ?>	
						 <input id="editParam_<?php echo $row['name']; ?>" type="text" value="<?php echo $row['value']; ?>">
					
					<?php } ?>
                </td>
                <td>
                    <div class="pull-right">
                        <button type="button" data-param="<?php echo $row['name']; ?>"
                                class="btn btn-primary btnSaveParam"> Salvar </button>
                    </div>
                </td>
            </tr>

            <?php
            $count++;
        }
    } else {
        echo $response["result"];
    }
    ?>

    <tr>
        <td colspan="3">
            <div class="pull-right" id="messageSave"> </div>

        </td>
    </tr>
    </tbody>
</table>

<script type="text/javascript">
    var lll = <?php echo count($stageItems); ?>;
    $(function () {


        $(".btnSaveParam").click(function () {

            $("#messageSave").html('');
            $.ajax({
                url: "_ajax_parameters.php",
                type: "POST",
                data: {
                    'function':'saveParameter',
                    'param': $(this).data('param'),
                    'value':$("#editParam_"+$(this).data('param')).val()

                }
            }).done(function (data) {
                    console.log(data);

                    $("#messageSave").html('<span class="label label-important">dados salvos!!!</span>');

                });


        });

        $.fn.modalmanager.defaults.resize = true;


        $('.datetimepicker').datetimepicker({
            language: 'pt-BR'
        });
		
		$('.datepicker').datetimepicker({
		  pickTime: false
		});

        $("#btnSave").click(function () {
            $("#txtMessage").html('aguarde...');
            var dados = {};
            for (var i = 0; i < lll; i++) {
				console.log("item " + $("#stageElement" + i).data('id'));
                dados[$("#stageElement" + i).data('id').toString()] = {start: $("#dateStart" + i).val(), end: $("#dateEnd" + i).val() }
            }


            $.ajax({
                url: "_ajax_stages.php",
                type: "POST",
                data: {
                    'dados': JSON.stringify(dados)
                }
            }).done(function (data) {
                    console.log(data);
                    $("#txtMessage").html('dados_salvos!!!');



                });

            console.log(dados);
        })


    });
</script>

<?php
require_once "_footer.php";
?>
