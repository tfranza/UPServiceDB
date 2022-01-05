package com.franza.UP.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedStoredProcedureQueries;
import javax.persistence.NamedStoredProcedureQuery;
import javax.persistence.ParameterMode;
import javax.persistence.StoredProcedureParameter;

import com.franza.UP.to.ShipmentTO;
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
		name = "createShipment",
		procedureName = "createShipment",
		resultClasses = { Shipment.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "destination"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "withdrawalDate"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "deliveryDate")
		}
	),
	@NamedStoredProcedureQuery(
		name = "readShipment",
		procedureName = "readShipment",
		resultClasses = { Shipment.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "shipmentCode"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "destination"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "withdrawalDate"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "deliveryDate"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "earnings"),
		}
	),
	@NamedStoredProcedureQuery(
		name = "updateShipment",
		procedureName = "updateShipment",
		resultClasses = { Shipment.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "shipmentCode"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "destination"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "withdrawalDate"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "deliveryDate"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "earnings"),
		}
	),
	@NamedStoredProcedureQuery(
		name = "deleteShipment",
		procedureName = "deleteShipment",
		resultClasses = { Shipment.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "shipmentCode"),
		}
	)
})
public class Shipment extends com.franza.UP.model.Entity implements Serializable{

	@Id 

	/**
	 * <p> Private field to store the shipmentCode of the shipment. </p>  
	 */
	@Column (name="SHIPMENTCODE")
	private String shipmentCode = "";

	/**
	 * <p> Private field to store the destination of the shipment. </p>  
	 */
	@Column (name="DESTINATION")
	private String destination = "";

	/**
	 * <p> Private field to store the withdrawalDate of the shipment. </p>  
	 */
	@Column (name="WITHDRAWALDATE")
	private String withdrawalDate = "";

	/**
	 * <p> Private field to store the deliveryDate of the shipment. </p>  
	 */
	@Column (name="DELIVERYDATE")
	private String deliveryDate = "";

	/**
	 * <p> Private field to store the earnings of the shipment. </p>  
	 */
	@Column (name="EARNINGS")
	private Integer earnings = -1;

	// builders
	/**
	 * <p> Public method that initializes the shipment fields with the values given in input. </p>
	 * @param shipmentCode : string that stores the shipmentCode to be copied into the shipment entity bean.
	 * @param destination : string that stores the destination to be copied into the shipment entity bean.
	 * @param withdrawalDate : string that stores the withdrawalDate to be copied into the shipment entity bean.
	 * @param deliveryDate : string that stores the deliveryDate to be copied into the shipment entity bean.
	 * @param earnings : integer that stores the earnings to be copied into the shipment entity bean.
	 * @return the updated shipment entity bean.
	 */
	public Shipment getFromData(String shipmentCode, String destination, String withdrawalDate, String deliveryDate, String earnings) {
		return setShipmentCode(shipmentCode)
			  .setDestination(destination)
			  .setWithdrawalDate(withdrawalDate)
			  .setDeliveryDate(deliveryDate)
			  .setEarnings(Integer.parseInt(earnings));
	}

	/**
	 * <p> Public method that initializes the shipment fields with the values of the transfer object given in input. </p>
	 * @param to : transfer object that stores the values to be copied into the shipment entity bean.
	 * @return the updated shipment entity bean.
	 */
	public Shipment getFromTO(TO to) {
		return setShipmentCode( ((ShipmentTO) to) .getShipmentCode())
			  .setDestination( ((ShipmentTO) to) .getDestination())
			  .setWithdrawalDate( ((ShipmentTO) to) .getWithdrawalDate())
			  .setDeliveryDate( ((ShipmentTO) to) .getDeliveryDate())
			  .setEarnings( ((ShipmentTO) to) .getEarnings());
	}

	// getters and setters

	/**
	 * <p> Getter method for the instantiated entity bean to get the shipmentCode of the shipment. </p>
	 * @return the shipmentCode of the shipment.
	 */
	public String getShipmentCode() { 
		return shipmentCode; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the shipmentCode of the shipment. </p>
	 * @param shipmentCode : shipmentCode of the shipment.
	 * @return the shipment with the updated shipmentCode.
	 */
	public Shipment setShipmentCode(String shipmentCode) { 
		this.shipmentCode = shipmentCode; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the destination of the shipment. </p>
	 * @return the destination of the shipment.
	 */
	public String getDestination() { 
		return destination; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the destination of the shipment. </p>
	 * @param destination : destination of the shipment.
	 * @return the shipment with the updated destination.
	 */
	public Shipment setDestination(String destination) { 
		this.destination = destination; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the withdrawalDate of the shipment. </p>
	 * @return the withdrawalDate of the shipment.
	 */
	public String getWithdrawalDate() { 
		return withdrawalDate; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the withdrawalDate of the shipment. </p>
	 * @param withdrawalDate : withdrawalDate of the shipment.
	 * @return the shipment with the updated withdrawalDate.
	 */
	public Shipment setWithdrawalDate(String withdrawalDate) { 
		this.withdrawalDate = withdrawalDate; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the deliveryDate of the shipment. </p>
	 * @return the deliveryDate of the shipment.
	 */
	public String getDeliveryDate() { 
		return deliveryDate; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the deliveryDate of the shipment. </p>
	 * @param deliveryDate : deliveryDate of the shipment.
	 * @return the shipment with the updated deliveryDate.
	 */
	public Shipment setDeliveryDate(String deliveryDate) { 
		this.deliveryDate = deliveryDate; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the earnings of the shipment. </p>
	 * @return the earnings of the shipment.
	 */
	public Integer getEarnings() { 
		return earnings; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the earnings of the shipment. </p>
	 * @param earnings : earnings of the shipment.
	 * @return the shipment with the updated earnings.
	 */
	public Shipment setEarnings(Integer earnings) { 
		this.earnings = earnings; 
		return this;
	}

	// utilities

	@Override
	public String toString() {
		return "Shipment [shipmentCode=" + shipmentCode + 
						  ", destination=" + destination + 
						  ", withdrawalDate=" + withdrawalDate + 
						  ", deliveryDate=" + deliveryDate + 
						  ", earnings=" + earnings + "]";
	}

}