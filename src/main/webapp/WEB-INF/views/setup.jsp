<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<!DOCTYPE html>
<html>
<head>
<title>School Management System - ${page_title}</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Head Initialization -->
<%@ include file="include/head_ini.jsp"%>

</head>
<body>
	<div class="app app-default">

		<div id="setup_container" class="app-container app-login">
			<div class="flex-center">
				<div class="app-header"></div>
				<div class="app-body">
					<div class="loader-container text-center">
						<div class="icon">
							<div class="sk-folding-cube">
								<div class="sk-cube1 sk-cube"></div>
								<div class="sk-cube2 sk-cube"></div>
								<div class="sk-cube4 sk-cube"></div>
								<div class="sk-cube3 sk-cube"></div>
							</div>
						</div>
						<div class="title">Configuring School Management System...</div>
					</div>
					<div class="app-block">
						<div class="app-form">
							<div class="form-header">
								<div class="app-brand">
									<span class="highlight">School Management System</span> Setup
								</div>
							</div>

							<!-- AJAX RESULT CONTAINER -->
							<div id="ajax_result"></div>

							<form action="setup_ini" method="POST">
								<div class="text-center">
									<button type="button" onClick="setupRequest();"
										class="btn btn-success btn-submit">Start Setup</button>
								</div>
							</form>

						</div>
					</div>
				</div>
				<div class="app-footer"></div>
			</div>
		</div>

	</div>

	<!-- INITIALIZE BELOW -->
	<%@ include file="include/below_ini.jsp"%>


</body>

<script>
	function setupRequest() {
			$("#setup_container").addClass("__loading");
			setTimeout(function() {
				//$("form").submit(); 
				$.ajax({
					type : 'POST',
					data : $("form").serialize(),
					url : 'setup_ini',
					success : function(data) {
						$('#ajax_result').html(data);
					},
					error : function(data) {
						//$('#result').html(data);
						alert("An error has occurred! Please reload the page and try again.\nError: " + data);
					}
				});
			}, 1500);
	}

	$.notify("${access_denied_msg}", 'error');
	if ("${param.logout}" == "true") {
		$.notify("Successfully logged out!", 'success');
	}
</script>
</html>