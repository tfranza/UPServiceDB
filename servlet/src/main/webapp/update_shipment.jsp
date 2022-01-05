<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Update Shipment</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.css"> 
</head>
<body>

<div class="container">

	<%@ include file="menu.jsp" %>

	<div class="row"> 
		<div class="col-md-12">
			<div class="page-header"><br><h3><pre> Update a Shipment</pre></h3></div>
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
					<form action="Shipment" method="post">
						<input type="hidden" name="operation" value="S_update_shipment">
						<div class="row">
							<div class="col-md-3">
								<input type="text" name="shipmentcodeShipment" placeholder="ShipmentCode of the shipment" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="destinationShipment" placeholder="Destination of the shipment" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="withdrawaldateShipment" placeholder="WithdrawalDate of the shipment" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="deliverydateShipment" placeholder="DeliveryDate of the shipment" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="earningsShipment" placeholder="Earnings of the shipment" class="form-control">
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
					<form action="Shipment" method="post">
						<input type="hidden" name="operation" value="update_shipment">
						<div class="row">
							<div class="col-md-3">
								<input type="text" name="shipmentCodeShipment" placeholder="ShipmentCode of the shipment" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="destinationShipment" placeholder="Updated destination" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="withdrawalDateShipment" placeholder="Updated withdrawalDate" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="deliveryDateShipment" placeholder="Updated deliveryDate" class="form-control">
							</div>
							<div class="col-md-3">
								<input type="text" name="earningsShipment" placeholder="Updated earnings" class="form-control">
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
								<td><b>SHIPMENTCODE</b></td>
								<td><b>DESTINATION</b></td>
								<td><b>WITHDRAWALDATE</b></td>
								<td><b>DELIVERYDATE</b></td>
								<td><b>EARNINGS</b></td>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="item" items="${listShipments}">
								<tr>
									<td>${item.shipmentCode}</td>
									<td>${item.destination}</td>
									<td>${item.withdrawalDate}</td>
									<td>${item.deliveryDate}</td>
									<td>${item.earnings}</td>
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