package com.franza.UP.dao;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.ParameterMode;

import com.franza.UP.model.Entity;
import com.franza.UP.model.Shipment;
import com.franza.UP.util.EntityManagerHandler;

/**
 * <p> Instantiable class that implements the DAO interface to access and manipulate shipments. </p>  
 */
public class ShipmentDAO implements DAO {

	/**
	 * <p> Private field to store the name of the persistence unit for the specific DAO class. </p>  
	 */
	private String persistenceUnitName;

	/**
	 * <p> Constructor that initializes the name of the persistence unit for shipments. </p>
	 */
	public ShipmentDAO() {
		persistenceUnitName = "ShipmentPU";
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to add a new shipment for the specific shipment. </p>
	 * @param entity : entity bean needed to encapsulate and transfer shipment data from the java bean to the database.
	 */
	public void create (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("createShipment", Shipment.class)
				.registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
				.setParameter(1, ((Shipment) entity).getDestination()) 
				.setParameter(2, ((Shipment) entity).getWithdrawalDate()) 
				.setParameter(3, ((Shipment) entity).getDeliveryDate()) 
				.execute();
		emh.commit();
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to read several shipments with the specific search key stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate and use the shipment search key taken from the java bean.
	 * @return the list of the extracted tuples encapsulated into entity beans.
	 */
	public List<Entity> read (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("readShipment", Shipment.class)
				.registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(4, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(5, Integer.class, ParameterMode.IN)
				.setParameter(1, ((Shipment) entity).getShipmentCode()) 
				.setParameter(2, ((Shipment) entity).getDestination()) 
				.setParameter(3, ((Shipment) entity).getWithdrawalDate()) 
				.setParameter(4, ((Shipment) entity).getDeliveryDate()) 
				.setParameter(5, ((Shipment) entity).getEarnings()) 
				.execute();
		List<Entity> list = new ArrayList<>();
		for (Object o: emh.getEm().createNativeQuery("SELECT * FROM tempShipment").getResultList())
			list.add( new Shipment().getFromData( 
               (String) ((Object[])o)[0].toString(), 
               (String) ((Object[])o)[1].toString(), 
               (String) ((Object[])o)[2].toString(), 
               (String) ((Object[])o)[3].toString(), 
               (String) ((Object[])o)[4].toString()) );
		emh.commit();
		return list;
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to update a shipment with the specific values stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate the update values of the shipment into an entity bean, taken from the java bean.
	 */
	public void update (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("updateShipment", Shipment.class)
				.registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(4, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(5, Integer.class, ParameterMode.IN)
				.setParameter(1, ((Shipment) entity).getShipmentCode()) 
				.setParameter(2, ((Shipment) entity).getDestination()) 
				.setParameter(3, ((Shipment) entity).getWithdrawalDate()) 
				.setParameter(4, ((Shipment) entity).getDeliveryDate()) 
				.setParameter(5, ((Shipment) entity).getEarnings()) 
				.execute();
		emh.commit();
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to delete a shipment with the specific values stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate the deletion values of the shipment into an entity bean, taken from the java bean.
	 */
	public void delete (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("deleteShipment", Shipment.class)
				.registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
				.setParameter(1, ((Shipment) entity).getShipmentCode()) 
				.execute();
		emh.commit();
	}

}