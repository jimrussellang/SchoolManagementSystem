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
							data-toggle="modal" data-target="#addModal">Add new account</a></li>
						<li><a onClick="editMode()">Edit existing accounts</a></li>
						<li><a onClick="deleteMode()">Delete
								existing accounts</a></li>
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
						<div class="card-header">
							Accounts List&nbsp;
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
										<th>User ID</th>
										<th>User Name</th>
										<th>Account Type</th>
										<th>Date Registered</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="accounts"
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
					<h4 class="modal-title">Add New Account</h4>
				</div>
				<div class="modal-body">
					<form id="addform" class="form form-horizontal" method="POST"
						action="accounts_add">
						<div class="section">
							<div class="section-body">
								<div class="form-group">
									<label class="col-md-3 control-label">User ID</label>
									<div class="col-md-9">
										<input id="add_userid" name="userid" type="text"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">User Name</label>
									<div class="col-md-9">
										<input id="add_username" name="username" type="text"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Password</label>
									<div class="col-md-9">
										<input id="add_password" name="password" type="password"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Re-enter Password</label>
									<div class="col-md-9">
										<input id="add_repassword" name="repassword" type="password"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Account Type</label>
									<div class="col-md-4">
										<div class="input-group">
											<select id="accttype" name="accttype" class="select2">
												<option value="BM">Businessman</option>
												<option value="SCH">School Admin</option>
												<option value="ST">Student</option>
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
					<button onClick="addAccount()" type="button"
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
						action="accounts_edit">
						<div class="section">
							<div class="section-body">
								<div class="form-group">
									<label class="col-md-3 control-label">User ID</label>
									<div class="col-md-9">
										<input id="edit_userid" name="userid" type="text"
											class="form-control" placeholder="" disabled>
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">User Name</label>
									<div class="col-md-9">
										<input id="edit_username" name="username" type="text"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Password</label>
									<div class="col-md-9">
										<input id="edit_password" name="password" type="password"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Re-enter Password</label>
									<div class="col-md-9">
										<input id="edit_repassword" name="repassword" type="password"
											class="form-control" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-3 control-label">Account Type</label>
									<div class="col-md-4">
										<div class="input-group">
											<select id="edit_accttype" name="accttype" class="select2">
												<option value="BM">Businessman</option>
												<option value="SCH">School Admin</option>
												<option value="ST">Student</option>
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
					<button onClick="highlight_users_count++;" type="button"
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
		function addAccount() {
			if ($("#add_password").val() == $("#add_repassword").val()) {
				$("#addform").submit();
			}
		}
		var highlight_userids = [];
		var highlight_usernames = [];
		var highlight_accttypes = [];
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
							highlight_userids[0] = $(this).children('th')
									.text();
							highlight_usernames[0] = $(this).children('td:eq(0)')
							.text();
							highlight_accttypes[0] = $(this).children('td:eq(1)')
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
										for (var i = highlight_userids.length - 1; i >= 0; i--) {
											if (highlight_userids[i] == $(this)
													.children('th').text()) {
												highlight_userids.splice(i, 1);
												highlight_usernames.splice(i, 1);
												highlight_accttypes.splice(i, 1);
												
											}
										}
										$(this).removeClass('highlight')
									} else {
										highlight_userids.push($(this)
												.children('th').text());
										highlight_usernames.push($(this).children('td:eq(0)')
										.text());
										highlight_accttypes.push($(this).children('td:eq(1)')
										.text());
										$(this).addClass('highlight');
									}
								});
			}
		}

		function removeTableHighlights() {
			highlight_userids = [];
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
		var highlight_users_count = 0;
		var highlight_users_count_total = 0;
		function startEdit() {
			highlight_users_count = 0;
			highlight_users_count_total = highlight_userids.length;
			$("#edit_userid").val(highlight_userids[highlight_users_count]);
			$("#edit_username").val(highlight_usernames[highlight_users_count]);
			$("#edit_accttype").val(highlight_accttypes[highlight_users_count]).change();
			$('#editModal').modal({
			    backdrop: 'static',
			    keyboard: false
			})
			$('#editModal').on('hidden.bs.modal', function(){
				if(highlight_users_count < highlight_users_count_total){
					$("#edit_userid").val(highlight_userids[highlight_users_count]);
					$("#edit_username").val(highlight_usernames[highlight_users_count]);
					$("#edit_accttype").val(highlight_accttypes[highlight_users_count]).change();
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