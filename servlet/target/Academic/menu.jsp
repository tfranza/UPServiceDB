<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://code.jquery.com/jquery-3.3.1.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.css">

<nav class="navbar navbar-expand-md navbar-dark bg-dark sticky-top">
	<a class="navbar-brand"><img src=gear.png height=30></a>
	<div class="collapse navbar-collapse" id="navbarSupportedContent">
		<ul class="navbar-nav mr-auto">
    		<li class="nav-item">
        		<a class="nav-link" href="index.jsp">Home <span class="sr-only">(current)</span></a>
    	  	</li>
	      	<li class="nav-item dropdown">
    	    	<a class="nav-link dropdown-toggle" href="#" id="createDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
	        		C
	        		<span class="caret"></span>
        		</a>
        		<ul class="dropdown-menu" aria-labelledby="createDropdown">
        	  		<li><a class="dropdown-item" href="create_department.jsp">Department</a></li>
        		    <li><a class="dropdown-item" href="create_institution.jsp">Institution</a></li>
        		</ul>
      		</li>
	      	<li class="nav-item dropdown">
    	    	<a class="nav-link dropdown-toggle" href="#" id="readDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
	        		R
	        		<span class="caret"></span>
        		</a>
        		<ul class="dropdown-menu" aria-labelledby="readDropdown">
        	  		<li><a class="dropdown-item" href="read_department.jsp">Department</a></li>
        		    <li><a class="dropdown-item" href="read_institution.jsp">Institution</a></li>
        		</ul>
      		</li>
      		<li class="nav-item dropdown">
    	    	<a class="nav-link dropdown-toggle" href="#" id="updateDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
	        		U
	        		<span class="caret"></span>
        		</a>
        		<ul class="dropdown-menu" aria-labelledby="updateDropdown">
        	  		<li><a class="dropdown-item" href="update_department.jsp">Department</a></li>
        		    <li><a class="dropdown-item" href="update_institution.jsp">Institution</a></li>
        		</ul>
      		</li>
      		<li class="nav-item dropdown">
    	    	<a class="nav-link dropdown-toggle" href="#" id="deleteDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
	        		D
	        		<span class="caret"></span>
        		</a>
        		<ul class="dropdown-menu" aria-labelledby="deleteDropdown">
        	  		<li><a class="dropdown-item" href="delete_department.jsp">Department</a></li>
        		    <li><a class="dropdown-item" href="delete_institution.jsp">Institution</a></li>
        		</ul>
      		</li>
      		<li class="nav-item dropdown">
    	    	<a class="nav-link dropdown-toggle" href="#" id="operationsDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
	        		Operations
	        		<span class="caret"></span>
        		</a>
        		<ul class="dropdown-menu" aria-labelledby="operationsDropdown">
        	  	</ul>
      		</li>
    	</ul>
  	</div>	
</nav>
