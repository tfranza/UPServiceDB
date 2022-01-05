package com.franza.UP.model;

import java.io.Serializable;

/**
 * <p> Instantiable class that extends the correspondent abstract entity bean class and implements: </p>
 * 	 <ul><li> the fields of the correspondent tuple stored in the database, </li>
 *       <li> the getter and setter functions, </li>
 *       <li> the utilities functions. </li></ul>
 */
@SuppressWarnings("serial")
public class Address extends com.franza.UP.model.Entity implements Serializable{

	/**
	 * <p> Private field to store the zip of the address. </p>  
	 */
	private Integer zip = -1;

	/**
	 * <p> Private field to store the country of the address. </p>  
	 */
	private String country = "";

	/**
	 * <p> Private field to store the city of the address. </p>  
	 */
	private String city = "";

	/**
	 * <p> Private field to store the street of the address. </p>  
	 */
	private String street = "";

	// getters and setters

	/**
	 * <p> Getter method for the instantiated entity bean to get the zip of the address. </p>
	 * @return the zip of the address.
	 */
	public Integer getZip() { 
		return zip; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the zip of the address. </p>
	 * @param zip : zip of the address.
	 * @return the address with the updated zip.
	 */
	public Address setZip(Integer zip) { 
		this.zip = zip; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the country of the address. </p>
	 * @return the country of the address.
	 */
	public String getCountry() { 
		return country; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the country of the address. </p>
	 * @param country : country of the address.
	 * @return the address with the updated country.
	 */
	public Address setCountry(String country) { 
		this.country = country; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the city of the address. </p>
	 * @return the city of the address.
	 */
	public String getCity() { 
		return city; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the city of the address. </p>
	 * @param city : city of the address.
	 * @return the address with the updated city.
	 */
	public Address setCity(String city) { 
		this.city = city; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the street of the address. </p>
	 * @return the street of the address.
	 */
	public String getStreet() { 
		return street; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the street of the address. </p>
	 * @param street : street of the address.
	 * @return the address with the updated street.
	 */
	public Address setStreet(String street) { 
		this.street = street; 
		return this;
	}

}