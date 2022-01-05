package com.franza.UP.dao;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.ParameterMode;

import com.franza.UP.model.Entity;
import com.franza.UP.model.WeeklyReport;
import com.franza.UP.util.EntityManagerHandler;

/**
 * <p> Instantiable class that implements the DAO interface to access and manipulate weeklyReports. </p>  
 */
public class WeeklyReportDAO implements DAO {

	/**
	 * <p> Private field to store the name of the persistence unit for the specific DAO class. </p>  
	 */
	private String persistenceUnitName;

	/**
	 * <p> Constructor that initializes the name of the persistence unit for weeklyReports. </p>
	 */
	public WeeklyReportDAO() {
		persistenceUnitName = "WeeklyReportPU";
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to add a new weeklyReport for the specific weeklyReport. </p>
	 * @param entity : entity bean needed to encapsulate and transfer weeklyReport data from the java bean to the database.
	 */
	public void create (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("createWeeklyReport", WeeklyReport.class)
				.registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(3, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(4, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(5, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(6, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(7, Integer.class, ParameterMode.IN)
				.setParameter(1, ((WeeklyReport) entity).getId()) 
				.setParameter(2, ((WeeklyReport) entity).getStamp()) 
				.setParameter(3, ((WeeklyReport) entity).getAverageDays()) 
				.setParameter(4, ((WeeklyReport) entity).getNShipments()) 
				.setParameter(5, ((WeeklyReport) entity).getEarnings()) 
				.setParameter(6, ((WeeklyReport) entity).getVehicleMaintenance()) 
				.setParameter(7, ((WeeklyReport) entity).getTotal()) 
				.execute();
		emh.commit();
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to read several weeklyReports with the specific search key stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate and use the weeklyReport search key taken from the java bean.
	 * @return the list of the extracted tuples encapsulated into entity beans.
	 */
	public List<Entity> read (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		List<Entity> list = new ArrayList<>();
		for (Object o: emh.getEm().createNativeQuery("SELECT * FROM WeeklyReport").getResultList())
			list.add( new WeeklyReport().getFromData( 
               (String) ((Object[])o)[0].toString(), 
               (String) ((Object[])o)[1].toString(), 
               (String) ((Object[])o)[2].toString(), 
               (String) ((Object[])o)[3].toString(), 
               (String) ((Object[])o)[4].toString(), 
               (String) ((Object[])o)[5].toString(), 
               (String) ((Object[])o)[6].toString()) );
		emh.commit();
		return list;
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to update a weeklyReport with the specific values stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate the update values of the weeklyReport into an entity bean, taken from the java bean.
	 */
	public void update (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("updateWeeklyReport", WeeklyReport.class)
				.registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(3, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(4, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(5, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(6, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(7, Integer.class, ParameterMode.IN)
				.setParameter(1, ((WeeklyReport) entity).getId()) 
				.setParameter(2, ((WeeklyReport) entity).getStamp()) 
				.setParameter(3, ((WeeklyReport) entity).getAverageDays()) 
				.setParameter(4, ((WeeklyReport) entity).getNShipments()) 
				.setParameter(5, ((WeeklyReport) entity).getEarnings()) 
				.setParameter(6, ((WeeklyReport) entity).getVehicleMaintenance()) 
				.setParameter(7, ((WeeklyReport) entity).getTotal()) 
				.execute();
		emh.commit();
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to delete a weeklyReport with the specific values stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate the deletion values of the weeklyReport into an entity bean, taken from the java bean.
	 */
	public void delete (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("deleteWeeklyReport", WeeklyReport.class)
				.registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
				.setParameter(1, ((WeeklyReport) entity).getId()) 
				.execute();
		emh.commit();
	}
	
	public void produce (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("produceWeeklyReport", WeeklyReport.class)
				.execute();
		emh.commit();
	}

}