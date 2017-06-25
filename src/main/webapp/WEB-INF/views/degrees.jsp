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
						<li><a onClick="closeFloatingButton()" href="#"
							data-toggle="modal" data-target="#addModal">Add new degrees</a></li>
						<li><a onClick="editMode()">Edit existing degrees</a></li>
						<li><a onClick="deleteMode()">Delete existing degrees</a></li>
					</ul>
				</div>
			</div>
			<div class="btn-floating" id="help-actions-cancel"
				style="display: none;">
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
						<div class="card-header">
							<div class="hidden-xs">
								Degrees List&nbsp;
								<kbd style="display: none;" id="mode"></kbd>
							</div>
							<div class="visible-xs hidden-md">
								<br> <br>
							</div>
						</div>
						<div id="edit_container" style="display: none;"
							class="container-fluid">
							<div class="alert alert-success"
								style="overflow: hidden; white-space: nowrap;">
								<strong>You're in Edit Mode!</strong> <a href="#"
									data-toggle="tooltip"
									title="Highlight all records to be modified
								by clicking on them. Then, click on the 'Edit Selected Records'
								to begin editing."><button
										class="btn btn-xs btn-primary">?</button></a>
							</div>
							<div class="container-fluid">
								<button onClick="startEdit()" id="btn_editselrecs"
									class="btn btn-sm btn-primary">Edit Selected Records</button>
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
								<button id="btn_deleteselrecs" onClick="startDelete()"
									class="btn btn-sm btn-danger">Delete Selected Records</button>
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
										<th>Degree ID</th>
										<th>Degree Code</th>
										<th>Degree Name</th>
										<th>Degree Curriculum</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="degrees"
										items='${requestScope["degrees_degrees-list"]}'>
										<tr>
											<c:forEach var="degree" items="${degrees}" varStatus="loop">
												<c:choose>
													<c:when test="${loop.index=='0'}">
														<th scope="row"><c:out value="${degree}" /></th>
													</c:when>
													<c:when test="${loop.index=='3'}">
														<c:set var="curriculum_match" scope="session"
															value="false" />
														<c:forEach var="curriculums"
															items='${requestScope["degrees_curriculums-list"]}'>
															<c:if test="${curriculum_match == 'false' }">
																<c:forEach var="curriculum" items="${curriculums}"
																	varStatus="loop2">
																	<c:choose>
																		<c:when test="${loop2.index=='0'}">
																			<c:choose>
																				<c:when test="${degree==curriculum}">
																					<c:set var="curriculum_match" scope="session"
																						value="true" />
																				</c:when>
																			</c:choose>
																		</c:when>

																		<c:when test="${loop2.index=='1'}">
																			<c:choose>
																				<c:when test="${curriculum_match == 'true'}">
																					<td id="curr_<c:out value="${degree}" />"><c:out value="${curriculum}" /></td>
																				</c:when>
																			</c:choose>
																		</c:when>
																	</c:choose>
																</c:forEach>
															</c:if>
														</c:forEach>
														<c:choose>
															<c:when test="${curriculum_match == 'false'}">
																<td id="curr_0">NOT SET</td>
															</c:when>
														</c:choose>
													</c:when>
													<c:otherwise>
														<td><c:out value="${degree}" /></td>
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
					<h4 class="modal-title">Add New Degree</h4>
				</div>
				<div class="modal-body">
					<form id="addform" class="form form-horizontal" method="POST"
						action="degrees_add">
						<div class="section">
							<div class="section-body">
								<div class="form-group">
									<label class="col-md-3 control-label">Degree ID</label>
									<div class="col-md-9">
										<input id="add_degreeid" name="degreeid" type="text"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Degree Code</label>
									<div class="col-md-9">
										<input id="add_degreecode" name="degreecode" type="text"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Degree Name</label>
									<div class="col-md-9">
										<input id="add_degreename" name="degreename" type="text"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Degree Curriculum</label>
									<div class="col-md-4">
										<div class="input-group">
											<select id="degreecurriculum" name="degreecurriculum"
												class="select2">
												<option value="0">None</option>
												<c:forEach var="curriculums"
													items='${requestScope["degrees_curriculums-list"]}'>
													<c:forEach var="curriculum" items="${curriculums}"
														varStatus="loop">
														<c:choose>
															<c:when test="${loop.index=='0'}">
																<option value=<c:out value="${curriculum}" />>
															</c:when>
															<c:when test="${loop.index=='1'}">
																<c:out value="${curriculum}" />
																</option>
															</c:when>
														</c:choose>
													</c:forEach>
												</c:forEach>
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
					<button onClick="addDegree()" type="button"
						class="btn btn-sm btn-success">Add Account</button>
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
					<h4 class="modal-title">Edit Account</h4>
				</div>
				<div class="modal-body">
					<form id="editform" class="form form-horizontal" method="POST"
						action="degrees_edit">
						<div class="section">
							<div class="section-body">
								<div class="form-group">
									<label class="col-md-3 control-label">Degree ID</label>
									<div class="col-md-9">
										<input id="edit_degreeid" name="degreeid" type="text"
											class="form-control" placeholder="" disabled>
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Degree Code</label>
									<div class="col-md-9">
										<input id="edit_degreecode" name="degreecode" type="text"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Degree Name</label>
									<div class="col-md-9">
										<input id="edit_degreename" name="degreename" type="text"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Degree Curriculum</label>
									<div class="col-md-4">
										<div class="input-group">
											<select id="edit_degreecurriculum" name="degreecurriculum"
												class="select2">
												<option value="0">None</option>
												<c:forEach var="curriculums"
													items='${requestScope["degrees_curriculums-list"]}'>
													<c:forEach var="curriculum" items="${curriculums}"
														varStatus="loop">
														<c:choose>
															<c:when test="${loop.index=='0'}">
																<option value="<c:out value="${curriculum}" />">
															</c:when>
															<c:when test="${loop.index=='1'}">
																<c:out value="${curriculum}" />
																</option>
															</c:when>
														</c:choose>
													</c:forEach>
												</c:forEach>
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
					<button onClick="confirmEdit()" type="button"
						class="btn btn-sm btn-success">Save</button>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="editCloseModal" role="dialog"
		aria-labelledby="addModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">Confirm Cancel</h4>
				</div>
				<div class="modal-body">Cancel editing?</div>
				<div class="modal-footer">
					<button type="button" onClick="startEdit()"
						class="btn btn-sm btn-default" data-dismiss="modal">No</button>
					<button type="button" onClick="cancelEdit()"
						class="btn btn-sm btn-success" data-dismiss="modal">Yes</button>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="deleteModal" role="dialog"
		aria-labelledby="addModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">Confirm Delete</h4>
				</div>
				<div class="modal-body">Are you sure you want to delete the
					selected records?</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-sm btn-default"
						data-dismiss="modal">No</button>
					<button type="button" onClick="confirmDelete()"
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
		$("ul.sidebar-nav > li:eq(${requestScope.menuactivenum})").addClass("active");
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
		function reloadTable() {
			closeFloatingButton();
			toggleTableLoad();
			$('table').DataTable().clear().draw();
			$
					.ajax({
						type : 'POST',
						url : 'degrees_reloadtable',
						success : function(data) {
							$('#ajax_result').html(data);
							toggleTableLoad();
							$("table tr td:nth-child(4)").each(function () {
								var temp_id = $(this).html();
								$(this).html($("#degreecurriculum option[value='" + $(this).html() + "']").text());
								$(this).attr('id', temp_id);
								if($(this).html() == "None" || $(this).html() == ""){
									$(this).html("NOT SET");
									$(this).attr('id', 0);
								}
							});
							if ($('table tr td:first-child').text() != "No data available in table") {
								$('table tr td:first-child').replaceTag(
										"<th scope='row'>", false);
							}
						},
						error : function(data) {
							//$('#result').html(data);
							alert(data);
						}
					});

		}
		function addDegree() {
			$("#addform").submit();
		}
		var highlight_degreeids = [];
		var highlight_degreecodes = [];
		var highlight_degreenames = [];
		var highlight_degreecurriculums = [];
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
							highlight_degreeids[0] = $(this).children('th')
									.text();
							highlight_degreecodes[0] = $(this).children(
									'td:eq(0)').text();
							highlight_degreenames[0] = $(this).children(
									'td:eq(1)').text();
							highlight_degreecurriculums[0] = $(this).children(
									'td:eq(2)').val();
							$(this).addClass('highlight').siblings()
									.removeClass('highlight');
						});
			} else if (state == 2) {
				$('table').off('click');
				$('table')
						.on(
								'click',
								'tbody tr',
								function(event) {
									if ($(this).hasClass('highlight')) {
										for (var i = highlight_degreeids.length - 1; i >= 0; i--) {
											if (highlight_degreeids[i] == $(
													this).children('th').text()) {
												highlight_degreeids
														.splice(i, 1);
												highlight_degreecodes.splice(i,
														1);
												highlight_degreenames.splice(i,
														1);
												highlight_degreecurriculums
														.splice(i, 1);

											}
										}
										$(this).removeClass('highlight')
									} else {
										highlight_degreeids.push($(this)
												.children('th').text());
										highlight_degreecodes.push($(this)
												.children('td:eq(0)').text());
										highlight_degreenames.push($(this)
												.children('td:eq(1)').text());
										highlight_degreecurriculums
												.push($(this).children(
														'td:eq(2)').attr('id').replace("curr_", ""));
										$(this).addClass('highlight');
									}
								});
			}
		}

		function removeTableHighlights() {
			resetVariables();
			$('table tbody tr').removeClass('highlight');
		}

		function resetVariables() {
			highlight_degreeids = [];
			highlight_degreecodes = [];
			highlight_degreenames = [];
			highlight_degreecurriculums = [];
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
		var highlight_users_count = 0;
		var highlight_users_count_total = 0;
		function startEdit() {
			if (highlight_degreeids.length > 0) {
				highlight_users_count = 0;
				highlight_users_count_total = highlight_degreeids.length;
				$("#edit_degreeid").val(
						highlight_degreeids[highlight_users_count]);
				$("#edit_degreecode").val(
						highlight_degreecodes[highlight_users_count]);
				$("#edit_degreename").val(
						highlight_degreenames[highlight_users_count]);
				$("#edit_degreecurriculum").val(
						highlight_degreecurriculums[highlight_users_count])
						.change();
				$('#editModal').modal({
					backdrop : 'static',
					keyboard : false
				})
				$('#editModal')
						.on(
								'hidden.bs.modal',
								function() {
									$("#edit_degreeid").val("");
									$("#edit_degreecode").val("");
									$("#edit_degreename").val("");
									$("#edit_degreecurriculum :nth-child(0)")
											.prop('selected', true);
									if (highlight_users_count < highlight_users_count_total) {
										$("#edit_degreeid")
												.val(
														highlight_degreeids[highlight_users_count]);
										$("#edit_degreecode")
												.val(
														highlight_degreecodes[highlight_users_count]);
										$("#edit_degreename")
												.val(
														highlight_degreenames[highlight_users_count]);
										$("#edit_degreecurriculum")
												.val(
														highlight_degreecurriculums[highlight_users_count])
												.change();
										$('#editModal').modal({
											backdrop : 'static',
											keyboard : false
										})
									} else {
										cancelAnyMode();
										resetVariables();
									}
								});
			}
		}
		function cancelEdit() {
			$('#editModal').off('hidden.bs.modal');
			$('#editModal').modal('hide');
		}
		function confirmEdit() {
			$("#editform").notify('Saving...', {
				className : 'info',
				clickToHide : false,
				autoHide : false
			});
			$("#edit_degreeid").prop("disabled", false);
			var editform_values = $("#editform").serialize();
			$("#edit_degreeid").prop("disabled", true);
			setTimeout(function() {
				$.ajax({
					type : 'POST',
					data : editform_values,
					url : 'degrees_edit',
					success : function(data) {
						highlight_users_count++;
						$('.notifyjs-wrapper').trigger('notify-hide');
						$("#editModal").modal("hide");
						$('#ajax_result').html(data);
						reloadTable();
					},
					error : function(data) {
						//$('#result').html(data);
						alert(data);
					}
				});
			}, 1500);
		}
		function cancelAnyMode() {
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
		function startDelete() {
			if (highlight_degreeids.length > 0) {
				$('#deleteModal').modal('show');
			}
		}
		function confirmDelete() {
			$.notify('Deleting records...', {
				className : 'info',
				clickToHide : false,
				autoHide : false
			});
			$.ajax({
				type : 'POST',
				data : {
					degreeids : String(highlight_degreeids)
				},
				url : 'degrees_delete',
				success : function(data) {
					$('.notifyjs-wrapper').trigger('notify-hide');
					$('#ajax_result').html(data);
					cancelAnyMode();
					resetVariables();
					reloadTable();
				},
				error : function(data) {
					//$('#result').html(data);
					alert(data);
				}
			});
		}
	</script>
</body>

</html>