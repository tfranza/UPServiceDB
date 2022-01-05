package com.franza.UP.util;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;

/**
 * <p> Instantiable class that handles the operations with the database through an entity manager. </p>
 */
public class EntityManagerHandler {
	
	/**
	 * <p> Private field to store the instance of the entity manager. </p>  
	 */
	private EntityManager em;

	/**
	 * <p> Private field to store the instance of the entity manager factory. </p>  
	 */
	private EntityManagerFactory emf;
	
	/**
	 * <p> Private field to store the instance of the entity transaction. </p>  
	 */
	private EntityTransaction et;
	
	/**
	 * <p> Constructor that invokes the load function to load persistence unit. </p>
	 * @param persistenceUnitName : name of the persistence unit to be used to get the linking with the database through the persistence.xml file. 
	 */
	public EntityManagerHandler (String persistenceUnitName) {
		load(persistenceUnitName);
	}
	
	/**
	 * <p> Private method that opens the connection with the database using the persistence unit and starts a new transaction. </p>
	 * @param persistenceUnitName : name of the persistence unit to be used to get the linking with the database through the persistence.xml file. 
	 * @return nothing.
	 */
	private void load(String persistenceUnitName) {
		emf = Persistence.createEntityManagerFactory(persistenceUnitName);
		em = emf.createEntityManager();
		et = em.getTransaction();
		et.begin();
	}
	
	/**
	 * <p> Private method that commits the transaction and closes the connection with the database. </p>
	 */
	public void commit() {
		et.commit();
		em.close();
		emf.close();
	}

	// getters and setters
	/**
	 * <p> Getter method to provide the entity manager instance. </p>
	 * @return the entity manager instance.
	 */
	public EntityManager getEm() {
		return em;
	}

	/**
	 * <p> Setter method to set the entity manager instance. </p>
	 * @param em : the entity manager instance
	 */
	public void setEm(EntityManager em) {
		this.em = em;
	}
		
}