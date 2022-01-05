package com.franza.UP.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedStoredProcedureQueries;
import javax.persistence.NamedStoredProcedureQuery;
import javax.persistence.ParameterMode;
import javax.persistence.StoredProcedureParameter;

import com.franza.UP.to.DealerTO;
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
		name = "createDealer",
		procedureName = "createDealer",
		resultClasses = { Dealer.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "kind"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "name"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "phone"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "mail"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "zip"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "country"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "city"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "street"),
		}
	),
	@NamedStoredProcedureQuery(
		name = "readDealer",
		procedureName = "readDealer",
		resultClasses = { Dealer.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "id"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "kind"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "name"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "phone"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "mail"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "zip"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "country"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "city"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "street"),
		}
	),
	@NamedStoredProcedureQuery(
		name = "updateDealer",
		procedureName = "updateDealer",
		resultClasses = { Dealer.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "id"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "kind"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "name"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "phone"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "mail"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "zip"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "country"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "city"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "street"),
		}
	),
	@NamedStoredProcedureQuery(
		name = "deleteDealer",
		procedureName = "deleteDealer",
		resultClasses = { Dealer.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "id"),
		}
	)
})
public class Dealer extends com.franza.UP.model.Entity implements Serializable{

	@Id 

	/**
	 * <p> Private field to store the id of the dealer. </p>  
	 */
	@Column (name="ID")
	private String id = "";

	/**
	 * <p> Private field to store the kind of the dealer. </p>  
	 */
	@Column (name="KIND")
	private String kind = "";

	/**
	 * <p> Private field to store the name of the dealer. </p>  
	 */
	@Column (name="NAME")
	private String name = "";

	/**
	 * <p> Private field to store the phone of the dealer. </p>  
	 */
	@Column (name="PHONE")
	private String phone = "";

	/**
	 * <p> Private field to store the mail of the dealer. </p>  
	 */
	@Column (name="MAIL")
	private String mail = "";

	/**
	 * <p> Private field to store the address of the dealer. </p>  
	 */ 
	private Address address = new Address();

	// builders
	
	/**
	 * <p> Public method that initializes the dealer fields with the values given in input. </p>
	 * @param id : string that stores the id to be copied into the dealer entity bean.
	 * @param kind : string that stores the kind to be copied into the dealer entity bean.
	 * @param name : string that stores the name to be copied into the dealer entity bean.
	 * @param phone : string that stores the phone to be copied into the dealer entity bean.
	 * @param mail : string that stores the mail to be copied into the dealer entity bean.
	 * @param zip : integer that stores the zip to be copied into the address entity bean.
	 * @param country : string that stores the country to be copied into the address entity bean.
	 * @param city : string that stores the city to be copied into the address entity bean.
	 * @param street : string that stores the street to be copied into the address entity bean.
	 * @return the updated dealer entity bean.
	 */
	public Dealer getFromData(String id, String kind, String name, String phone, String mail, String zip, String country, String city, String street) {
		return setId(id)
			  .setKind(kind)
			  .setName(name)
			  .setPhone(phone)
			  .setMail(mail)
			  .setAddress(Integer.parseInt(zip), country, city, street);
	}

	/**
	 * <p> Public method that initializes the dealer fields with the values of the transfer object given in input. </p>
	 * @param to : transfer object that stores the values to be copied into the dealer entity bean.
	 * @return the updated dealer entity bean.
	 */
	public Dealer getFromTO(TO to) {
		return setId( ((DealerTO) to) .getId())
			  .setKind( ((DealerTO) to) .getKind())
			  .setName( ((DealerTO) to) .getName())
			  .setPhone( ((DealerTO) to) .getPhone())
			  .setMail( ((DealerTO) to) .getMail())
			  .setAddress( ((DealerTO) to) .getZip(), 
					  	   ((DealerTO) to) .getCountry(), 
			  			   ((DealerTO) to) .getCity(),
 			   			   ((DealerTO) to) .getStreet());
	}

	// getters and setters

	/**
	 * <p> Getter method for the instantiated entity bean to get the id of the dealer. </p>
	 * @return the id of the dealer.
	 */
	public String getId() { 
		return id; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the id of the dealer. </p>
	 * @param id : id of the dealer.
	 * @return the dealer with the updated id.
	 */
	public Dealer setId(String id) { 
		this.id = id; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the kind of the dealer. </p>
	 * @return the kind of the dealer.
	 */
	public String getKind() { 
		return kind; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the kind of the dealer. </p>
	 * @param kind : kind of the dealer.
	 * @return the dealer with the updated kind.
	 */
	public Dealer setKind(String kind) { 
		this.kind = kind; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the name of the dealer. </p>
	 * @return the name of the dealer.
	 */
	public String getName() { 
		return name; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the name of the dealer. </p>
	 * @param name : name of the dealer.
	 * @return the dealer with the updated name.
	 */
	public Dealer setName(String name) { 
		this.name = name; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the phone of the dealer. </p>
	 * @return the phone of the dealer.
	 */
	public String getPhone() { 
		return phone; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the phone of the dealer. </p>
	 * @param phone : phone of the dealer.
	 * @return the dealer with the updated phone.
	 */
	public Dealer setPhone(String phone) { 
		this.phone = phone; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the mail of the dealer. </p>
	 * @return the mail of the dealer.
	 */
	public String getMail() { 
		return mail; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the mail of the dealer. </p>
	 * @param mail : mail of the dealer.
	 * @return the dealer with the updated mail.
	 */
	public Dealer setMail(String mail) { 
		this.mail = mail; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the address of the dealer. </p>
	 * @return the zip of the dealer.
	 */
	public Address getAddress() { 
		return address; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the address of the dealer. </p>
	 * @param zip : address of the dealer.
	 * @return the dealer with the updated address.
	 */
	public Dealer setAddress(Integer zip, String country, String city, String street) {
		this.address.setZip(zip).setCountry(country).setCity(city).setStreet(street); 
		return this;
	}

	// utilities

	@Override
	public String toString() {
		return "Dealer [id=" + id + 
						  ", kind=" + kind + 
						  ", name=" + name + 
						  ", phone=" + phone + 
						  ", mail=" + mail + 
						  ", zip=" + address.getZip() + 
						  ", country=" + address.getCountry() + 
						  ", city=" + address.getCity() + 
						  ", street=" + address.getStreet() + "]";
	}

}