<?php
require_once "_header.php";
?>
<div class="well text-center"><h2>Ranking de participação</h2></div>
<div id="rankingParticipacao"></div>
<div class="well text-center"><h2>Ranking de investimento</h2></div>
<div id="rankingInvestimento"></div>
<div class="well text-center"><h2>Ranking qualitativo</h2></div>
<div id="rankingQualitativo"></div>

<script type="text/javascript">

	function loadRanking(){

		$.ajax({
			 url: "../?r=content/AdminRanking",
			 type: "POST",
			 data: {
				 'dados': ''
			 }
		}).done(function (data) {
		
				var oRanking = jQuery.parseJSON(data);

				var tbl  = '';
				tbl += '<table class="table table-striped table-condensed table-bordered">';
				
				tbl += '<thead>';
				tbl += '<tr>';
				tbl += '	<th class="span1"><h5>rank</h5></th>';
				tbl += '	<th class="span1"><h5>id</h5></th>';
				tbl += '	<th class="span4"><h5>login</h5></th>';
				tbl += '	<th class="span4"><h5>nickname</h5></th>';
				tbl += '	<th class="span2"><h5>pontos</h5></th>';
				tbl += '</tr>';
				tbl += '</thead>';
				
				tbl += '<tbody>';

				
				var oParticipacao = oRanking['participacao']
				
				for (key in oParticipacao){
					itemParticipacao = oParticipacao[key];

				
					tbl += '<tr>';
					tbl += '	<td>'+ itemParticipacao['rank'] +'</td>';
					tbl += '	<td>'+ itemParticipacao['id'] +'</td>';
					tbl += '	<td>'+ itemParticipacao['login'] +'</td>';
					tbl += '	<td>'+ itemParticipacao['nickname'] +'</td>';
					tbl += '	<td>'+ Math.round(itemParticipacao['valor']) +'</td>';
					tbl += '</tr>';
				}

				tbl += '</tbody>';
				tbl += '</table>';

				$('#rankingParticipacao').html(tbl);
				
				
				tbl  = '';
				tbl += '<table class="table table-striped table-condensed table-bordered ">';
				
				tbl += '<thead>';
				tbl += '<tr>';
				tbl += '	<th class="span1"><h5>rank</h5></th>';
				tbl += '	<th class="span1"><h5>id</h5></th>';
				tbl += '	<th class="span4"><h5>login</h5></th>';
				tbl += '	<th class="span4"><h5>nickname</h5></th>';
				tbl += '	<th class="span2"><h5>pontos</h5></th>';
				tbl += '</tr>';
				tbl += '</thead>';
				
				tbl += '<tbody>';

				
				var oInvestimento = oRanking['investimento']
				
				for (key in oInvestimento){
					itemInvestimento = oInvestimento[key];

				
					tbl += '<tr>';
					tbl += '	<td>'+ itemInvestimento['rank'] +'</td>';
					tbl += '	<td>'+ itemInvestimento['id'] +'</td>';
					tbl += '	<td>'+ itemInvestimento['login'] +'</td>';
					tbl += '	<td>'+ itemInvestimento['nickname'] +'</td>';
					tbl += '	<td>'+ Math.round(itemInvestimento['valor']) +'</td>';
					tbl += '</tr>';
				}

				tbl += '</tbody>';
				tbl += '</table>';

				$('#rankingInvestimento').html(tbl);
				
				
				tbl  = '';
				tbl += '<table class="table table-striped table-condensed table-bordered ">';
				
				tbl += '<thead>';
				tbl += '<tr>';
				tbl += '	<th class="span1"><h5>rank</h5></th>';
				tbl += '	<th class="span1"><h5>id</h5></th>';
				tbl += '	<th class="span4"><h5>login</h5></th>';
				tbl += '	<th class="span4"><h5>nickname</h5></th>';
				tbl += '	<th class="span2"><h5>pontos</h5></th>';
				tbl += '</tr>';
				tbl += '</thead>';
				
				tbl += '<tbody>';

				
				var oQualitativo = oRanking['qualitativo']
				
				for (key in oQualitativo){
					itemQualitativo = oQualitativo[key];

				
					tbl += '<tr>';
					tbl += '	<td>'+ itemQualitativo['rank'] +'</td>';
					tbl += '	<td>'+ itemQualitativo['id'] +'</td>';
					tbl += '	<td>'+ itemQualitativo['login'] +'</td>';
					tbl += '	<td>'+ itemQualitativo['nickname'] +'</td>';
					tbl += '	<td>'+ Math.round(itemQualitativo['valor']) +'</td>';
					tbl += '</tr>';
				}

				tbl += '</tbody>';
				tbl += '</table>';

				$('#rankingQualitativo').html(tbl);
				
		});
	
	}

	loadRanking();
	
</script>




<?php
require_once "_footer.php";
?>
