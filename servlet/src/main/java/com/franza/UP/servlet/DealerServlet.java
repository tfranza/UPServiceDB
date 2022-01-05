package com.franza.UP.servlet;

import java.io.IOException;

import javax.ejb.EJB;
import javax.persistence.PostLoad;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.franza.UP.ac.DealerAC;
import com.franza.UP.bean.DealerBeanLocal;
import com.franza.UP.util.Jabber;

/**
 * <p> Instantiable class that extends the HttpServlet class and implements: </p>
 * 	 <ul><li> the java bean for the dealer operations, </li> 
 *       <li> the basic functions that are linked to the http get and post requests. </li></ul>
 */
@SuppressWarnings("serial")
@WebServlet(name="DealerServlet", urlPatterns={"/UP/Dealer"})
public class DealerServlet extends HttpServlet{

	/**
	 * <p> Private field to store the dealer java bean. The annotation @EJB permits to the java bean to be instantiated through injection. </p>  
	 */
	@EJB
	private DealerBeanLocal dealer;

	@Override
	@PostLoad
	protected void doGet (HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String operation = req.getParameter("operation");
		String jspPage = operation.contains("S_")? operation.substring(2): operation;
		operation = operation.contains("S_")? "read_dealer": operation;
		try {
			req.setAttribute("listDealers", new DealerAC().setBean(dealer).handleOperation(req, operation));
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
