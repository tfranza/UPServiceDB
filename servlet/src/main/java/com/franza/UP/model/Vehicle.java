package com.franza.UP.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedStoredProcedureQueries;
import javax.persistence.NamedStoredProcedureQuery;
import javax.persistence.ParameterMode;
import javax.persistence.StoredProcedureParameter;

import com.franza.UP.to.VehicleTO;
import com.franza.UP.to.TO;

/**
 * <p> Instantiable class that extends the correspondent abstract entity bean class and implements: </p>
 * 	 <ul><li> the fields of the correspondent tuple stored in the database, </li> 
 *       <li> the builders needed to fill the fields of the entity bean, </li>
 *       <li> the getter and setter functions, </li>
 *       <li> the utilities functions. </li></ul>
 */
@Entity
@SuppressWarnings("serial")

@NamedStoredProcedureQueries ({
	@NamedStoredProcedureQuery(
		name = "createVehicle",
		procedureName = "createVehicle",
		resultClasses = { Vehicle.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "driver"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "plate"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "kind"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "costs"),
		}
	),
	@NamedStoredProcedureQuery(
		name = "readVehicle",
		procedureName = "readVehicle",
		resultClasses = { Vehicle.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "driver"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "plate"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "kind"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "costs"),
		}
	),
	@NamedStoredProcedureQuery(
		name = "updateVehicle",
		procedureName = "updateVehicle",
		resultClasses = { Vehicle.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "driver"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "plate"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "kind"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "costs"),
		}
	),
	@NamedStoredProcedureQuery(
		name = "deleteVehicle",
		procedureName = "deleteVehicle",
		resultClasses = { Vehicle.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "plate"),
		}
	)
})
public class Vehicle extends com.franza.UP.model.Entity implements Serializable{

	@Id 

	/**
	 * <p> Private field to store the driver of the vehicle. </p>  
	 */
	@Column (name="DRIVER")
	private String driver = "";

	/**
	 * <p> Private field to store the plate of the vehicle. </p>  
	 */
	@Column (name="PLATE")
	private String plate = "";

	/**
	 * <p> Private field to store the kind of the vehicle. </p>  
	 */
	@Column (name="KIND")
	private String kind = "";

	/**
	 * <p> Private field to store the costs of the vehicle. </p>  
	 */
	@Column (name="COSTS")
	private Integer costs = -1;

	// builders
	/**
	 * <p> Public method that initializes the vehicle fields with the values given in input. </p>
	 * @param driver : string that stores the driver to be copied into the vehicle entity bean.
	 * @param plate : string that stores the plate to be copied into the vehicle entity bean.
	 * @param kind : string that stores the kind to be copied into the vehicle entity bean.
	 * @param costs : integer that stores the costs to be copied into the vehicle entity bean.
	 * @return the updated vehicle entity bean.
	 */
	public Vehicle getFromData(String driver, String plate, String kind, String costs) {
		return setDriver(driver)
			  .setPlate(plate)
			  .setKind(kind)
			  .setCosts(Integer.parseInt(costs));
	}

	/**
	 * <p> Public method that initializes the vehicle fields with the values of the transfer object given in input. </p>
	 * @param to : transfer object that stores the values to be copied into the vehicle entity bean.
	 * @return the updated vehicle entity bean.
	 */
	public Vehicle getFromTO(TO to) {
		return setDriver( ((VehicleTO) to) .getDriver())
			  .setPlate( ((VehicleTO) to) .getPlate())
			  .setKind( ((VehicleTO) to) .getKind())
			  .setCosts( ((VehicleTO) to) .getCosts());
	}

	// getters and setters

	/**
	 * <p> Getter method for the instantiated entity bean to get the driver of the vehicle. </p>
	 * @return the driver of the vehicle.
	 */
	public String getDriver() { 
		return driver; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the driver of the vehicle. </p>
	 * @param driver : driver of the vehicle.
	 * @return the vehicle with the updated driver.
	 */
	public Vehicle setDriver(String driver) { 
		this.driver = driver; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the plate of the vehicle. </p>
	 * @return the plate of the vehicle.
	 */
	public String getPlate() { 
		return plate; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the plate of the vehicle. </p>
	 * @param plate : plate of the vehicle.
	 * @return the vehicle with the updated plate.
	 */
	public Vehicle setPlate(String plate) { 
		this.plate = plate; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the kind of the vehicle. </p>
	 * @return the kind of the vehicle.
	 */
	public String getKind() { 
		return kind; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the kind of the vehicle. </p>
	 * @param kind : kind of the vehicle.
	 * @return the vehicle with the updated kind.
	 */
	public Vehicle setKind(String kind) { 
		this.kind = kind; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the costs of the vehicle. </p>
	 * @return the costs of the vehicle.
	 */
	public Integer getCosts() { 
		return costs; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the costs of the vehicle. </p>
	 * @param costs : costs of the vehicle.
	 * @return the vehicle with the updated costs.
	 */
	public Vehicle setCosts(Integer costs) { 
		this.costs = costs; 
		return this;
	}

	// utilities

	@Override
	public String toString() {
		return "Vehicle [driver=" + driver + 
						  ", plate=" + plate + 
						  ", kind=" + kind + 
						  ", costs=" + costs + "]";
	}

}