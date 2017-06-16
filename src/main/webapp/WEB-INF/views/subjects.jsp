<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="true"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<title>School Management System - ${page_title}</title>

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
						<li><a onClick="closeFloatingButton()" href="#" data-toggle="modal" data-target="#addModal">Add new subject</a></li>
						<li><a onClick="editMode()">Edit existing subject</a></li>
						<li><a onClick="deleteMode()">Delete existing subject</a></li>
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
						<div class="card-header">Subjects List&nbsp;
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
								<strong>You're in Delete Mode!</strong> Highlight all records to be deleted
								by clicking on them. Then, click on the "Delete Selected Records"
								to delete all selected records. NOTE: Once you delete them, it CANNOT BE UNDONE!
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
										<th>ID</th>
										<th>Course Code</th>
										<th>Course Name</th>
										<th>Course Unit(s)</th>
										<th>Prerequisites</th>
									</tr>
								</thead>
								<tbody>
									<%-- <c:forEach var="accounts"
										items='${requestScope["accounts_accounts-list"]}'>
										<tr>
											<c:forEach var="records" items="${accounts}" varStatus="loop">
												<c:choose>
													<c:when test="${loop.index=='0'}">
														<th scope="row"><c:out value="${records}" /></th>
													</c:when>
													<c:otherwise>
														<td><c:out value="${records}" /></td>
													</c:otherwise>
												</c:choose>
											</c:forEach>
										</tr>
									</c:forEach> --%>
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
					<h4 class="modal-title">Add New Subject</h4>
				</div>
				<div class="modal-body">
					<form id="addform" class="form form-horizontal">
						<div class="section">
							<div class="section-body">
								<div class="form-group">
									<label class="col-md-3 control-label">ID</label>
									<div class="col-md-9">
										<input id="add_id" name="id" type="text" class="form-control" placeholder="" disabled>
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Course Code</label>
									<div class="col-md-9">
										<input id="add_coursecode" name="coursecode" type="text" class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Course Name</label>
									<div class="col-md-9">
										<input id="add_coursename" name="coursename" type="text" class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Course Unit(s)</label>
									<div class="col-md-9">
										<input id="add_courseunits" name="courseunits" type="number" class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Prerequisite(s)</label>
									<div class="col-md-4">
										<div class="input-group">
											<select id="add_prerequisites" name="prerequisites" class="select2">
												<option value="none">None</option>	
												<option value="sample1">Sample1</option>
												<option value="sample2">Sample2</option>
												<option value="sample3">Sample3</option>
											</select>
										</div>
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-sm btn-default"
						data-dismiss="modal">Close</button>
					<button onClick="addSubject()" type="button"
						class="btn btn-sm btn-success">Add Subject</button>
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
					<h4 class="modal-title">Edit Subject</h4>
				</div>
				<div class="modal-body">
					<form id="editform" class="form form-horizontal" method="POST" action="accounts_edit">
						<div class="section">
							<div class="section-body">
								<div class="form-group">
									<label class="col-md-3 control-label">ID</label>
									<div class="col-md-9">
										<input id="edit_id" name="id" type="text" class="form-control" placeholder="" disabled>
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Course Code</label>
									<div class="col-md-9">
										<input id="edit_coursecode" name="coursecode" type="text" class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Course Name</label>
									<div class="col-md-9">
										<input id="edit_coursename" name="coursename" type="text" class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Course Unit(s)</label>
									<div class="col-md-9">
										<input id="edit_courseunits" name="courseunits" type="number" class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Prerequisite(s)</label>
									<div class="col-md-4">
										<div class="input-group">
											<select id="edit_prerequisites" name="prerequisites" class="select2">
												<option value="none">None</option>	
												<option value="sample1">Sample1</option>
												<option value="sample2">Sample2</option>
												<option value="sample3">Sample3</option>
											</select>
										</div>
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-sm btn-default"
						data-toggle="modal" data-target="#editCloseModal">Close</button>
					<button onClick="highlight_subjects_count++;" type="button"
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
				url : 'accounts_reloadtable',
				success : function(data) {
					$('#ajax_result').html(data);
					toggleTableLoad();
					$('table tr td:first-child').replaceTag("<th scope='row'>", false);
				},
				error : function(data) {
					//$('#result').html(data);
					alert(data);
				}
			});
		} 
		function addSubject() {
			if ( $('#add_coursecode').val() != '' && $('#add_coursename').val() != '' && $('#add_courseunits').val() != ''){
				var subjectData = $('#addform').serialize(); 
				$.ajax({
					type: 'POST',
					url: 'subject_add',
					data: subjectData,
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
		var highlight_id = [];
		var highlight_coursecode = [];
		var highlight_coursename = [];
		var highlight_courseunits = [];
		var highlight_prerequisites = [];
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
							highlight_id[0] = $(this).children('th').text();
							highlight_coursecode[0] = $(this).children('td:eq(0)').text();
							highlight_coursename[0] = $(this).children('td:eq(1)').text();
							highlight_courseunits[0] = $(this).children('td:eq(2)').text();
							highlight_prerequisites[0] = $(this).children('td:eq(3)').text();
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
										for (var i = highlight_id.length - 1; i >= 0; i--) {
											if (highlight_id[i] == $(this).children('th').text()) {
												highlight_id.splice(i, 1);
												highlight_coursecode.splice(i, 1);
												highlight_coursename.splice(i, 1);
												highlight_courseunits.splice(i, 1);
												highlight_prerequisites.splice(i, 1);
												
											}
										}
										$(this).removeClass('highlight')
									} else {
										highlight_id.push($(this).children('th').text());
										highlight_coursecode.push($(this).children('td:eq(0)').text());
										highlight_coursename.push($(this).children('td:eq(1)').text());
										highlight_courseunits.push($(this).children('td:eq(2)').text());
										highlight_prerequisites.push($(this).children('td:eq(3)').text());
										$(this).addClass('highlight');
									}
								});
			}
		}

		function removeTableHighlights() {
			highlight_id = [];
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
		var highlight_subjects_count = 0;
		var highlight_subjects_count = 0;
		function startEdit() {
			highlight_subjects_count = 0;
			highlight_subjects_count_total = highlight_id.length;
			$("#edit_id").val(highlight_id[highlight_subjects_count]);
			$("#edit_coursecode").val(highlight_coursecode[highlight_subjects_count]);
			$("#edit_coursecode").val(highlight_coursename[highlight_subjects_count]);
			$("#edit_coursecode").val(highlight_courseunits[highlight_subjects_count]);
			$("#edit_accttype").val(highlight_prerequisites[highlight_subjects_count]).change();
			$('#editModal').modal({
			    backdrop: 'static',
			    keyboard: false
			})
			$('#editModal').on('hidden.bs.modal', function(){
				if(highlight_subjects_count < highlight_subjects_count_total){
					$("#edit_userid").val(highlight_id[highlight_subjects_count]);
					$("#edit_username").val(highlight_coursecode[highlight_subjects_count]);
					$("#edit_coursecode").val(highlight_coursename[highlight_subjects_count]);
					$("#edit_coursecode").val(highlight_courseunits[highlight_subjects_count]);
					$("#edit_accttype").val(highlight_prerequisites[highlight_subjects_count]).change();
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