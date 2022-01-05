<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Read Dealer</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.css"> 
</head>
<body>

<div class="container">

	<%@ include file="menu.jsp" %>

	<div class="row"> 
		<div class="col-md-12">
			<div class="page-header"><br><h3><pre> Read a Dealer</pre></h3></div>
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
					<form action="Dealer" method="post">
						<input type="hidden" name="operation" value="read_dealer">
						<div class="row">
							<div class="col-md-3">
								<input type="text" name="idDealer" placeholder="Id of the dealer" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="kindDealer" placeholder="Kind of the dealer" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="nameDealer" placeholder="Name of the dealer" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="phoneDealer" placeholder="Phone of the dealer" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="mailDealer" placeholder="Mail of the dealer" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="zipDealer" placeholder="Zip of the dealer" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="countryDealer" placeholder="Country of the dealer" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="cityDealer" placeholder="City of the dealer" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="streetDealer" placeholder="Street of the dealer" class="form-control">
							</div>
		 					<div class="col-md-3" align="right">
								<input type="submit" value="SEARCH" class="btn btn-primary">
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
								<td><b>KIND</b></td>
								<td><b>NAME</b></td>
								<td><b>PHONE</b></td>
								<td><b>MAIL</b></td>
								<td><b>ZIP</b></td>
								<td><b>COUNTRY</b></td>
								<td><b>CITY</b></td>
								<td><b>STREET</b></td>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="item" items="${listDealers}">
								<tr>
									<td>${item.id}</td>
									<td>${item.kind}</td>
									<td>${item.name}</td>
									<td>${item.phone}</td>
									<td>${item.mail}</td>
									<td>${item.zip}</td>
									<td>${item.country}</td>
									<td>${item.city}</td>
									<td>${item.street}</td>
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