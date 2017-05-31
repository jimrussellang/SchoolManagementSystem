<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
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

			<nav class="navbar navbar-default back-position" id="navbar">
				<div class="container-fluid">
					<div class="navbar-collapse collapse in">
						<ul class="nav navbar-nav navbar-mobile">
							<li>
								<button type="button" class="sidebar-toggle">
									<i class="fa fa-bars"></i>
								</button>
							</li>
							<li class="logo"><a class="navbar-brand" href="#"><span
									class="highlight">PROJECT</span> Education</a></li>
							<li>
								<button type="button" class="navbar-toggle">
									<img class="profile-img"
										src="<c:url value="/resources/assets/images/profile.png" />">
								</button>
							</li>
						</ul>
						<ul class="nav navbar-nav navbar-left">
							<li class="navbar-title">Curriculum Builder</li>
							<li class="navbar-search hidden-sm"><input id="search"
								type="text" placeholder="Search..">
								<button class="btn-search">
									<i class="fa fa-search"></i>
								</button></li>
						</ul>
						<ul class="nav navbar-nav navbar-right">
							<li class="dropdown notification"><a href="#"
								class="dropdown-toggle" data-toggle="dropdown">
									<div class="icon">
										<i class="fa fa-tasks" aria-hidden="true"></i>
									</div>
									<div class="title">Tasks</div>
									<div class="count">0</div>
							</a>
								<div class="dropdown-menu">
									<ul>
										<li class="dropdown-header">Tasks</li>
										<li class="dropdown-empty">No Active Tasks</li>
										<li class="dropdown-footer"><a href="#">View All <i
												class="fa fa-angle-right" aria-hidden="true"></i></a></li>
									</ul>
								</div></li>
							<li class="dropdown notification warning"><a href="#"
								class="dropdown-toggle" data-toggle="dropdown">
									<div class="icon">
										<i class="fa fa-comments" aria-hidden="true"></i>
									</div>
									<div class="title">Unread Messages</div>
									<div class="count">99</div>
							</a>
								<div class="dropdown-menu">
									<ul>
										<li class="dropdown-header">Message</li>
										<li><a href="#"> <span
												class="badge badge-warning pull-right">10</span>
												<div class="message">
													<img class="profile" src="https://placehold.it/100x100">
													<div class="content">
														<div class="title">"We will pass this subject"</div>
														<div class="description">Jim Russell Ang</div>
													</div>
												</div>
										</a></li>
										<li><a href="#"> <span
												class="badge badge-warning pull-right">5</span>
												<div class="message">
													<img class="profile" src="https://placehold.it/100x100">
													<div class="content">
														<div class="title">"Shit Happens"</div>
														<div class="description">Hadji Tejuco</div>
													</div>
												</div>
										</a></li>
										<li><a href="#"> <span
												class="badge badge-warning pull-right">2</span>
												<div class="message">
													<img class="profile" src="https://placehold.it/100x100">
													<div class="content">
														<div class="title">"Hello iTams!"</div>
														<div class="description">FEU-Insitute of Technology
															Admin</div>
													</div>
												</div>
										</a></li>
										<li class="dropdown-footer"><a href="#">View All <i
												class="fa fa-angle-right" aria-hidden="true"></i></a></li>
									</ul>
								</div></li>
							<li class="dropdown notification danger"><a href="#"
								class="dropdown-toggle" data-toggle="dropdown">
									<div class="icon">
										<i class="fa fa-bell" aria-hidden="true"></i>
									</div>
									<div class="title">System Notifications</div>
									<div class="count">10</div>
							</a>
								<div class="dropdown-menu">
									<ul>
										<li class="dropdown-header">Notification</li>
										<li><a href="#"> <span
												class="badge badge-danger pull-right">8</span>
												<div class="message">
													<div class="content">
														<div class="title">Financial issues detected</div>
														<div class="description">A total of 2 schools are
															having financi...</div>
													</div>
												</div>
										</a></li>
										<li><a href="#"> <span
												class="badge badge-danger pull-right">14</span> Your inbox
												has 14 unread messages
										</a></li>
										<li><a href="#"> <span
												class="badge badge-danger pull-right">5</span> Problems
												Report
										</a></li>
										<li class="dropdown-footer"><a href="#">View All <i
												class="fa fa-angle-right" aria-hidden="true"></i></a></li>
									</ul>
								</div></li>
							<li class="dropdown profile"><a href="#"
								class="dropdown-toggle" data-toggle="dropdown"> <img
									class="profile-img"
									src="<c:url value="/resources/assets/images/profile.png" />">
									<div class="title">Profile</div>
							</a>
								<div class="dropdown-menu">
									<div class="profile-info">
										<h4 class="username">Hadji Tejuco</h4>
									</div>
									<ul class="action">
										<li><a href="#"> Profile </a></li>
										<li><a href="#"> <span
												class="badge badge-danger pull-right">5</span> My Inbox
										</a></li>
										<li><a href="#"> Setting </a></li>
										<li><a onClick="loadPage();" href="logout"> Logout </a></li>
									</ul>
								</div></li>
						</ul>
					</div>
				</div>
			</nav>

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