<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="true"%>
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

			<%@ include file="include/nav.jsp" %>

			<div class="btn-floating" id="help-actions">
				<div class="btn-bg"></div>
				<button type="button" class="btn btn-default btn-toggle"
					data-toggle="toggle" data-target="#help-actions">
					<i class="icon fa fa-plus"></i> <span class="help-text">Shortcut</span>
				</button>
				<div class="toggle-content">
					<ul class="actions">
						<li><a href="#">New Task</a></li>
						<li><a href="#">New School</a></li>
						<li><a href="#">New Student</a></li>
						<li><a href="#">New Room</a></li>
					</ul>
				</div>
			</div>

			<div class="row">
				<div class="col-xs-12">
					<div class="card card-banner card-chart card-green no-br">
						<div class="card-header">
							<div class="card-title">
								<div class="title">Income Chart</div>
							</div>
							<ul class="card-action">
								<li><a href="/educationtest"> <i class="fa fa-refresh"></i>
								</a></li>
							</ul>
						</div>
						<div class="card-body">
							<div class="ct-chart-sale"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-lg-4 col-md-6 col-sm-6 col-xs-12">
					<a class="card card-banner card-green-light">
						<div class="card-body">
							<i class="icon fa fa-money fa-4x"></i>
							<div class="content">
								<div class="title">Income Today</div>
								<div class="value">
									<span class="sign">$</span>420
								</div>
							</div>
						</div>
					</a>

				</div>
				<div class="col-lg-4 col-md-6 col-sm-6 col-xs-12">
					<a class="card card-banner card-blue-light">
						<div class="card-body">
							<i class="icon fa fa-user fa-4x"></i>
							<div class="content">
								<div class="title">Number of Employees</div>
								<div class="value">
									<span class="sign"></span>2453
								</div>
							</div>
						</div>
					</a>

				</div>
				<div class="col-lg-4 col-md-6 col-sm-6 col-xs-12">
					<a class="card card-banner card-yellow-light">
						<div class="card-body">
							<i class="icon fa fa-institution (alias) fa-4x"></i>
							<div class="content">
								<div class="title">Schools Owned</div>
								<div class="value">
									<span class="sign"></span>10
								</div>
							</div>
						</div>
					</a>

				</div>
			</div>

			<div class="row">
				<div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
					<div class="card card-mini">
						<div class="card-header">
							<div class="card-title">School Statuses</div>
							<ul class="card-action">
								<li><a href="#"> <i class="fa fa-refresh"></i>
								</a></li>
							</ul>
						</div>
						<div class="card-body no-padding table-responsive">
							<table class="table card-table">
								<thead>
									<tr>
										<th>Schools</th>
										<th class="right">Number of Students</th>
										<th>Status</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>FEU-Institute of Technology</td>
										<td class="right">509689</td>
										<td><span class="badge badge-success badge-icon"><i
												class="fa fa-check" aria-hidden="true"></i><span>Active</span></span></td>
									</tr>
									<tr>
										<td>STI</td>
										<td class="right">190765</td>
										<td><span class="badge badge-warning badge-icon"><i
												class="fa fa-clock-o" aria-hidden="true"></i><span>Inactive</span></span></td>
									</tr>
									<tr>
										<td>AMA</td>
										<td class="right">167543</td>
										<td><span class="badge badge-info badge-icon"><i
												class="fa fa-credit-card" aria-hidden="true"></i><span>Finance
													Issue</span></span></td>
									</tr>
									<tr>
										<td>University of Santo Thomas</td>
										<td class="right">736585</td>
										<td><span class="badge badge-danger badge-icon"><i
												class="fa fa-times" aria-hidden="true"></i><span>Problem
													Detected</span></span></td>
									</tr>
									<tr>
										<td>De La Salle University</td>
										<td class="right">686486</td>
										<td><span class="badge badge-danger badge-icon"><i
												class="fa fa-times" aria-hidden="true"></i><span>Problem
													Detected</span></span></td>
									</tr>
									<tr>
										<td>University of the Philippines</td>
										<td class="right">264685</td>
										<td><span class="badge badge-info badge-icon"><i
												class="fa fa-credit-card" aria-hidden="true"></i><span>Finance
													Issue</span></span></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
					<div class="card card-tab card-mini">
						<div class="card-header">
							<ul class="nav nav-tabs tab-stats">
								<li role="tab1" class="active"><a href="#tab1"
									aria-controls="tab1" role="tab" data-toggle="tab">Income</a></li>
								<li role="tab2"><a href="#tab2" aria-controls="tab2"
									role="tab" data-toggle="tab">Students</a></li>
								<li role="tab2"><a href="#tab3" aria-controls="tab3"
									role="tab" data-toggle="tab">ETC</a></li>
							</ul>
						</div>
						<div class="card-body tab-content">
							<div role="tabpanel" class="tab-pane active" id="tab1">
								<div class="row">
									<div class="col-sm-8">
										<div class="chart ct-chart-browser ct-perfect-fourth"></div>
									</div>
									<div class="col-sm-4">
										<ul class="chart-label">
											<li class="ct-label ct-series-a">FEU-Institute of
												Technology</li>
											<li class="ct-label ct-series-b">STI</li>
											<li class="ct-label ct-series-c">AMA</li>
											<li class="ct-label ct-series-d">University of Santo
												Thomas</li>
											<li class="ct-label ct-series-e">De La Salle University</li>
										</ul>
									</div>
								</div>
							</div>
							<div role="tabpanel" class="tab-pane" id="tab2">
								<div class="row">
									<div class="col-sm-8">
										<div class="chart ct-chart-os ct-perfect-fourth"></div>
									</div>
									<div class="col-sm-4">
										<ul class="chart-label">
											<li class="ct-label ct-series-a">FEU-Institute of
												Technology</li>
											<li class="ct-label ct-series-b">STI</li>
											<li class="ct-label ct-series-c">AMA</li>
											<li class="ct-label ct-series-d">University of Santo
												Thomas</li>
											<li class="ct-label ct-series-e">De La Salle University</li>
										</ul>
									</div>
								</div>
							</div>
							<div role="tabpanel" class="tab-pane" id="tab3"></div>
						</div>
					</div>
				</div>
			</div>
			<%@ include file="include/footer.jsp"%>
		</div>

	</div>

	<!-- INITIALIZE BELOW -->
	<%@ include file="include/below_ini.jsp"%>

	<!-- Setup Active Menu in Sidebar -->
	<script>
		$("ul.sidebar-nav > li:eq(${requestScope.menuactivenum})").addClass("active");
	</script>

</body>

<!-- Temp -->
<script>
	//alert("Hello! What you're seeing here is just a temporary placeholder of our project's early UI concept.\n\nTo access current development pages, head over to DEVELOPER PAGES navigation.\n\n\nThank you!");
</script>
</html>