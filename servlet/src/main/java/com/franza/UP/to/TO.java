package com.franza.UP.to;

import javax.servlet.http.HttpServletRequest;

import com.franza.UP.model.Entity;
import com.franza.UP.util.InvalidInputException;

/**
 * <p> Interface that contains: </p>
 * 	 <ul><li> the signatures for builder functions needed to fill the fields of the transfer object, </li>
 *       <li> the signatures for utility functions needed to adjust the queries, </li>
 *       <li> the signatures for checker functions needed to check potential errors in the data. </li></ul>
 */
public interface TO {
	
	// builders
	/**
	 * <p> Signature of a method that initializes the transfer object fields with the values taken from the http request. </p>
	 * @param req : http request that stores the values to be copied into the transfer object.
	 * @return the updated transfer object.
	 */
	public abstract TO getFromRequest (HttpServletRequest req);
	
	/**
	 * <p> Signature of a method that initializes the transfer object fields with the values taken from the correspondent entity bean. </p>
	 * @param entity : entity bean that stores the values to be copied into the transfer object.
	 * @return the updated transfer object.
	 * @throws InvalidInputException Exception thrown when the fields of the transfer object are not valid. It is generated by the checker functions of this same class.
	 */
	public abstract TO getFromEntity (Entity entity) throws InvalidInputException;
			
	// checkers
	
	/**
	 * <p> Signature of a method that checks the values of the primary keys for eventual errors. </p>
	 * @return the checked transfer object.
	 * @throws InvalidInputException Exception thrown when the transfer object primary keys are not valid.
	 */
	public abstract TO checkPrimaryKeys() throws InvalidInputException;
	
	/**
	 * <p> Signature of a method that checks the values of the foreign keys for eventual errors. </p>
	 * @return the checked transfer object.
	 * @throws InvalidInputException Exception thrown when the transfer object foreign keys are not valid.
	 */
	public abstract TO checkForeignKeys() throws InvalidInputException;

	/**
	 * <p> Signature of a method that checks the values of the primary and foreign keys for eventual errors. </p>
	 * @return the checked transfer object.
	 * @throws InvalidInputException Exception thrown when the transfer object primary and foreign keys are not valid.
	 */
	public abstract TO checkKeys() throws InvalidInputException;
	
	// utilities

	/**
	 * <p> Signature of a method that adjusts the values of the transfer object for a search operation. </p>
	 * @param flag : boolean value that considers the possibility of searching a string or a substring.
	 * @return the updated transfer object.
	 * @throws InvalidInputException Exception thrown when the fields of the transfer object are not valid. It is generated by the checker functions of this same class.
	 */
	public abstract TO searchAdjust () throws InvalidInputException;
	
}