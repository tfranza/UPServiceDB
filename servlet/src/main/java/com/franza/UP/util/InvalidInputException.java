package com.franza.UP.util;

/**
 * <p> Instantiable class that extends the Exception class and handles input errors. </p>
 */
@SuppressWarnings("serial")
public class InvalidInputException extends Exception{
	
	/**
	 * <p> Private field to store the prefix of the message that will appear when the exception is thrown. </p>  
	 */
	private static final String prefix = "Invalid input! ";
	
	/**
	 * <p> Standard empty constructor. </p>
	 */
	public InvalidInputException () { 
		super();
	}
	
	/**
	 * <p> Constructor with a message. </p>
	 * @param errorMessage : the error to be displayed once the exception is thrown.
	 */
	public InvalidInputException (String errorMessage) {
		super(prefix + errorMessage);
	}
	
	/**
	 * <p> Constructor with a message and a throwable error. </p>
	 * @param errorMessage : the error to be displayed once the exception is thrown.
	 * @param err : the custom error to be displayed once the specific exception is thrown.
	 */
	public InvalidInputException (String errorMessage, Throwable err) {
		super(prefix + errorMessage, err);
	}
	
	/**
	 * <p> Getter method for the instantiated exception to get the prefix of the message. </p>
	 * @return the prefix of the message.
	 */
	public String getMessage() {
		return prefix;
	}
}