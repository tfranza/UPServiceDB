# UPServiceDB

UPServiceDB is a database system for a multinational package delivery and supply chain management company whose services can be accessed through a web application deployed as a servlet to allow tracking all the involved entities. 

## Purpose

The purpose of the designed database is to organize the whole set of information that interest shipments and the involved entities such as shipped items, item dealers, information regarding the transportation events and retail centres. 

The designed database is made available to the company through a web app, that allows to execute the standard CRUD operations with particular regard towards specific ones to be optimized:
* Collection of a new item (500/day)
* Registration of a new tracked item (14/day)
* Registration of a new transportation event (14/day)
* Registration of the position for a transport vehicle (100/hour)
* Production of a weekly report with the average delivery time and the number of accomplished deliveries (1/week)

In order to test the scalability and speed of operations, fake data has been generated with worst-case conditions. The evaluation of each operation speed has been carried out quantitatively by considering a complete lifecycle of 10 years. 

## Requirements

OracleDB 14
Java 1.8
	Maven 4.0
		junit 3.8.1
		javax.servlet-api 4.0.1
		hibernate-core 5.2.8.Final
		ejb-api 3.0
		maven-compiler-plugin 3.8.1
	jstl.jar 
	ojdbc14.jar 
	standard.jar 
Apache Tomcat

## Usage 

1. Create an empty database in Oracle Database and setup the database architecture by using the "UPdb.sql" file. 
2. Update the username and password of your database into the "persistence.xml" file (servlet/src/main/resources/META-INF/)
3. Compile the java project ("servlet/") and the java application will generate the class objects along with a .war file (servlet/target/). 
4. Run Apache Tomcat and visit the 'index.jsp' page using your web browser (e.g. "localhost:8080/index.jsp").

## Authors

All the following authors have equally contributed to this project (listed in alphabetical order by surname):
* Tiziano Franza


