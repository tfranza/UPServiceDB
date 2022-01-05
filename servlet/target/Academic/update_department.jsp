<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Update Department.</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.css">
</head>
<body>

<div class="container">

	<%@ include file="menu.jsp" %>
	
	<div class="row"> 
		<div class="col-md-12">
			<div class="page-header"><br><h3><pre> Update a Department</pre></h3></div>
		</div>
	</div>
	<hr>
	
	<div class="row">
		<div class="col-md-12">
			<div class="${messageType }">
				<h3><span class="badge badge-success">${messageSuccess }</span></h3>
				<h3><span class="badge badge-danger">${messageDanger }</span></h3>
				<h3><span class="badge badge-danger">${error }</span></h3>
			</div>
		</div>
	</div>
	
	<div class="card">
		<div class="card-body">
			<div class="row">
				<div class="col-md-12">
					<form action="Department" method="post">
						<input type="hidden" name="operation" value="S_update_department">
						<div class="row">
							<div class="col-md-3">
								<input type="text" name="nameDepartment" placeholder="Name of the Department" class="form-control">
							</div>
		 					<div class="col-md-3">
								<input type="text" name="institutionDepartment" placeholder="Institution of the Department" class="form-control">
							</div>
		 					<div class="col-md-3">
							</div>
		 					<div class="col-md-3" align="right">
								<input type="submit" value="SEARCH" class="btn btn-primary">
							</div>
						</div>
					</form>
				</div>	
			</div>
			<hr>
			<div class="row">
				<div class="col-md-12">
					<form action="Department" method="post">
						<input type="hidden" name="operation" value="update_department">
						<div class="row">
							<div class="col-md-3">
								<input type="text" name="nameDepartment" placeholder="Name of the Department" class="form-control">
							</div>
		 					<div class="col-md-3">
								<input type="text" name="institutionDepartment" placeholder="Updated institution" class="form-control">
							</div>
		 					<div class="col-md-3">
							</div>
		 					<div class="col-md-3" align="right">
								<input type="submit" value="UPDATE" class="btn btn-warning">
							</div>
						</div>
					</form>
				</div>	
			</div>
		</div>
	</div>
	
	<div class="card">
		<div class="card-body">
			<div class="row">
				<div class="col-md-12">
					<table class="table">
						<thead>
							<tr>
								<td><b>NAME</b></td>
								<td><b>INSTITUTION</b></td>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="item" items="${listDepartments}">
								<tr>
									<td>${item.name}</td>
									<td>${item.institution}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	<br>
	<br>
</div>

</body>
</html>


