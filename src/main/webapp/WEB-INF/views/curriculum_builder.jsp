<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="true"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<title>School Management System - Curriculum Builder</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Head Initialization -->
<%@ include file="include/head_ini.jsp"%>

</head>
<body>
	<div id="nanobar-container"></div>


	<div class="app app-default">

		<!-- SIDEBAR NAVIGATION -->
		<%@ include file="include/aside.jsp"%>

		<div class="app-container">

			<%@ include file="include/nav.jsp"%>

			<div class="btn-floating" id="help-actions">
				<div class="btn-bg"></div>
				<button type="button" class="btn btn-default btn-toggle"
					data-toggle="toggle" data-target="#help-actions">
					<i class="icon fa fa-navicon (alias)"></i> <span class="help-text">Shortcut</span>
				</button>
				<div class="toggle-content">
					<ul class="actions">
						<li><a onClick="reloadTable()">Refresh</a></li>
						<li><a onClick="closeFloatingButton()" href="#" data-toggle="modal" data-target="#addModal">Add new curriculum</a></li>
						<li><a onClick="editMode()">Edit existing curriculum</a></li>
						<li><a onClick="deleteMode()">Delete existing curriculum</a></li>
					</ul>
				</div>
			</div>
			<div class="btn-floating" id="help-actions-cancel" style="display: none;">
				<div class="btn-bg"></div>
				<button type="button" class="btn btn-default btn-toggle"
					data-toggle="toggle" data-target="#help-actions-cancel">
					<i class="icon fa fa-close (alias)"></i> <span class="help-text">Shortcut</span>
				</button>
				<div class="toggle-content">
					<ul class="actions">
						<li><a onClick="cancelAnyMode()">Cancel</a></li>
					</ul>
				</div>
			</div>

			<div class="row">
				<div class="col-xs-12">
					<div class="card">
						<div class="card-header">List of current curriculums&nbsp;
							<kbd style="display: none;" id="mode"></kbd>
						</div>
						<div id="edit_container" style="display: none;"
							class="container-fluid">
							<div class="alert alert-success"
								style="overflow: hidden; white-space: nowrap;">
								<strong>You're in Edit Mode!</strong> Highlight all records to be modified
								by clicking on them. Then, click on the "Edit Selected Records"
								to begin editing.
							</div>
							<div class="container-fluid">
								<button onClick="startEdit()" id="btn_editselrecs" class="btn btn-sm btn-primary">Edit
									Selected Records</button>
							</div>
						</div>
						
						<div id="delete_container" style="display: none;"
							class="container-fluid">
							<div class="alert alert-warning"
								style="overflow: hidden; white-space: nowrap;">
								<strong>You're in Delete Mode!</strong> <a href="#"
									data-toggle="tooltip"
									title="Highlight all records to be deleted
								by clicking on them. Then, click on the 'Delete Selected Records'
								to delete all selected records. NOTE: Once you delete them, it CANNOT BE UNDONE!"><button
										class="btn btn-xs btn-primary">?</button></a>
							</div>
							<div class="container-fluid">
								<button id="btn_deleteselrecs" class="btn btn-sm btn-danger">Delete
									Selected Records</button>
							</div>
						</div>

						<div id="table_container" class="card-body __loading">
							<div class="loader-container text-center">
								<div class="icon">
									<div class="sk-wave">
										<div class="sk-rect sk-rect1"></div>
										<div class="sk-rect sk-rect2"></div>
										<div class="sk-rect sk-rect3"></div>
										<div class="sk-rect sk-rect4"></div>
										<div class="sk-rect sk-rect5"></div>
									</div>
								</div>
								<div class="title">Loading</div>
							</div>
							<table id="datatables"
								class="datatable table table-striped table-bordered table-hover"
								cellspacing="0" width="100%">
								<thead>
									<tr>
										<th>Curriculum ID</th>
										<th>Curriculum Code</th>
										<th>Years</th>
										<th>Terms per year</th>
										<th>Units</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="subjects"
										items='${requestScope["curriculum_curriculum-list"]}'>
										<tr>
											<c:forEach var="subject" items="${curriculum}" varStatus="loop">
												<c:choose>
													<c:when test="${loop.index=='0'}">
														<th scope="row"><c:out value="${curriculum}" /></th>
													</c:when>
													<c:otherwise>
														<td><c:out value="${curriculum}" /></td>
													</c:otherwise>
												</c:choose>
											</c:forEach>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>

			<%@ include file="include/footer.jsp"%>
		</div>

	</div>

	<!-- Modals -->
	<div class="modal fade" id="addModal" role="dialog"
		aria-labelledby="addModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">Add New Curriculum</h4>
				</div>
				<div class="modal-body">
					<form id="addform" class="form form-horizontal">
						<div class="section">
							<div class="section-body">
								<div class="form-group">
									<label class="col-md-3 control-label">Curriculum ID</label>
									<div class="col-md-9">
										<input id="add_curriculumid" name="curriculumid" type="number"
											class="form-control" placeholder="" disabled>
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Curriculum Code</label>
									<div class="col-md-9">
										<input id="add_curriculumcode" name="curriculumcode" type="text"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Years</label>
									<div class="col-md-9">
										<input id="add_years" name="years" type="number"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Terms per year</label>
									<div class="col-md-9">
										<input id="add_termsperyear" name="termsperyear" type="number"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Units</label>
									<div class="col-md-9">
										<input id="add_units" name="units" type="number"
											class="form-control" placeholder="">
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-sm btn-default"
						data-dismiss="modal">Close</button>
					<button onClick="addCurriculum()" type="button"
						class="btn btn-sm btn-success">Add Curriculum</button>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="editModal" role="dialog"
		aria-labelledby="addModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">Edit Curriculum</h4>
				</div>
				<div class="modal-body">
					<form id="editform" class="form form-horizontal" method="POST" action="curriculum_edit">
						<div class="section">
							<div class="section-body">
								<div class="form-group">
									<label class="col-md-3 control-label">Curriculum ID</label>
									<div class="col-md-9">
										<input id="edit_curriculumid" name="curriculumid" type="number" class="form-control" placeholder="" disabled>
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Curriculum Code</label>
									<div class="col-md-9">
										<input id="edit_curriculumcode" name="curriculumcode" type="text" class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Years</label>
									<div class="col-md-9">
										<input id="edit_years" name="years" type="number" class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Terms per year</label>
									<div class="col-md-9">
										<input id="edit_termsperyear" name="termsperyear" type="number" class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Unit(s)</label>
									<div class="col-md-9">
										<input id="edit_units" name="units" type="number" class="form-control" placeholder="">
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-sm btn-default"
						data-toggle="modal" data-target="#editCloseModal">Close</button>
					<button onClick="highlight_curriculum_count++;" type="button"
						class="btn btn-sm btn-success">Save</button>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="editCloseModal" role="dialog" aria-labelledby="addModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">Confirm Cancel</h4>
				</div>
				<div class="modal-body">
					Cancel editing?
				</div>
				<div class="modal-footer">
					<button type="button" onClick="startEdit()" class="btn btn-sm btn-default"
						data-dismiss="modal">No</button>
					<button type="button" onClick="cancelEdit()"
						class="btn btn-sm btn-success" data-dismiss="modal">Yes</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- AJAX RESULT CONTAINER -->
	<div id="ajax_result"></div>

	<!-- INITIALIZE BELOW -->
	<%@ include file="include/below_ini.jsp"%>

	<!-- Setup Active Menu in Sidebar -->
	<script>
		$("ul.sidebar-nav > li:eq(4)").addClass("active");
	</script>

	<!-- Script execution when page is done -->
	<script>
		$(document).ready(function() {
			toggleTableLoad();
		});
	</script>

	<!-- Other Scripts -->
	<script>
		function closeFloatingButton() {
			$('#help-actions').removeClass('active');
			$('#help-actions-cancel').removeClass('active');
		}
		function toggleTableLoad() {
			closeFloatingButton();
			if ($("#table_container").hasClass("__loading")) {
				$("#table_container").removeClass("__loading");
			} else {
				$("#table_container").addClass("__loading");
			}
		}
 		function reloadTable(){
			closeFloatingButton();
			toggleTableLoad();
			$('table').DataTable().clear().draw();
			$.ajax({
				type : 'POST',
				url : 'curriculum_reloadtable',
				success : function(data) {
					$('#ajax_result').html(data);
					toggleTableLoad();
					$('table tr td:first-child').replaceTag("<th scope='row'>", false);
				},
				error : function(data) {
					//$('#result').html(data);
					alert("Error: " + data);
					$("#table_container").removeClass("__loading");
				}
			});
		} 
		function addCurriculum() {
			if ( $('#add_curriculumcode').val() != '' || $('#add_years').val() != '' || $('#add_termsperyear').val() != '' || $('#add_units').val() != ''){
				var curriculumData = $('#addform').serialize(); 
				$.ajax({
					type: 'POST',
					url: 'curriculum_add',
					data: curriculumData,
					cache: false,
					success: function(data){
						alert(data);
					},
					error : function(data) {
						alert("Error: " + data);
						}
				});
			}
		}
		var highlight_curriculumid = [];
		var highlight_curriculumcode = [];
		var highlight_years = [];
		var highlight_termsperyear = [];
		var highlight_units = [];
		function toggleTableHighlighter(state) {
			//State 0 turns off Table Highlighter feature completely
			//State 1 turns on single Table Highlighter feature
			//State 2 turns on multiple Table Highlighter feature
			if (state == 0) {
				removeTableHighlights();
				$('table').off('click');
			} else if (state == 1) {
				$('table').off('click');
				$('table').on(
						'click',
						'tbody tr',
						function(event) {
							highlight_curriculumid[0] = $(this).children('th').text();
							highlight_curriculumcode[0] = $(this).children('td:eq(0)').text();
							highlight_years[0] = $(this).children('td:eq(1)').text();
							highlight_termsperyear[0] = $(this).children('td:eq(2)').text();
							highlight_units[0] = $(this).children('td:eq(3)').text();
							$(this).addClass('highlight').siblings().removeClass('highlight');
						});
			} else if (state == 2) {
				$('table').off('click');
				$('table')
						.on(
								'click',
								'tbody tr',
								function(event) {
									if ($(this).hasClass('highlight')) {
										for (var i = highlight_curriculumid.length - 1; i >= 0; i--) {
											if (highlight_curriculumid[i] == $(this).children('th').text()) {
												highlight_curriculumid.splice(i, 1);
												highlight_curriculumcode.splice(i, 1);
												highlight_years.splice(i, 1);
												highlight_termsperyear.splice(i, 1);
												highlight_units.splice(i, 1);
												
											}
										}
										$(this).removeClass('highlight')
									} else {
										highlight_curriculumid.push($(this).children('th').text());
										highlight_curriculumcode.push($(this).children('td:eq(0)').text());
										highlight_years.push($(this).children('td:eq(1)').text());
										highlight_termsperyear.push($(this).children('td:eq(2)').text());
										highlight_units.push($(this).children('td:eq(3)').text());
										$(this).addClass('highlight');
									}
								});
			}
		}

		function removeTableHighlights() {
			highlight_curriculumid = [];
			$('table tbody tr').removeClass('highlight');
		}

		function editMode() {
			closeFloatingButton();
			$('#help-actions').hide();
			$('#help-actions-cancel').show(500);
			toggleTableHighlighter(2);
			$('#mode').show();
			$('#mode').text("EDIT MODE");
			$('#edit_container').show(1000);
		}
		var highlight_curriculum_count = 0;
		var highlight_curriculum_count = 0;
		function startEdit() {
			highlight_curriculum_count = 0;
			highlight_curriculum_count_total = highlight_curriculumid.length;
			$("#edit_curriculumid").val(highlight_curriculumid[highlight_curriculum_count]);
			$("#edit_coursecode").val(highlight_curriculumcode[highlight_curriculum_count]);
			$("#edit_coursecode").val(highlight_years[highlight_curriculum_count]);
			$("#edit_coursecode").val(highlight_termsperyear[highlight_curriculum_count]);
			$("#edit_accttype").val(highlight_units[highlight_curriculum_count]).change();
			$('#editModal').modal({
			    backdrop: 'static',
			    keyboard: false
			})
			$('#editModal').on('hidden.bs.modal', function(){
				if(highlight_curriculum_count < highlight_curriculum_count_total){
					$("#edit_curriculumid").val(highlight_id[highlight_curriculum_count]);
					$("#edit_curriculumcode").val(highlight_curriculumcode[highlight_curriculum_count]);
					$("#edit_years").val(highlight_years[highlight_curriculum_count]);
					$("#edit_termsperyear").val(highlight_termsperyear[highlight_curriculum_count]);
					$("#edit_units").val(highlight_units[highlight_curriculum_count]);
					$('#editModal').modal({
					    backdrop: 'static',
					    keyboard: false
					})
				}
			});
		}
		function cancelEdit(){
			$('#editModal').off('hidden.bs.modal');
			$('#editModal').modal('hide');
		}
		function cancelAnyMode(){
			$('#help-actions').show(500);
			$('#help-actions-cancel').hide();
			toggleTableHighlighter(0);
			$('#mode').hide();
			$('#mode').text("");
			$('#edit_container').hide(1000);
			$('#delete_container').hide(1000);
		}
		function deleteMode() {
			closeFloatingButton();
			$('#help-actions').hide();
			$('#help-actions-cancel').show(500);
			toggleTableHighlighter(2);
			$('#mode').show();
			$('#mode').text("DELETE MODE");
			$('#delete_container').show(1000);
		}
	</script>
</body>

</html>