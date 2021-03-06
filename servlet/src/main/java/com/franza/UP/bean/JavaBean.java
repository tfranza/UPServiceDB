package com.franza.UP.bean;

import java.util.List;

import com.franza.UP.to.TO;
import com.franza.UP.util.InvalidInputException;

/**
 * <p> Interface that contains all the signatures for the generic CRUD operations further implemented in the correlated java bean classes. </p>
 */
public interface JavaBean {
	
	/**
	 * <p> Signature of a method that delegates the data access object to generate a new instance in the database using an entity bean. </p>
	 * @param to : transfer object needed to encapsulate and transfer data from the application controller to the entity bean.
	 * @return the list of the result for the executed operation of creation: has to contain the inserted tuple.
	 * @throws InvalidInputException Exception thrown when one or more inputs given by the user are not valid. It is generated by the read function of this same class.
	 */
	public List<TO> create (TO to) throws InvalidInputException;
	
	/**
	 * <p> Signature of a method that delegates the data access object to read a list of instances in the database using an entity bean as a search key. </p> 
	 * @param to : transfer object needed to encapsulate and transfer data from the application controller to the entity bean.
	 * @return the list of the result for the executed operation of reading: has to contain all the tuples that satisfy the search key.
	 * @throws InvalidInputException Exception thrown when one or more inputs given by the user are not valid. It is generated by the operation that moves the data from the transfer object to the entity bean.
	 */
	public List<TO> read (TO to) throws InvalidInputException;
	
	/**
	 * <p> Signature of a method that delegates the data access object to update an instance already present in the database using an entity bean. </p>
	 * @param to : transfer object needed to encapsulate and transfer data from the application controller to the entity bean.
	 * @return the list of the result for the executed operation of update: has to contain the updated tuple.
	 * @throws InvalidInputException Exception thrown when one or more inputs given by the user are not valid. It is generated by the read function of this same class.
	 */
	public List<TO> update (TO to) throws InvalidInputException;
	
	/**
	 * <p> Signature of a method that delegates the data access object to delete an instance present in the database using an entity bean. </p>
	 * @param to : transfer object needed to encapsulate and transfer data from the application controller to the entity bean.
	 * @return the list of the result for the executed operation of deletion: has to contain no tuples.
	 * @throws InvalidInputException Exception thrown when one or more inputs given by the user are not valid. It is generated by the read function of this same class.
	 */
	public List<TO> delete (TO to) throws InvalidInputException;
	
}