<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Read WeeklyReport</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.css"> 
</head>
<body>

<div class="container">

	<%@ include file="menu.jsp" %>

	<div class="row"> 
		<div class="col-md-12">
			<div class="page-header"><br><h3><pre> Read a WeeklyReport</pre></h3></div>
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
					<form action="WeeklyReport" method="post">
						<input type="hidden" name="operation" value="create_weeklyReport">
						<div class="row">
							<div class="col-md-3" align="right">
								<input type="submit" value="READ" class="btn btn-primary">
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
								<td><b>ID</b></td>
								<td><b>STAMP</b></td>
								<td><b>AVERAGEDAYS</b></td>
								<td><b>NSHIPMENTS</b></td>
								<td><b>EARNINGS</b></td>
								<td><b>VEHICLEMAINTENANCE</b></td>
								<td><b>TOTAL</b></td>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="item" items="${listWeeklyReports}">
								<tr>
									<td>${item.id}</td>
									<td>${item.stamp}</td>
									<td>${item.averageDays}</td>
									<td>${item.nShipments}</td>
									<td>${item.earnings}</td>
									<td>${item.vehicleMaintenance}</td>
									<td>${item.total}</td>
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