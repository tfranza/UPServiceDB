package com.franza.UP.dao;

import java.sql.SQLException;
import java.util.List;

import com.franza.UP.model.Entity;

/**
 * <p> Interface that contains all the signatures for the generic CRUD operations further implemented in the correlated data access object classes. </p>
 */
public interface DAO {
	
	/**
	 * <p> Signature of a method to access the database and generate a new tuple using an EntityManager. </p>
	 * @param entity : entity bean needed to encapsulate and transfer instance data from the java bean to the database.
	 * @throws SQLException Exception thrown when the JDBC encounters an error during the interaction with the data source.
	 */
	public void create(Entity entity) throws SQLException;
	
	/**
	 * <p> Signature of a method to access the database and read several tuples using an EntityManager. </p>
	 * @param entity : entity bean needed to encapsulate and transfer instance data from the java bean to the database.
	 * @return nothing.
	 * @throws SQLException Exception thrown when the JDBC encounters an error during the interaction with the data source.
	 */
	public List<Entity> read(Entity entity) throws SQLException;
	
	/**
	 * <p> Signature of a method to access the database and update a tuple using an EntityManager. </p>
	 * @param entity : entity bean needed to encapsulate and transfer instance data from the java bean to the database.
	 * @throws SQLException Exception thrown when the JDBC encounters an error during the interaction with the data source.
	 */
	public void update(Entity entity) throws SQLException;
	
	/**
	 * <p> Signature of a method to access the database and delete a tuple using an EntityManager. </p>
	 * @param entity : entity bean needed to encapsulate and transfer instance data from the java bean to the database.
	 * @throws SQLException Exception thrown when the JDBC encounters an error during the interaction with the data source.
	 */
	public void delete(Entity entity) throws SQLException;
}