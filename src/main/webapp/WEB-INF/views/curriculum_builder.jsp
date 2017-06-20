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

<style>
.sort_style {
	list-style: none;
	padding: 0;
	min-height: 100px;
	background: #e1f5fe;
}

.sort_style>li {
	display: inline-block;
	background: #eee;
	margin: 1px;
	padding: 5px 10px;
	cursor: grab;
}

.sortable-ghost {
	opacity: .6;
}
</style>
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
							data-toggle="modal" data-target="#addModal">Add new
								curriculum</a></li>
						<li><a onClick="editMode()">Edit existing curriculum</a></li>
						<li><a onClick="deleteMode()">Delete existing curriculum</a></li>
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
							List of current curriculums&nbsp;
							<kbd style="display: none;" id="mode"></kbd>
						</div>
						<div id="edit_container" style="display: none;"
							class="container-fluid">
							<div class="alert alert-success"
								style="overflow: hidden; white-space: nowrap;">
								<strong>You're in Edit Mode!</strong> Highlight all records to
								be modified by clicking on them. Then, click on the "Edit
								Selected Records" to begin editing.
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
									<c:forEach var="curriculums"
										items='${requestScope["curriculums_curriculums-list"]}'>
										<tr>
											<c:forEach var="curriculum" items="${curriculums}"
												varStatus="loop">
												<c:choose>
													<c:when test="${loop.index=='0'}">
														<th scope="row"><c:out value="${curriculum}" /></th>
														<c:set var="curriculum_id" scope="session"
															value="${curriculum}" />
													</c:when>
													<c:when test="${loop.index=='1'}">
														<th scope="row"><a href="javascript:void(0)"
															onClick="curriculumEditMode('<c:out value="${curriculum}" />', <c:out value = "${curriculum_id}"/>)"><c:out
																	value="${curriculum}" /></a></th>
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

			<div id="curriculum_editor" class="row" style="display: none;">
				<div class="col-xs-12">
					<div class="card">
						<div class="card-header">
							Curriculum Editor&nbsp;
							<kbd style="display: none;" id="curriculum_edit"></kbd>
						</div>

						<div id="table_container2" class="card-body">
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
								<div id="curriculum_editor_loadingmsg" class="title">Loading</div>
							</div>
							<div class="row">
								<button class="btn btn-xs btn-primary" onClick="toggleYearPanels(1)">Expand All</button>
								<button class="btn btn-xs btn-primary" onClick="toggleYearPanels(0)">Collapse All</button>
							</div>
							<div id="curriculum_fullcontainer">
								<div class="row">
									<div class="panel-group">
										<div class="panel panel-default">
											<div class="panel-heading">
												<a data-toggle="collapse" href="#collapseOne"
													aria-expanded="true" aria-controls="collapseOne">Year 1</a>
											</div>
											<div id="collapseOne" class="collapse">
												<div class="panel-body">
													<div class="container-fluid col-md-4">
														Term 1
														<ul class="sort_style" id="curriculum_container__y1t1">
														</ul>
													</div>
													<div class="container-fluid col-md-4">
														Term 2
														<ul class="sort_style" id="curriculum_container__y1t2">
														</ul>
													</div>
													<div class="container-fluid col-md-4">
														Term 3
														<ul class="sort_style" id="curriculum_container__y1t3">
														</ul>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="panel-group">
										<div class="panel panel-default">
											<div class="panel-heading">
												<a data-toggle="collapse" href="#collapseOne"
													aria-expanded="true" aria-controls="collapseOne">Year 1</a>
											</div>
											<div id="collapseOne" class="collapse">
												<div class="panel-body">
													<div class="container-fluid col-md-4">
														Term 1
														<ul class="sort_style" id="curriculum_container__y1t1">
														</ul>
													</div>
													<div class="container-fluid col-md-4">
														Term 2
														<ul class="sort_style" id="curriculum_container__y1t2">
														</ul>
													</div>
													<div class="container-fluid col-md-4">
														Term 3
														<ul class="sort_style" id="curriculum_container__y1t3">
														</ul>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="panel-group">
										<div class="panel panel-default">
											<div class="panel-heading">
												<a data-toggle="collapse" href="#collapseOne"
													aria-expanded="true" aria-controls="collapseOne">Year 1</a>
											</div>
											<div id="collapseOne" class="collapse">
												<div class="panel-body">
													<div class="container-fluid col-md-4">
														Term 1
														<ul class="sort_style" id="curriculum_container__y1t1">
														</ul>
													</div>
													<div class="container-fluid col-md-4">
														Term 2
														<ul class="sort_style" id="curriculum_container__y1t2">
														</ul>
													</div>
													<div class="container-fluid col-md-4">
														Term 3
														<ul class="sort_style" id="curriculum_container__y1t3">
														</ul>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="panel-group">
										<div class="panel panel-default">
											<div class="panel-heading">
												<a data-toggle="collapse" href="#collapseOne"
													aria-expanded="true" aria-controls="collapseOne">Year 1</a>
											</div>
											<div id="collapseOne" class="collapse">
												<div class="panel-body">
													<div class="container-fluid col-md-4">
														Term 1
														<ul class="sort_style" id="curriculum_container__y1t1">
														</ul>
													</div>
													<div class="container-fluid col-md-4">
														Term 2
														<ul class="sort_style" id="curriculum_container__y1t2">
														</ul>
													</div>
													<div class="container-fluid col-md-4">
														Term 3
														<ul class="sort_style" id="curriculum_container__y1t3">
														</ul>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="container-fluid">
								Subjects
								<ul class="sort_style" id="subjects_container">
								</ul>
							</div>
