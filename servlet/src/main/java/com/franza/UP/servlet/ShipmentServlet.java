package com.franza.UP.servlet;

import java.io.IOException;

import javax.ejb.EJB;
import javax.persistence.PostLoad;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.franza.UP.ac.ShipmentAC;
import com.franza.UP.bean.ShipmentBeanLocal;
import com.franza.UP.util.Jabber;

/**
 * <p> Instantiable class that extends the HttpServlet class and implements: </p>
 * 	 <ul><li> the java bean for the shipment operations, </li> 
 *       <li> the basic functions that are linked to the http get and post requests. </li></ul>
 */
@SuppressWarnings("serial")
@WebServlet(name="ShipmentServlet", urlPatterns={"/UP/Shipment"})
public class ShipmentServlet extends HttpServlet{

	/**
	 * <p> Private field to store the shipment java bean. The annotation @EJB permits to the java bean to be instantiated through injection. </p>  
	 */
	@EJB
	private ShipmentBeanLocal shipment;

	@Override
	@PostLoad
	protected void doGet (HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String operation = req.getParameter("operation");
		String jspPage = operation.contains("S_")? operation.substring(2): operation;
		operation = operation.contains("S_")? "read_shipment": operation;
		try {
			req.setAttribute("listShipments", new ShipmentAC().setBean(shipment).handleOperation(req, operation));
			Jabber.setMessage(req, null);
		} catch (Exception e) {
			e.printStackTrace();
			Jabber.setMessage(req, e.getMessage());
		} finally {
			req.getRequestDispatcher(jspPage + ".jsp").forward(req, resp);
		}
	}

	@Override
	@PostLoad
	protected void doPost (HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}

}
