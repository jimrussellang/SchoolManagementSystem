<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="true"%>
<%@page import="java.util.ArrayList" %>
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
					<i class="icon fa fa-navicon (alias)"></i> <span class="help-text">Shortcut</span>
				</button>
				<div class="toggle-content">
					<ul class="actions">
						<li><a href="#">Add new account</a></li>
						<li><a href="accounts">Refresh</a></li>
					</ul>
				</div>
			</div>

			<div class="row">
				<div class="col-xs-12">
					<div class="card">
						<div class="card-header">Accounts List</div>
						<div class="card-body">
							<table class="datatable table table-striped table-bordered table-hover"
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
									<c:forEach var="accounts" items='${requestScope["accounts_accounts-list"]}'>
										<tr>
											<c:forEach var="records" items="${accounts}" varStatus="loop">
												<c:choose>
    												<c:when test="${loop.index=='0'}">
        												<th scope="row"> <c:out value="${records}"/> </th>
    												</c:when>    
   	 												<c:otherwise>
        												<td> <c:out value="${records}"/> </td>
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

	<!-- INITIALIZE BELOW -->
	<%@ include file="include/below_ini.jsp"%>

	<!-- Setup Active Menu in Sidebar -->
	<script>
		$("ul.sidebar-nav > li:eq(4)").addClass("active");
	</script>
</body>

</html>