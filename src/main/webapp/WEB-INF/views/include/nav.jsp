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
									class="highlight">School</span> Management System</a></li>
							<li>
								<button type="button" class="navbar-toggle">
									<img class="profile-img"
										src="<c:url value="/resources/assets/images/profile.png" />">
								</button>
							</li>
						</ul>
						<ul class="nav navbar-nav navbar-left">
							<li class="navbar-title">${page_title}</li>
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
										<h4 class="username">${sessionScope.login_fullname}</h4>
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