package com.franza.UP.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedStoredProcedureQueries;
import javax.persistence.NamedStoredProcedureQuery;
import javax.persistence.ParameterMode;
import javax.persistence.StoredProcedureParameter;

import com.franza.UP.to.CentreTO;
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
		name = "createCentre",
		procedureName = "createCentre",
		resultClasses = { Centre.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "kind"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "address"),
		}
	),
	@NamedStoredProcedureQuery(
		name = "readCentre",
		procedureName = "readCentre",
		resultClasses = { Centre.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "id"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "kind"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "address"),
		}
	),
	@NamedStoredProcedureQuery(
		name = "updateCentre",
		procedureName = "updateCentre",
		resultClasses = { Centre.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "id"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "kind"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "address"),
		}
	),
	@NamedStoredProcedureQuery(
		name = "deleteCentre",
		procedureName = "deleteCentre",
		resultClasses = { Centre.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "id"),
		}
	)
})
public class Centre extends com.franza.UP.model.Entity implements Serializable{

	@Id 

	/**
	 * <p> Private field to store the id of the centre. </p>  
	 */
	@Column (name="ID")
	private Integer id = -1;

	/**
	 * <p> Private field to store the kind of the centre. </p>  
	 */
	@Column (name="KIND")
	private String kind = "";

	/**
	 * <p> Private field to store the address of the centre. </p>  
	 */
	@Column (name="ADDRESS")
	private String address = "";

	// builders
	/**
	 * <p> Public method that initializes the centre fields with the values given in input. </p>
	 * @param id : integer that stores the id to be copied into the centre entity bean.
	 * @param kind : string that stores the kind to be copied into the centre entity bean.
	 * @param address : string that stores the address to be copied into the centre entity bean.
	 * @return the updated centre entity bean.
	 */
	public Centre getFromData(String id, String kind, String address) {
		return setId(Integer.parseInt(id))
			  .setKind(kind)
			  .setAddress(address);
	}

	/**
	 * <p> Public method that initializes the centre fields with the values of the transfer object given in input. </p>
	 * @param to : transfer object that stores the values to be copied into the centre entity bean.
	 * @return the updated centre entity bean.
	 */
	public Centre getFromTO(TO to) {
		return setId( ((CentreTO) to) .getId())
			  .setKind( ((CentreTO) to) .getKind())
			  .setAddress( ((CentreTO) to) .getAddress());
	}

	// getters and setters

	/**
	 * <p> Getter method for the instantiated entity bean to get the id of the centre. </p>
	 * @return the id of the centre.
	 */
	public Integer getId() { 
		return id; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the id of the centre. </p>
	 * @param id : id of the centre.
	 * @return the centre with the updated id.
	 */
	public Centre setId(Integer id) { 
		this.id = id; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the kind of the centre. </p>
	 * @return the kind of the centre.
	 */
	public String getKind() { 
		return kind; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the kind of the centre. </p>
	 * @param kind : kind of the centre.
	 * @return the centre with the updated kind.
	 */
	public Centre setKind(String kind) { 
		this.kind = kind; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the address of the centre. </p>
	 * @return the address of the centre.
	 */
	public String getAddress() { 
		return address; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the address of the centre. </p>
	 * @param address : address of the centre.
	 * @return the centre with the updated address.
	 */
	public Centre setAddress(String address) { 
		this.address = address; 
		return this;
	}

	// utilities

	@Override
	public String toString() {
		return "Centre [id=" + id + 
						  ", kind=" + kind + 
						  ", address=" + address + "]";
	}

}