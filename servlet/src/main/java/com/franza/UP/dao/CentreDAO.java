package com.franza.UP.dao;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.ParameterMode;

import com.franza.UP.model.Entity;
import com.franza.UP.model.Centre;
import com.franza.UP.util.EntityManagerHandler;

/**
 * <p> Instantiable class that implements the DAO interface to access and manipulate centres. </p>  
 */
public class CentreDAO implements DAO {

	/**
	 * <p> Private field to store the name of the persistence unit for the specific DAO class. </p>  
	 */
	private String persistenceUnitName;

	/**
	 * <p> Constructor that initializes the name of the persistence unit for centres. </p>
	 */
	public CentreDAO() {
		persistenceUnitName = "CentrePU";
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to add a new centre for the specific centre. </p>
	 * @param entity : entity bean needed to encapsulate and transfer centre data from the java bean to the database.
	 */
	public void create (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("createCentre", Centre.class)
				.registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
				.setParameter(1, ((Centre) entity).getKind()) 
				.setParameter(2, ((Centre) entity).getAddress()) 
				.execute();
		emh.commit();
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to read several centres with the specific search key stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate and use the centre search key taken from the java bean.
	 * @return the list of the extracted tuples encapsulated into entity beans.
	 */
	public List<Entity> read (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("readCentre", Centre.class)
				.registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
				.setParameter(1, ((Centre) entity).getId()) 
				.setParameter(2, ((Centre) entity).getKind()) 
				.setParameter(3, ((Centre) entity).getAddress()) 
				.execute();
		List<Entity> list = new ArrayList<>();
		for (Object o: emh.getEm().createNativeQuery("SELECT * FROM tempCentre").getResultList())
			list.add( new Centre().getFromData( 
               (String) ((Object[])o)[0].toString(), 
               (String) ((Object[])o)[1].toString(), 
               (String) ((Object[])o)[2].toString()) );
		emh.commit();
		return list;
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to update a centre with the specific values stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate the update values of the centre into an entity bean, taken from the java bean.
	 */
	public void update (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("updateCentre", Centre.class)
				.registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
				.setParameter(1, ((Centre) entity).getId()) 
				.setParameter(2, ((Centre) entity).getKind()) 
				.setParameter(3, ((Centre) entity).getAddress()) 
				.execute();
		emh.commit();
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to delete a centre with the specific values stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate the deletion values of the centre into an entity bean, taken from the java bean.
	 */
	public void delete (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("deleteCentre", Centre.class)
				.registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
				.setParameter(1, ((Centre) entity).getId()) 
				.execute();
		emh.commit();
	}

}