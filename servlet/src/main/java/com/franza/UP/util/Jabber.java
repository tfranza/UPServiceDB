package com.franza.UP.util;

import javax.servlet.http.HttpServletRequest;

/**
 * <p> Instantiable class that is used to send messages regarding the success or failure of the operations. </p>
 */
public class Jabber {
	
	/**
	 * <p> Setter method that elaborates a message. </p>
	 * @param req : http request that needs to be updated with the right message.
	 * @param errorMessage : error message to be displayed in case of failure.
	 */
	public static void setMessage (HttpServletRequest req, String errorMessage) {
		String operation = req.getParameter("operation");
		if (operation.contains("S_"))
			return;
		String tense = operation.split("_")[0];
		String entity = operation.split("_")[1];
		
		switch (tense) {
			case "create": {
				tense = " INSERTED";
				break;
			}
			case "read": {
				tense = " LISTED";
				break;
			}
			case "update": {
				tense = " UPDATED";
				break;
			}
			case "delete": {
				tense = " DELETED";
				break;
			}
		}
		
		if (errorMessage == null)
			setSuccessMessage (req, entity.toUpperCase() + tense + " SUCCESSFULLY!");
		else 
			setFailureMessage (req, entity.toUpperCase() + " WAS NOT " + tense, errorMessage);
	}
	
	/**
	 * <p> Setter method that elaborates a success message. </p>
	 * @param req : http request that needs to be updated with the success message.
	 * @param message : message to be displayed in case of success.
	 * @return nothing.
	 */
	private static void setSuccessMessage (HttpServletRequest req, String message) {
		req.setAttribute("messageType", "alert success");
		req.setAttribute("messageSuccess", message);
	}
	
	/**
	 * <p> Setter method that elaborates a failure message. </p>
	 * @param req : http request that needs to be updated with the failure message.
	 * @param message : message to be displayed in case of failure.
	 * @param errorMessage : error message to be displayed in case of failure.
	 * @return nothing.
	 */
	private static void setFailureMessage (HttpServletRequest req, String message, String errorMessage) {
		req.setAttribute("messageType", "alert failure");
		req.setAttribute("messageDanger", message);
		req.setAttribute("error", errorMessage);
	}
}