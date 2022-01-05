package com.franza.UP.servlet;

import java.io.IOException;

import javax.ejb.EJB;
import javax.persistence.PostLoad;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.franza.UP.ac.CentreAC;
import com.franza.UP.bean.CentreBeanLocal;
import com.franza.UP.util.Jabber;

/**
 * <p> Instantiable class that extends the HttpServlet class and implements: </p>
 * 	 <ul><li> the java bean for the centre operations, </li> 
 *       <li> the basic functions that are linked to the http get and post requests. </li></ul>
 */
@SuppressWarnings("serial")
@WebServlet(name="CentreServlet", urlPatterns={"/UP/Centre"})
public class CentreServlet extends HttpServlet{

	/**
	 * <p> Private field to store the centre java bean. The annotation @EJB permits to the java bean to be instantiated through injection. </p>  
	 */
	@EJB
	private CentreBeanLocal centre;

	@Override
	@PostLoad
	protected void doGet (HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String operation = req.getParameter("operation");
		String jspPage = operation.contains("S_")? operation.substring(2): operation;
		operation = operation.contains("S_")? "read_centre": operation;
		try {
			req.setAttribute("listCentres", new CentreAC().setBean(centre).handleOperation(req, operation));
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
