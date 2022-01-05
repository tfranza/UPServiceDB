package com.franza.UP.dao;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.ParameterMode;

import com.franza.UP.model.Entity;
import com.franza.UP.model.Dealer;
import com.franza.UP.util.EntityManagerHandler;

/**
 * <p> Instantiable class that implements the DAO interface to access and manipulate dealers. </p>  
 */
public class DealerDAO implements DAO {

	/**
	 * <p> Private field to store the name of the persistence unit for the specific DAO class. </p>  
	 */
	private String persistenceUnitName;

	/**
	 * <p> Constructor that initializes the name of the persistence unit for dealers. </p>
	 */
	public DealerDAO() {
		persistenceUnitName = "DealerPU";
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to add a new dealer for the specific dealer. </p>
	 * @param entity : entity bean needed to encapsulate and transfer dealer data from the java bean to the database.
	 */
	public void create (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("createDealer", Dealer.class)
				.registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(4, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(5, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(6, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(7, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(8, String.class, ParameterMode.IN)
				.setParameter(1, ((Dealer) entity).getKind()) 
				.setParameter(2, ((Dealer) entity).getName()) 
				.setParameter(3, ((Dealer) entity).getPhone()) 
				.setParameter(4, ((Dealer) entity).getMail()) 
				.setParameter(5, ((Dealer) entity).getAddress().getZip()) 
				.setParameter(6, ((Dealer) entity).getAddress().getCountry()) 
				.setParameter(7, ((Dealer) entity).getAddress().getCity()) 
				.setParameter(8, ((Dealer) entity).getAddress().getStreet()) 
				.execute();
		emh.commit();
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to read several dealers with the specific search key stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate and use the dealer search key taken from the java bean.
	 * @return the list of the extracted tuples encapsulated into entity beans.
	 */
	public List<Entity> read (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("readDealer", Dealer.class)
				.registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(4, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(5, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(6, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(7, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(8, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(9, String.class, ParameterMode.IN)
				.setParameter(1, ((Dealer) entity).getId()) 
				.setParameter(2, ((Dealer) entity).getKind()) 
				.setParameter(3, ((Dealer) entity).getName()) 
				.setParameter(4, ((Dealer) entity).getPhone()) 
				.setParameter(5, ((Dealer) entity).getMail()) 
				.setParameter(6, ((Dealer) entity).getAddress().getZip()) 
				.setParameter(7, ((Dealer) entity).getAddress().getCountry()) 
				.setParameter(8, ((Dealer) entity).getAddress().getCity()) 
				.setParameter(9, ((Dealer) entity).getAddress().getStreet()) 
				.execute();
		System.out.println(((Dealer) entity).getId());
		System.out.println(((Dealer) entity).getKind());
		System.out.println(((Dealer) entity).getName());
		System.out.println(((Dealer) entity).getPhone());
		System.out.println(((Dealer) entity).getMail());
		System.out.println(((Dealer) entity).getAddress().getZip());
		System.out.println(((Dealer) entity).getAddress().getCountry());
		System.out.println(((Dealer) entity).getAddress().getCity());
		System.out.println(((Dealer) entity).getAddress().getStreet());

		List<Entity> list = new ArrayList<>();
		for (Object o: emh.getEm().createNativeQuery("SELECT * FROM tempDealer WHERE ROWNUM<31").getResultList())
			list.add( new Dealer().getFromData( 
               (String) ((Object[])o)[0].toString(), 
               (String) ((Object[])o)[1].toString(), 
               (String) ((Object[])o)[2].toString(), 
               (String) ((Object[])o)[3].toString(), 
               (String) ((Object[])o)[4].toString(), 
               (String) ((Object[])o)[5].toString(), 
               (String) ((Object[])o)[6].toString(), 
               (String) ((Object[])o)[7].toString(), 
               (String) ((Object[])o)[8].toString()) );
		emh.commit();
		return list;
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to update a dealer with the specific values stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate the update values of the dealer into an entity bean, taken from the java bean.
	 */
	public void update (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("updateDealer", Dealer.class)
				.registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(3, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(4, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(5, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(6, Integer.class, ParameterMode.IN)
				.registerStoredProcedureParameter(7, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(8, String.class, ParameterMode.IN)
				.registerStoredProcedureParameter(9, String.class, ParameterMode.IN)
				.setParameter(1, ((Dealer) entity).getId()) 
				.setParameter(2, ((Dealer) entity).getKind()) 
				.setParameter(3, ((Dealer) entity).getName()) 
				.setParameter(4, ((Dealer) entity).getPhone()) 
				.setParameter(5, ((Dealer) entity).getMail()) 
				.setParameter(6, ((Dealer) entity).getAddress().getZip()) 
				.setParameter(7, ((Dealer) entity).getAddress().getCountry()) 
				.setParameter(8, ((Dealer) entity).getAddress().getCity()) 
				.setParameter(9, ((Dealer) entity).getAddress().getStreet()) 
				.execute();
		emh.commit();
	}

	/**
	 * <p> Implementation of a method that invokes the EntityManagerHandler to access the database in order to delete a dealer with the specific values stored in the entity bean. </p>
	 * @param entity : entity bean needed to encapsulate the deletion values of the dealer into an entity bean, taken from the java bean.
	 */
	public void delete (Entity entity) {
		EntityManagerHandler emh = new EntityManagerHandler(persistenceUnitName);
		emh.getEm().createStoredProcedureQuery("deleteDealer", Dealer.class)
				.registerStoredProcedureParameter(1, String.class, ParameterMode.IN)
				.setParameter(1, ((Dealer) entity).getId()) 
				.execute();
		emh.commit();
	}

}