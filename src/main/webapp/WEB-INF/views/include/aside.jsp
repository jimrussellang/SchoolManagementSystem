<aside class="app-sidebar back-position" id="sidebar">
	<div class="sidebar-header">
		<a class="sidebar-brand" href="#"><span class="highlight">School</span>Management
			System</a>
		<button type="button" class="sidebar-toggle">
			<i class="fa fa-times"></i>
		</button>
	</div>
	<div class="sidebar-menu">
		<ul class="sidebar-nav">
			<li class=""><a href="home">
					<div class="icon">
						<i class="fa fa-tasks" aria-hidden="true"></i>
					</div>
					<div class="title">Dashboard</div>
			</a></li>
			<c:if test = "${sessionScope.login_accounttype != 'ST'}">
				<li class=""><a href="accounts">
					<div class="icon">
						<i class="fa fa-users" aria-hidden="true"></i>
					</div>
					<div class="title">Accounts</div>
				</a></li>
			</c:if>
			<c:if test = "${sessionScope.login_accounttype == 'BM' || sessionScope.login_accounttype == 'admin'}">
			<li class=""><a href="schools">
					<div class="icon">
						<i class="fa fa-institution (alias)" aria-hidden="true"></i>
					</div>
					<div class="title">Schools</div>
			</a></li>
			</c:if>
			<c:if test = "${sessionScope.login_accounttype == 'SCH' || sessionScope.login_accounttype == 'admin'}">
			<li class="dropdown"><a href="#"class="dropdown-toggle"
				data-toggle="dropdown">
					<div class="icon">
						<i class="fa fa-wrench" aria-hidden="true"></i>
					</div>
					<div class="title">Tools</div>
			</a>
			<div class="dropdown-menu">
					<ul>
						<li class="section"><i class="fa fa-wrench"
							aria-hidden="true"></i> Tools</li>
						<li><a href="curriculum-builder">Curriculum Builder</a></li>
						<li><a href="subjects">Subjects</a></li>
						<li><a href="degrees">Degrees</a></li>
						<li><a href="admission">Admission</a></li>
					</ul>
				</div></li>
			</c:if>
			<c:if test = "${sessionScope.login_accounttype == 'ST'}">
			<li class=""><a href="enrollment">
					<div class="icon">
						<i class="fa fa-plus-square" aria-hidden="true"></i>
					</div>
					<div class="title">Enrollment</div>
			</a></li>
			<li class=""><a href="student">
					<div class="icon">
						<i class="fa fa-graduation-cap" aria-hidden="true"></i>
					</div>
					<div class="title">Student Status</div>
			</a></li>
			</c:if>
			<!--  
			<li class=""><a href="#">
					<div class="icon">
						<i class="fa fa-comments" aria-hidden="true"></i>
					</div>
					<div class="title">Messaging</div>
			</a></li>
			<li class="dropdown "><a href="#" class="dropdown-toggle"
				data-toggle="dropdown">
					<div class="icon">
						<i class="fa fa-cube" aria-hidden="true"></i>
					</div>
					<div class="title">Tools</div>
			</a>
				<div class="dropdown-menu">
					<ul>
						<li class="section"><i class="fa fa-file-o"
							aria-hidden="true"></i> Tools 1</li>
						<li><a href="#">TOOLS!</a></li>
						<li><a href="#">TOOLS!</a></li>
						<li><a href="#">TOOLS!</a></li>
						<li><a href="#">TOOLS!</a></li>
						<li class="line"></li>
						<li class="section"><i class="fa fa-file-o"
							aria-hidden="true"></i> Tools 2</li>
						<li><a href="#">TOOLS!</a></li>
						<li><a href="#">TOOLS!</a></li>
						<li><a href="#">TOOLS!</a></li>
					</ul>
				</div></li>
			<li class="dropdown"><a href="#" class="dropdown-toggle"
				data-toggle="dropdown">
					<div class="icon">
						<i class="fa fa-file-o" aria-hidden="true"></i>
					</div>
					<div class="title">Other Pages</div>
			</a>
				<div class="dropdown-menu">
					<ul>
						<li class="section"><i class="fa fa-file-o"
							aria-hidden="true"></i> Page 1</li>
						<li><a href="#">PAGES!</a></li>
						<li><a href="#">PAGES!</a></li>
						<li><a href="#">PAGES!</a></li>
						<li><a href="#">PAGES!</a></li>
						<li><a href="#">PAGES!</a></li>
						<li class="line"></li>
						<li class="section"><i class="fa fa-file-o"
							aria-hidden="true"></i> Page 2</li>
						<li><a href="#">PAGES!</a></li>
						<li><a href="#">PAGES!</a></li>
					</ul>
				</div></li>
				-->
			<c:if test = "${sessionScope.login_accounttype == 'admin'}">
			<li class="dropdown"><a href="#" class="dropdown-toggle"
				data-toggle="dropdown">
					<div class="icon">
						<i class="fa fa-bug" aria-hidden="true"></i>
					</div>
					<div class="title">Developer Pages</div>
			</a>
				<div class="dropdown-menu">
					<ul>
						<li class="section"><i class="fa fa-file-o"
							aria-hidden="true"></i> Current Modules</li>
						<li><a href="curriculum-builder">Curriculum Builder</a></li>
						<li><a href="accounts">Accounts</a></li>
						<li><a href="subjects">Subjects</a></li>
						<li><a href="schools">Schools</a></li>
						<li><a href="degrees">Degrees</a></li>
						<li><a href="admission">Admission</a></li>
						<li class="line"></li>
						<li class="section"><i class="fa fa-file-o"
							aria-hidden="true"></i>Other Modules</li>
						<li><a href="#">NONE!</a></li>
					</ul>
				</div></li>
			</c:if>
		</ul>
	</div>
</aside>