<!-- 							<button onClick="getInfo(1, 2)">Get Info!</button> -->
							<button class="btn btn-success" onClick="saveCurriculumEdit()">Save</button>
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
										<input id="add_curriculumcode" name="curriculumcode"
											type="text" class="form-control" placeholder="">
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
					<form id="editform" class="form form-horizontal" method="POST"
						action="curriculum_edit">
						<div class="section">
							<div class="section-body">
								<div class="form-group">
									<label class="col-md-3 control-label">Curriculum ID</label>
									<div class="col-md-9">
										<input id="edit_curriculumid" name="curriculumid"
											type="number" class="form-control" placeholder="" disabled>
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Curriculum Code</label>
									<div class="col-md-9">
										<input id="edit_curriculumcode" name="curriculumcode"
											type="text" class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Years</label>
									<div class="col-md-9">
										<input id="edit_years" name="years" type="number"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Terms per year</label>
									<div class="col-md-9">
										<input id="edit_termsperyear" name="termsperyear"
											type="number" class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Unit(s)</label>
									<div class="col-md-9">
										<input id="edit_units" name="units" type="number"
											class="form-control" placeholder="">
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
		function reloadTable() {
			closeFloatingButton();
			toggleTableLoad();
			$('table').DataTable().clear().draw();
			$.ajax({
				type : 'POST',
				url : 'curriculum-builder_reloadtable',
				success : function(data) {
					$('#ajax_result').html(data);
					toggleTableLoad();
					$.when($('table tr td:first-child').replaceTag("<th scope='row'>",
							false)).done(function() {
						$('table tbody tr').each(function () {
							$(this).find("td").eq(0).wrapInner("<b><a href='javascript:void(0)' onClick='curriculumEditMode(\"" + $(this).find("td").eq(0).text() + "\", " + $(this).find("th").eq(0).text() + ")'></a></b>");
						});		
					});
				},
				error : function(data) {
					//$('#result').html(data);
					alert("Error: " + data);
					$("#table_container").removeClass("__loading");
				}
			});
		}
		function addCurriculum() {
			if ($('#add_curriculumcode').val() != ''
					|| $('#add_years').val() != ''
					|| $('#add_termsperyear').val() != ''
					|| $('#add_units').val() != '') {
				var curriculumData = $('#addform').serialize();
				$.ajax({
					type : 'POST',
					url : 'curriculum_add',
					data : curriculumData,
					cache : false,
					success : function(data) {
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
							highlight_curriculumid[0] = $(this).children('th')
									.text();
							highlight_curriculumcode[0] = $(this).children(
									'td:eq(0)').text();
							highlight_years[0] = $(this).children('td:eq(1)')
									.text();
							highlight_termsperyear[0] = $(this).children(
									'td:eq(2)').text();
							highlight_units[0] = $(this).children('td:eq(3)')
									.text();
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
										for (var i = highlight_curriculumid.length - 1; i >= 0; i--) {
											if (highlight_curriculumid[i] == $(
													this).children('th').text()) {
												highlight_curriculumid.splice(
														i, 1);
												highlight_curriculumcode
														.splice(i, 1);
												highlight_years.splice(i, 1);
												highlight_termsperyear.splice(
														i, 1);
												highlight_units.splice(i, 1);

											}
										}
										$(this).removeClass('highlight')
									} else {
										highlight_curriculumid.push($(this)
												.children('th').text());
										highlight_curriculumcode.push($(this)
												.children('td:eq(0)').text());
										highlight_years.push($(this).children(
												'td:eq(1)').text());
										highlight_termsperyear.push($(this)
												.children('td:eq(2)').text());
										highlight_units.push($(this).children(
												'td:eq(3)').text());
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
			$("#edit_curriculumid").val(
					highlight_curriculumid[highlight_curriculum_count]);
			$("#edit_coursecode").val(
					highlight_curriculumcode[highlight_curriculum_count]);
			$("#edit_coursecode").val(
					highlight_years[highlight_curriculum_count]);
			$("#edit_coursecode").val(
					highlight_termsperyear[highlight_curriculum_count]);
			$("#edit_accttype")
					.val(highlight_units[highlight_curriculum_count]).change();
			$('#editModal').modal({
				backdrop : 'static',
				keyboard : false
			})
			$('#editModal')
					.on(
							'hidden.bs.modal',
							function() {
								if (highlight_curriculum_count < highlight_curriculum_count_total) {
									$("#edit_curriculumid")
											.val(
													highlight_id[highlight_curriculum_count]);
									$("#edit_curriculumcode")
											.val(
													highlight_curriculumcode[highlight_curriculum_count]);
									$("#edit_years")
											.val(
													highlight_years[highlight_curriculum_count]);
									$("#edit_termsperyear")
											.val(
													highlight_termsperyear[highlight_curriculum_count]);
									$("#edit_units")
											.val(
													highlight_units[highlight_curriculum_count]);
									$('#editModal').modal({
										backdrop : 'static',
										keyboard : false
									})
								}
							});
		}
		function cancelEdit() {
			$('#editModal').off('hidden.bs.modal');
			$('#editModal').modal('hide');
		}
		function cancelAnyMode() {
			$('#help-actions').show(500);
			$('#help-actions-cancel').hide();
			toggleTableHighlighter(0);
			$('#mode').hide();
			$('#mode').text("");
			$('#edit_container').hide(1000);
			$('#delete_container').hide(1000);
			$('#curriculum_editor').hide(500);
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
		
		function curriculumEditMode(curriculum, curriculum_id) {
			$('#curriculum_editor_loadingmsg').text("Loading");
			$('#table_container2').addClass("__loading");
			$.ajax({
				type : 'POST',
				url : 'curriculum-builder_curriculumeditor',
				data: { curriculumid: curriculum_id },
				success : function(data) {
					$('#curriculum_fullcontainer').empty();
					$('#subjects_container').empty();
					$('#ajax_result').html(data);
					preloadCurriculumStructure();
					$('#table_container2').removeClass("__loading");
					
					$('html, body').animate({
						scrollTop : $("#curriculum_editor").offset().top
					}, 500);
				},
				error : function(data) {
					//$('#result').html(data);
					alert(data);
				}
			});

			closeFloatingButton();
			$('#help-actions').hide();
			$('#help-actions-cancel').show(500);
			$('#curriculum_edit').show();
			$('#curriculum_edit').text(curriculum);
			$('#curriculum_editor').show(500);

			setTimeout(function() {
				$('html, body').animate({
					scrollTop : $("#curriculum_editor").offset().top
				}, 500);
			}, 500);
		}

		//Drag and Drop

// 		//Subjects Container
// 		var subjects_container = document.getElementById('subjects_container');
// 		var subjects_sortable = Sortable.create(subjects_container, {
// 			group : {
// 				name : 'subjects_container',
// 				put : [ 'subjects_container', 'curriculum_container__y1t1',
// 						'curriculum_container__y1t2',
// 						'curriculum_container__y1t3' ]
// 			},
// 			animation : 100
// 		});

// 		//Curriculum Container

// 		//Year 1 Term 1
// 		var curriculum_container__y1t1 = document
// 				.getElementById('curriculum_container__y1t1');
// 		var curriculum_sortable__y1t1 = Sortable.create(
// 				curriculum_container__y1t1, {
// 					group : {
// 						name : 'curriculum_container__y1t1',
// 						put : [ 'subjects_container',
// 								'curriculum_container__y1t1',
// 								'curriculum_container__y1t2',
// 								'curriculum_container__y1t3' ]
// 					},
// 					animation : 100
// 				});
// 		//Year 1 Term 2
// 		var curriculum_container__y1t2 = document
// 				.getElementById('curriculum_container__y1t2');
// 		var curriculum_sortable__y1t2 = Sortable.create(
// 				curriculum_container__y1t2, {
// 					group : {
// 						name : 'curriculum_container__y1t2',
// 						put : [ 'subjects_container',
// 								'curriculum_container__y1t1',
// 								'curriculum_container__y1t2',
// 								'curriculum_container__y1t3' ]
// 					},
// 					animation : 100
// 				});
// 		//Year 1 Term 3
// 		var curriculum_container__y1t3 = document
// 				.getElementById('curriculum_container__y1t3');
// 		var curriculum_sortable__y1t3 = Sortable.create(
// 				curriculum_container__y1t3, {
// 					group : {
// 						name : 'curriculum_container__y1t3',
// 						put : [ 'subjects_container',
// 								'curriculum_container__y1t1',
// 								'curriculum_container__y1t2',
// 								'curriculum_container__y1t3' ]
// 					},
// 					animation : 100
// 				});

		//Drag And Drop Functions
		function preloadCurriculumStructure(){
			//var curriculum_structure = "y1t1|1|y1t2|3|y1t3|2|y2t1||y2t2||y2t3||y3t1||y3t2||y3t3||y4t1||y4t2||y4t3|";
			curriculum_structure_split = curriculum_structure.split("|");
			for(var i=0; i<curriculum_structure_split.length; i++){
				if(i%2 == 0){
					currstruc_year = curriculum_structure_split[i].substring(1,2);
					currstruc_term = curriculum_structure_split[i].substring(3,4);
				}
				else{
					var currstruc_subjects = curriculum_structure_split[i].split(",");
					for(var j=0; j<currstruc_subjects.length; j++){
						temp_element = $("#subj_" + currstruc_subjects[j]).wrap('<div>').parent().html();
						$("#subj_" + currstruc_subjects[j]).remove();
						$("#curriculum_container__y" + currstruc_year + "t" + currstruc_term).append(temp_element);
					}
// 					temp_element = $("#subj_" + curriculum_structure_split[i]).wrap('<div>').parent().html();
// 					$("#subj_" + curriculum_structure_split[i]).remove();
// 					$("#curriculum_container__y" + currstruc_year + "t" + currstruc_term).append(temp_element);
				}
			}
			/*alert(curriculum_structure_split[9]);*/
		}
		function toggleYearPanels(state){
			if(state == 0){
				$('#curriculum_fullcontainer .collapse').collapse('hide');
			}
			else if(state == 1){
				$('#curriculum_fullcontainer .collapse').collapse('show');
			}
			
		}
		function getInfo(year, term) {
			var list = [];
			$('#curriculum_container__y' + year + 't' + term + ' li').each(
					function(i) {
						list.push($(this).attr('id')); // This is your rel value
					});
			alert(list);
		}
		var curriculum_full = "";
		function generateCurriculumStructure(){
			curriculum_full = "";
			for(var i=0; i<curriculum_years; i++){
				for(var j=0; j<curriculum_terms; j++){
					var list = [];
					$('#curriculum_container__y' + (i+1) + 't' + (j+1) + ' li').each(
						function(i) {
							list.push($(this).attr('id').replace("subj_", "")); // This is your rel value
						});
					curriculum_full = curriculum_full.concat("y" + (i+1) + "t" + (j+1) + "|" + list);
					if(j<curriculum_terms-1){
						curriculum_full = curriculum_full.concat("|");
					}
				}
				if(i<curriculum_years-1){
					curriculum_full = curriculum_full.concat("|");
				}
			}
		}
		function saveCurriculumEdit() {
			$('#curriculum_editor_loadingmsg').text("Saving");
			$('#table_container2').addClass("__loading");
			$.notify('Saving...', {
				className:'info',
				clickToHide: false,
				autoHide: false
			});
			generateCurriculumStructure();
// 			alert(curriculum_full);
// 			alert(curriculum_id_currentedit);
			$.ajax({
				type : 'POST',
				url : 'curriculum-builder_curriculumeditor_save',
				data: {curriculumid: curriculum_id_currentedit, curriculumstructure: curriculum_full},
				success : function(data) {
					$('.notifyjs-wrapper').trigger('notify-hide');
					$('#ajax_result').html(data);
					cancelAnyMode();
				},
				error : function(data) {
					//$('#result').html(data);
					alert("Error: " + data);
				}
			});
		}
	</script>
</body>

</html>