<?php
require_once "_header.php";
?>


    <div class="well  pagination-centered">Lista de Usuários</div>
    <div>
        <a href="javascript:void(0);" class="btn btn-danger " id="btnNewuser">
            <div class="icon-user"></div>
            Novo Registro
        </a>
    </div>
    <hr>
    <div id="div1"></div>
    <div id="responsiveWindowEditContent" class="modal hide fade" tabindex="-1" data-width="740">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3>Usuários</h3>
        </div>
        <div class="modal-body">
            <form id='leForm'>
                <div class="controls controls-row">
                    <div class="control-group span2">
                        <label class=" ">Id:</label>

                        <div class=" ">
                            <input id="content_id" name="content_id" type="text" placeholder="" class="input-small"
                                   disabled="disabled">
                        </div>
                    </div>

                </div>
                <div class="controls controls-row">
                    <div class="control-group span6">
                        <label class="  ">Nome:</label>

                        <div class=" ">
                            <input id="content_nome" name="content_nome" type="text" placeholder=""
                                   class="input-xxlarge">
                        </div>
                    </div>
                </div>

                <div class="controls controls-row">
                    <div class="control-group span6">
                        <label class="  ">Email:</label>

                        <div class=" ">
                            <input id="content_email" name="content_email" type="text" placeholder=""
                                   class="input-xxlarge">
                        </div>
                    </div>
                </div>

                <div class="controls controls-row">
                    <div class="control-group span2">
                        <label class=" ">CPF:</label>

                        <div class=" ">
                            <input id="content_cpf" name="content_cpf" type="text" placeholder="" class="input-medium">
                        </div>
                    </div>
                    <div class="control-group span2">
                        <label class="  ">Login:</label>

                        <div class=" ">
                            <input id="content_login" name="content_login" type="text" placeholder=""
                                   class="input-medium">
                        </div>
                    </div>
                    <div class="control-group span2">
                        <label class=" ">Senha:</label>

                        <div class=" ">
                            <input id="content_senha" name="content_senha" type="text" placeholder=""
                                   class="input-medium">
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" data-dismiss="modal" class="btn">Fechar</button>
            <button type="button" data-dismiss="modal" class="btn btn-primary" id="saveContent">Salvar</button>
        </div>
    </div>


    <script type="text/javascript">
    var listUserTable;
    $(document).ready(function () {

        $("#btnNewuser").unbind('click').click(function () {
            console.log("foi");
            $("#leForm :input").each(function () {
                $(this).val('');
            });
            $('#responsiveWindowEditContent').modal();

        });
        $("#saveContent").unbind('click').click(function () {
            var leRes = {};
            $.each($("#leForm input,#leForm textarea,#leForm select"), function (k, v) {
                leRes[$(v).attr('id')] = $(v).val();
            });
            console.log("save");
            $.ajax({
                url: "ajax/_userList.php",
                type: "POST",
                data: {
                    function: $("#content_id").val() == "" ? "insertUser" : "updateUser",
                    data: JSON.stringify(leRes)
                }
            }).done(function (data) {
                    console.log(data);
                    getData();
                });

        });

        //An example with all options.
        listUserTable = $('#div1').WATable({
            pageSize: 50,                //Sets the initial pagesize
            filter: true,               //Show filter fields
            columnPicker: true,         //Show the columnPicker button
            pageSizes: [10, 20, 50, 100, 200],  //Set custom pageSizes. Leave empty array to hide button.
            hidePagerOnEmpty: true,     //Removes the pager if data is empty.
            checkboxes: true,           //Make rows checkable. (Note. You need a column with the 'unique' property)
            preFill: true,              //Initially fills the table with empty rows (as many as the pagesize).
            //url: '/someWebservice'    //Url to a webservice if not setting data manually as we do in this example
            //urlData: { report:1 }     //Any data you need to pass to the webservice
            //urlPost: true             //Use POST httpmethod to webservice. Default is GET.
            types: {                    //Following are some specific properties related to the data types
                string: {
                    // filterTooltip: "Giggedi..." ,   //What to say in tooltip when hoovering filter fields. Set false to remove.
                    placeHolder: "Filtro"    //What to say in placeholder filter fields. Set false for empty.
                },
                number: {
                    decimals: 1   //Sets decimal precision for float typges
                },
                bool: {
                    //filterTooltip: false
                },
                date: {
                    utc: true,            //Show time as universal time, ie without timezones.
                    //format: 'yy/dd/MM',   //The format. See all possible formats here http://arshaw.com/xdate/#Formatting.
                    datePicker: true      //Requires "Datepicker for Bootstrap" plugin (http://www.eyecon.ro/bootstrap-datepicker).
                }
            },
            actions: {                //This generates a button where you can add elements.
                filter: true,         //If true, the filter fields can be toggled visible and hidden.
                columnPicker: true,   //if true, the columnPicker can be toggled visible and hidden.
                custom: [             //Add any other elements here. Here is a refresh and export example.
                    $('<a href="#" class="refresh"><i class="icon-refresh"></i>&nbsp;Atualizar</a>'),
                    $('<a href="#" class="export_all"><i class="icon-share"></i>&nbsp;Exportar Todos</a>'),
                    $('<a href="#" class="export_checked"><i class="icon-share"></i>&nbsp;Exportar Linhas Selecionadas</a>'),
                    $('<a href="#" class="export_filtered"><i class="icon-share"></i>&nbsp;Exportar Linhas Filtradas</a>')
                ]
            },
            tableCreated: function (data) {    //Fires when the table is created / recreated. Use it if you want to manipulate the table in any way.
                //  console.log('table created'); //data.table holds the html table element.
                // console.log(data);            //'this' keyword also holds the html table element.
            },
            rowClicked: function (data) {      //Fires when a row is clicked (Note. You need a column with the 'unique' property).
                // console.log('row clicked');   //data.event holds the original jQuery event.
                // console.log(data);            //data.row holds the underlying row you supplied.
                //data.column holds the underlying column you supplied.
                //data.checked is true if row is checked.
                //'this' keyword holds the clicked element.
                if ($(this).hasClass('userId')) {
                    // data.event.preventDefault();
                    // alert('You clicked userId: ' + data.row.userId);
                }
            },
            columnClicked: function (data) {    //Fires when a column is clicked
                // console.log('column clicked');  //data.event holds the original jQuery event
                // console.log(data);              //data.column holds the underlying column you supplied
                //data.descending is true when sorted descending (duh)
            },
            pageChanged: function (data) {      //Fires when manually changing page
                // console.log('page changed');    //data.event holds the original jQuery event
                // console.log(data);              //data.page holds the new page index
            },
            pageSizeChanged: function (data) {  //Fires when manually changing pagesize
                // console.log('pagesize changed');//data.event holds teh original event
                // console.log(data);              //data.pageSize holds the new pagesize
            }
        }).data('WATable');  //This step reaches into the html data property to get the actual WATable object. Important if you want a reference to it as we want here.

        //Generate some data
        var data = getData();

        //listUserTable.setData(data, true); //Sets the data but prevents any previously set columns from being overwritten
        //listUserTable.setData(data, false, false); //Sets the data and prevents any previously checked rows from being reset

        var allRows = listUserTable.getData(false); //Gets the data you previously set.
        var checkedRows = listUserTable.getData(true); //Gets the data you previously set, but with checked rows only.
        var filteredRows = listUserTable.getData(false, true); //Gets the data you previously set, but with filtered rows only.

        var pageSize = listUserTable.option("pageSize"); //Get option
        //listUserTable.option("pageSize", pageSize); //Set option

        //Example event handler triggered by the custom refresh link above.
        $('body').on('click', '.refresh', function (e) {
            e.preventDefault();
            getData();

        });
        //Example event handler triggered by the custom export links above.
        $('body').on('click', '.export_checked, .export_filtered, .export_all', function (e) {
            e.preventDefault();
            var elem = $(e.target);
            var data;
            if (elem.hasClass('export_all')) data = listUserTable.getData(false);
            else if (elem.hasClass('export_checked')) data = listUserTable.getData(true);
            else if (elem.hasClass('export_filtered')) data = listUserTable.getData(false, true);
            console.log(data.rows.length + ' rows returned');
            console.log(data);
            alert(data.rows.length + ' rows returned.\nSee console for details.');
        });

    });

    //Generates some data. This step is of course normally done by your web server.
    function getData() {

        $.ajax({
            url: "ajax/_userList.php",
            type: "POST",
            data: {
                function: "listUsers"
            }
        }).done(function (data) {
                console.log(data);

                //First define the columns
                var colsUserList = {
                    id: {
                        index: 1, //The order this column should appear in the table
                        type: "number", //The type. Possible are string, number, bool, date(in milliseconds).
                        friendly: "<i class='icon-user'>ID</i>",  //Name that will be used in header. Can also be any html as shown here.
                        format: "<a href='javascript:updateButtons({0});' class='userId userItem'  data-id='{0}' target='_blank'>{0}</a>", //Used to format the data anything you want. Use {0} as placeholder for the actual data.
                        unique: true,  //This is required if you want checkable rows, or to use the rowClicked callback. Be certain the values are really unique or weird things will happen.
                        sortOrder: "asc", //Data will initially be sorted by this column. Possible are "asc" or "desc"
                        tooltip: "ID" //Show some additional info about column

                    },
                    nome: {
                        index: 2,
                        type: "string",
                        friendly: "Nome",
                        tooltip: "", //Show some additional info about column
                        placeHolder: "filtro" //Overrides default placeholder and placeholder specified in data types(row 34).
                    },
                    email: {
                        index: 3,
                        type: "string",
                        friendly: "e-mail",
                        tooltip: "", //Show some additional info about column
                        filter: true //Removes filter field for this column
                    },
                    cpf: {
                        index: 4,
                        type: "string",
                        decimals: 2, //Force decimal precision
                        friendly: "CPF",
                        placeHolder: "",
                        tooltip: ""//Show some additional info about column
                        //  filterTooltip: false //Turn off tooltip for this column
                    },
                    login: {
                        index: 5,
                        type: "string",
                        friendly: "login",
                        tooltip: "", //Show some additional info about column
                        filter: true //Removes filter field for this column
                    },
                    qtdJogadas: {
                        index: 100, //The order this column should appear in the table
                        type: "number", //The type. Possible are string, number, bool, date(in milliseconds).
                        friendly: "Jogadas",  //Name that will be used in header. Can also be any html as shown here.
                        // format: "<a href='#' class='userId' target='_blank'>{0}</a>",  //Used to format the data anything you want. Use {0} as placeholder for the actual data.
                        unique: true,  //This is required if you want checkable rows, or to use the rowClicked callback. Be certain the values are really unique or weird things will happen.
                        sortOrder: "asc", //Data will initially be sorted by this column. Possible are "asc" or "desc"
                        tooltip: "ID" //Show some additional info about column

                    },
                    finalizados: {
                        index: 101, //The order this column should appear in the table
                        type: "number", //The type. Possible are string, number, bool, date(in milliseconds).
                        friendly: "Finalizados",  //Name that will be used in header. Can also be any html as shown here.
                        //format: "<a href='#' class='userId' target='_blank'>{0}</a>",  //Used to format the data anything you want. Use {0} as placeholder for the actual data.
                        unique: true,  //This is required if you want checkable rows, or to use the rowClicked callback. Be certain the values are really unique or weird things will happen.
                        sortOrder: "asc", //Data will initially be sorted by this column. Possible are "asc" or "desc"
                        tooltip: "ID" //Show some additional info about column

                    }

                    /*,


                     qtdJogadas,
                     as finalizados

                     height: {
                     type: "number",
                     friendly: "Height(cm)",
                     hidden:true //Hides the column. Useful if you want this value later on but no visible to user. It's available to be visible if columnPicker is enabled.
                     },
                     important: {
                     index: 5,
                     type: "bool",
                     friendly: "Important"
                     },
                     someDate: {
                     index: 6,
                     type: "date", //Don't forget dates are expressed in milliseconds
                     friendly: "SomeDate"
                     }  */
                };


                //Create the returning object. Besides cols and rows, you can also pass any other object you would need later on.
                var data = {
                    cols: colsUserList,
                    rows: $.parseJSON(data),
                    otherStuff: {
                        thatIMight: 1,
                        needLater: true
                    }
                };


                listUserTable.setData(data);  //Sets the data.

            });

    }

    function updateButtons(item) {
        //  event.preventDefault();
        $.ajax({
            url: "ajax/_userList.php",
            type: "POST",
            data: {
                function: "findUser",
                id: item
            }
        }).done(function (data) {
                console.log($.parseJSON(data));
                $.each($.parseJSON(data), function (k, v) {
                    $('#content_' + k).val(v);
                });

                $('#responsiveWindowEditContent').modal();


            });


    }

    </script>
<?php
require_once "_footer.php";
?>