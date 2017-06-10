<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="true"%>
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

			<%@ include file="include/nav.jsp" %>

			<div class="btn-floating" id="help-actions">
				<div class="btn-bg"></div>
				<button type="button" class="btn btn-default btn-toggle"
					data-toggle="toggle" data-target="#help-actions">
					<i class="icon fa fa-navicon (alias)"></i> <span class="help-text">Shortcut</span>
				</button>
				<div class="toggle-content">
					<ul class="actions">
						<li><a href="#">Add new curriculum</a></li>
						<li><a href="curriculum-builder">Refresh</a></li>
					</ul>
				</div>
			</div>

			<div class="row">
				<div class="col-xs-12">
					<div class="card">
						<div class="card-header">List of current curriculums</div>
						<div class="card-body">
							<table class="datatable table table-striped table-bordered table-hover"
								cellspacing="0" width="100%">
								<thead>
									<tr>
										<th>Curriculum Code</th>
										<th>Years</th>
										<th>Terms per Year</th>
										<th>Units</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th scope="row">BSCSSE2012</th>
										<td>4</td>
										<td>3</td>
										<td>218.5</td>
									</tr>
									<tr>
										<th scope="row">BSITDA2012</th>
										<td>4</td>
										<td>3</td>
										<td>218.5</td>
									</tr>
									<tr>
										<th scope="row">BSITAGD2012</th>
										<td>4</td>
										<td>3</td>
										<td>218.5</td>
									</tr>
									<tr>
										<th scope="row">BSCE2012</th>
										<td>4</td>
										<td>3</td>
										<td>218.5</td>
									</tr>
								</tbody>
							</table>

							<!-- 
									<table class="table table-striped table-bordered table-hover">
										<thead>
											<tr>
												<th>Curriculum Code</th>
												<th>Years</th>
												<th>Terms per Year</th>
												<th>Units</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th scope="row">BSCSSE2012</th>
												<td>4</td>
												<td>3</td>
												<td>218.5</td>
											</tr>
											<tr>
												<th scope="row">BSITDA2012</th>
												<td>4</td>
												<td>3</td>
												<td>218.5</td>
											</tr>
											<tr>
												<th scope="row">BSITAGD2012</th>
												<td>4</td>
												<td>3</td>
												<td>218.5</td>
											</tr>
											<tr>
												<th scope="row">BSCE2012</th>
												<td>4</td>
												<td>3</td>
												<td>218.5</td>
											</tr>
										</tbody>
									</table> -->

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
		$("ul.sidebar-nav > li:eq(4)").addClass("active");
	</script>
</body>

</html>