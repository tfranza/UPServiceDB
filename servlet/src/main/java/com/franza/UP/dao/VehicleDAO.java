package com.franza.UP.dao;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.ParameterMode;

import com.franza.UP.model.Entity;
import com.franza.UP.model.Vehicle;
import com.franza.UP.util.EntityManagerHandler;

/**
 * <p> Instantiable class that implements the DAO interface to access and manipulate vehicles. </p>  
 */
public class VehicleDAO implements DAO {

	/**
	 * <p> Private field to store the name of the persistence unit for the specific DAO class. </p>  
	 */
	private String persistenceUnitName;

	/**
	 * <p> Constructor that initializes the name of the persistence unit for vehicles. </p>
	 */
	public VehicleDAO() {
		persistenceUnitName = "VehiclePU";
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to add a new vehicle for the specific vehicle. </p>
	 * @param entity : entity bean needed to encapsulate and transfer vehicle data from the java bean to the database.
	 */
	public void create (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("createVehicle", Vehicle.class)
				.registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(4, Integer.class, ParameterMode.IN)
				.setParameter(1, ((Vehicle) entity).getDriver()) 
				.setParameter(2, ((Vehicle) entity).getPlate()) 
				.setParameter(3, ((Vehicle) entity).getKind()) 
				.setParameter(4, ((Vehicle) entity).getCosts()) 
				.execute();
		emh.commit();
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to read several vehicles with the specific search key stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate and use the vehicle search key taken from the java bean.
	 * @return the list of the extracted tuples encapsulated into entity beans.
	 */
	public List<Entity> read (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("readVehicle", Vehicle.class)
				.registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(4, Integer.class, ParameterMode.IN)
				.setParameter(1, ((Vehicle) entity).getDriver()) 
				.setParameter(2, ((Vehicle) entity).getPlate()) 
				.setParameter(3, ((Vehicle) entity).getKind()) 
				.setParameter(4, ((Vehicle) entity).getCosts()) 
				.execute();
		List<Entity> list = new ArrayList<>();
		for (Object o: emh.getEm().createNativeQuery("SELECT * FROM tempVehicle").getResultList())
			list.add( new Vehicle().getFromData( 
               (String) ((Object[])o)[0].toString(), 
               (String) ((Object[])o)[1].toString(), 
               (String) ((Object[])o)[2].toString(), 
               (String) ((Object[])o)[3].toString()) );
		emh.commit();
		return list;
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to update a vehicle with the specific values stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate the update values of the vehicle into an entity bean, taken from the java bean.
	 */
	public void update (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("updateVehicle", Vehicle.class)
				.registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(4, Integer.class, ParameterMode.IN)
				.setParameter(1, ((Vehicle) entity).getDriver()) 
				.setParameter(2, ((Vehicle) entity).getPlate()) 
				.setParameter(3, ((Vehicle) entity).getKind()) 
				.setParameter(4, ((Vehicle) entity).getCosts()) 
				.execute();
		emh.commit();
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to delete a vehicle with the specific values stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate the deletion values of the vehicle into an entity bean, taken from the java bean.
	 */
	public void delete (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("deleteVehicle", Vehicle.class)
				.registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
				.setParameter(1, ((Vehicle) entity).getPlate()) 
				.execute();
		emh.commit();
	}

}