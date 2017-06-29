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


			<div class="row">
				<div class="col-xs-12">
					<div class="card">
						<div class="card-header">
							Student Info&nbsp;
							<kbd style="display: none;" id="mode"></kbd>
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
							<c:forEach var="studentinfo"
								items='${requestScope["student_student-info"]}' varStatus="loop">
								<c:choose>
									<c:when test="${loop.index=='0'}">
										<div id="con1" class="container-fluid">
											<div class="alert alert-info">
												Name:
												<c:out value="${studentinfo}" />
											</div>
										</div>
									</c:when>
									<c:when test="${loop.index=='1'}">
										<div id="con2" class="container-fluid">
											<div class="alert alert-info">
												School:
												<c:out value="${studentinfo}" />
											</div>
										</div>
									</c:when>
									<c:when test="${loop.index=='2'}">
										<div id="con3" class="container-fluid">
											<div class="alert alert-info">
												Degree:
												<c:out value="${studentinfo}" />
											</div>
										</div>
									</c:when>
									<c:when test="${loop.index=='3'}">
										<div id="con4" class="container-fluid">
											<div class="alert alert-info">
												Tuition:
												<c:out value="${studentinfo}" />
											</div>
										</div>
									</c:when>
								</c:choose>
							</c:forEach>
						</div>
					</div>
				</div>
			</div>

			<%@ include file="include/footer.jsp"%>
		</div>

	</div>

	<!-- AJAX RESULT CONTAINER -->
	<div id="ajax_result"></div>

	<!-- INITIALIZE BELOW -->
	<%@ include file="include/below_ini.jsp"%>

	<!-- Setup Active Menu in Sidebar -->
	<script>
		$("ul.sidebar-nav > li:eq(${requestScope.menuactivenum})").addClass(
				"active");
	</script>

	<!-- Script execution when page is done -->
	<script>
		$("#con1").hide();
		$("#con2").hide();
		$("#con3").hide();
		$("#con4").hide();
		$(document).ready(function() {
			toggleTableLoad();
			$("#con1").show(1000);
			setTimeout(function(){ $("#con2").show(1000); }, 500);
			setTimeout(function(){ $("#con3").show(1000); }, 1000);
			setTimeout(function(){ $("#con4").show(1000); }, 1500);
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
				url : 'subjects_reloadtable',
				success : function(data) {
					$('#ajax_result').html(data);
					toggleTableLoad();
					if ($('table tr td:nth-child(5)').html() == "null") {
						$('table tr td:nth-child(5)').html("");
					}
					$('table tr td:first-child').replaceTag("<th scope='row'>",
							false);
				},
				error : function(data) {
					//$('#result').html(data);
					alert(data);
				}
			});
		}
		function addSubject() {
			if ($('#add_coursecode').val() != ''
					&& $('#add_coursename').val() != ''
					&& $('#add_courseunits').val() != '') {
				/*var subjectData = $('#addform').serialize(); 
				$.ajax({
					type: 'POST',
					url: 'subjects_add',
					data: subjectData,
					cache: false,
					success: function(data){
						alert(data);
					},
					error : function(data) {
						alert("Error: " + data);
					}
				});*/
				$("#addform").submit();
			}
		}
		var highlight_id = [];
		var highlight_coursecode = [];
		var highlight_coursename = [];
		var highlight_courseunits = [];
		var highlight_prerequisites = [];
		var highlight_price = [];
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
							highlight_coursecode[0] = $(this).children(
									'td:eq(0)').text();
							highlight_coursename[0] = $(this).children(
									'td:eq(1)').text();
							highlight_courseunits[0] = $(this).children(
									'td:eq(2)').text();
							highlight_prerequisites[0] = $(this).children(
									'td:eq(3)').text();
							highlight_price[0] = $(this).children('td:eq(4)')
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
										for (var i = highlight_id.length - 1; i >= 0; i--) {
											if (highlight_id[i] == $(this)
													.children('th').text()) {
												highlight_id.splice(i, 1);
												highlight_coursecode.splice(i,
														1);
												highlight_coursename.splice(i,
														1);
												highlight_courseunits.splice(i,
														1);
												highlight_prerequisites.splice(
														i, 1);
												highlight_price.splice(i, 1);

											}
										}
										$(this).removeClass('highlight')
									} else {
										highlight_id.push($(this)
												.children('th').text());
										highlight_coursecode.push($(this)
												.children('td:eq(0)').text());
										highlight_coursename.push($(this)
												.children('td:eq(1)').text());
										highlight_courseunits.push($(this)
												.children('td:eq(2)').text());
										highlight_prerequisites.push($(this)
												.children('td:eq(3)').text());
										highlight_price.push($(this).children(
												'td:eq(4)').text());
										$(this).addClass('highlight');
									}
								});
			}
		}

		function removeTableHighlights() {
			highlight_id = [];
			$('table tbody tr').removeClass('highlight');
		}

		function resetVariables() {
			highlight_id = [];
			highlight_coursecode = [];
			highlight_coursename = [];
			highlight_courseunits = [];
			highlight_prerequisites = [];
			highlight_price = [];
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
			$("#edit_coursecode").val(
					highlight_coursecode[highlight_subjects_count]);
			$("#edit_coursename").val(
					highlight_coursename[highlight_subjects_count]);
			$("#edit_courseunits").val(
					highlight_courseunits[highlight_subjects_count]);
			$("#edit_prerequisites").val(
					highlight_prerequisites[highlight_subjects_count]).change();
			$("#edit_price").val(highlight_price[highlight_subjects_count]);
			$('#editModal').modal({
				backdrop : 'static',
				keyboard : false
			})
			$('#editModal')
					.on(
							'hidden.bs.modal',
							function() {
								if (highlight_subjects_count < highlight_subjects_count_total) {
									$("#edit_id")
											.val(
													highlight_id[highlight_subjects_count]);
									$("#edit_coursecode")
											.val(
													highlight_coursecode[highlight_subjects_count]);
									$("#edit_coursename")
											.val(
													highlight_coursename[highlight_subjects_count]);
									$("#edit_courseunits")
											.val(
													highlight_courseunits[highlight_subjects_count]);
									$("#edit_prerequisites")
											.val(
													highlight_prerequisites[highlight_subjects_count])
											.change();
									$("#edit_price")
											.val(
													highlight_price[highlight_subjects_count]);
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
			$("#edit_id").prop("disabled", false);
			var editform_values = $("#editform").serialize();
			$("#edit_id").prop("disabled", true);
			setTimeout(function() {
				$.ajax({
					type : 'POST',
					data : editform_values,
					url : 'subjects_edit',
					success : function(data) {
						highlight_subjects_count++;
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
			if (highlight_id.length > 0) {
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
					courseids : String(highlight_id)
				},
				url : 'subjects_delete',
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