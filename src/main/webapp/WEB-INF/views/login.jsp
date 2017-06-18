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

		<div id="login_container" class="app-container app-login">
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
						<div class="title">Logging in...</div>
					</div>
					<div class="app-block">
						<div class="app-form">
							<div class="form-header">
								<div class="app-brand">
									<span class="highlight">School Management System</span> Login
								</div>
							</div>

							<!-- AJAX RESULT CONTAINER -->
							<div id="ajax_result"></div>

							<form action="login_verify" method="POST">
								${login_message}
								<div class="input-group">
									<span class="input-group-addon" id="basic-addon1"> <i
										class="fa fa-user" aria-hidden="true"></i></span> <input
										id="username" name="username" type="text" class="form-control"
										placeholder="Username"
										onKeyDown="if(event.keyCode==13) loginRequest();">
								</div>
								<div class="input-group">
									<span class="input-group-addon" id="basic-addon2"> <i
										class="fa fa-key" aria-hidden="true"></i></span> <input id="password"
										name="password" type="password" class="form-control"
										placeholder="Password"
										onKeyDown="if(event.keyCode==13) loginRequest();">
								</div>
								<div class="text-center">
									<button type="button" onClick="loginRequest();"
										class="btn btn-success btn-submit">Login</button>
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
	function loginRequest() {
		if ($("#username").val() != "" && $("#password").val() != "") {
			$("#login_container").addClass("__loading");
			setTimeout(function() {
				//$("form").submit(); 
				$.ajax({
					type : 'POST',
					data : $("form").serialize(),
					url : 'login_verify',
					success : function(data) {
						$('#ajax_result').html(data);
					},
					error : function(data) {
						//$('#result').html(data);
						alert(data);
					}
				});
			}, 1500);
		} else {
			//Temporary
			alert("Please fill up the required fields!");
		}
	}

	$.notify("${access_denied_msg}", 'error');
	if ("${param.logout}" == "true") {
		$.notify("Successfully logged out!", 'success');
	}
</script>
</html>