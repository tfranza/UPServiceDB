package com.franza.UP.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedStoredProcedureQueries;
import javax.persistence.NamedStoredProcedureQuery;
import javax.persistence.ParameterMode;
import javax.persistence.StoredProcedureParameter;

import com.franza.UP.to.WeeklyReportTO;
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
		name = "createWeeklyReport",
		procedureName = "createWeeklyReport",
		resultClasses = { WeeklyReport.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "id"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "stamp"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "averageDays"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "nShipments"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "earnings"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "vehicleMaintenance"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "total"),
		}
	),
	@NamedStoredProcedureQuery(
		name = "readWeeklyReport",
		procedureName = "readWeeklyReport",
		resultClasses = { WeeklyReport.class },
		parameters = {
		}
	),
	@NamedStoredProcedureQuery(
		name = "updateWeeklyReport",
		procedureName = "updateWeeklyReport",
		resultClasses = { WeeklyReport.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "id"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = String.class, name = "stamp"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "averageDays"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "nShipments"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "earnings"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "vehicleMaintenance"),
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "total"),
		}
	),
	@NamedStoredProcedureQuery(
		name = "deleteWeeklyReport",
		procedureName = "deleteWeeklyReport",
		resultClasses = { WeeklyReport.class },
		parameters = {
			@StoredProcedureParameter (mode = ParameterMode.IN, type = Integer.class, name = "id"),
		}
	),
	@NamedStoredProcedureQuery(
			name = "produceWeeklyReport",
			procedureName = "produceWeeklyReport",
			resultClasses = { WeeklyReport.class },
			parameters = {
			}
		)
})
public class WeeklyReport extends com.franza.UP.model.Entity implements Serializable{

	@Id 

	/**
	 * <p> Private field to store the id of the weeklyReport. </p>  
	 */
	@Column (name="ID")
	private Integer id = -1;

	/**
	 * <p> Private field to store the stamp of the weeklyReport. </p>  
	 */
	@Column (name="STAMP")
	private String stamp = "";

	/**
	 * <p> Private field to store the averageDays of the weeklyReport. </p>  
	 */
	@Column (name="AVERAGEDAYS")
	private Double averageDays = -1.0;

	/**
	 * <p> Private field to store the nShipments of the weeklyReport. </p>  
	 */
	@Column (name="NSHIPMENTS")
	private Integer nShipments = -1;

	/**
	 * <p> Private field to store the earnings of the weeklyReport. </p>  
	 */
	@Column (name="EARNINGS")
	private Integer earnings = -1;

	/**
	 * <p> Private field to store the vehicleMaintenance of the weeklyReport. </p>  
	 */
	@Column (name="VEHICLEMAINTENANCE")
	private Integer vehicleMaintenance = -1;

	/**
	 * <p> Private field to store the total of the weeklyReport. </p>  
	 */
	@Column (name="TOTAL")
	private Integer total = -1;

	// builders
	/**
	 * <p> Public method that initializes the weeklyReport fields with the values given in input. </p>
	 * @param id : integer that stores the id to be copied into the weeklyReport entity bean.
	 * @param stamp : string that stores the stamp to be copied into the weeklyReport entity bean.
	 * @param averageDays : integer that stores the averageDays to be copied into the weeklyReport entity bean.
	 * @param nShipments : integer that stores the nShipments to be copied into the weeklyReport entity bean.
	 * @param earnings : integer that stores the earnings to be copied into the weeklyReport entity bean.
	 * @param vehicleMaintenance : integer that stores the vehicleMaintenance to be copied into the weeklyReport entity bean.
	 * @param total : integer that stores the total to be copied into the weeklyReport entity bean.
	 * @return the updated weeklyReport entity bean.
	 */
	public WeeklyReport getFromData(String id, String stamp, String averageDays, String nShipments, String earnings, String vehicleMaintenance, String total) {
		return setId(Integer.parseInt(id))
			  .setStamp(stamp)
			  .setAverageDays(Double.parseDouble(averageDays))
			  .setNShipments(Integer.parseInt(nShipments))
			  .setEarnings(Integer.parseInt(earnings))
			  .setVehicleMaintenance(Integer.parseInt(vehicleMaintenance))
			  .setTotal(Integer.parseInt(total));
	}

	/**
	 * <p> Public method that initializes the weeklyReport fields with the values of the transfer object given in input. </p>
	 * @param to : transfer object that stores the values to be copied into the weeklyReport entity bean.
	 * @return the updated weeklyReport entity bean.
	 */
	public WeeklyReport getFromTO(TO to) {
		return setId( ((WeeklyReportTO) to) .getId())
			  .setStamp( ((WeeklyReportTO) to) .getStamp())
			  .setAverageDays( ((WeeklyReportTO) to) .getAverageDays())
			  .setNShipments( ((WeeklyReportTO) to) .getNShipments())
			  .setEarnings( ((WeeklyReportTO) to) .getEarnings())
			  .setVehicleMaintenance( ((WeeklyReportTO) to) .getVehicleMaintenance())
			  .setTotal( ((WeeklyReportTO) to) .getTotal());
	}

	// getters and setters

	/**
	 * <p> Getter method for the instantiated entity bean to get the id of the weeklyReport. </p>
	 * @return the id of the weeklyReport.
	 */
	public Integer getId() { 
		return id; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the id of the weeklyReport. </p>
	 * @param id : id of the weeklyReport.
	 * @return the weeklyReport with the updated id.
	 */
	public WeeklyReport setId(Integer id) { 
		this.id = id; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the stamp of the weeklyReport. </p>
	 * @return the stamp of the weeklyReport.
	 */
	public String getStamp() { 
		return stamp; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the stamp of the weeklyReport. </p>
	 * @param stamp : stamp of the weeklyReport.
	 * @return the weeklyReport with the updated stamp.
	 */
	public WeeklyReport setStamp(String stamp) { 
		this.stamp = stamp; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the averageDays of the weeklyReport. </p>
	 * @return the averageDays of the weeklyReport.
	 */
	public Double getAverageDays() { 
		return averageDays; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the averageDays of the weeklyReport. </p>
	 * @param averageDays : averageDays of the weeklyReport.
	 * @return the weeklyReport with the updated averageDays.
	 */
	public WeeklyReport setAverageDays(Double averageDays) { 
		this.averageDays = averageDays; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the nShipments of the weeklyReport. </p>
	 * @return the nShipments of the weeklyReport.
	 */
	public Integer getNShipments() { 
		return nShipments; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the nShipments of the weeklyReport. </p>
	 * @param nShipments : nShipments of the weeklyReport.
	 * @return the weeklyReport with the updated nShipments.
	 */
	public WeeklyReport setNShipments(Integer nShipments) { 
		this.nShipments = nShipments; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the earnings of the weeklyReport. </p>
	 * @return the earnings of the weeklyReport.
	 */
	public Integer getEarnings() { 
		return earnings; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the earnings of the weeklyReport. </p>
	 * @param earnings : earnings of the weeklyReport.
	 * @return the weeklyReport with the updated earnings.
	 */
	public WeeklyReport setEarnings(Integer earnings) { 
		this.earnings = earnings; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the vehicleMaintenance of the weeklyReport. </p>
	 * @return the vehicleMaintenance of the weeklyReport.
	 */
	public Integer getVehicleMaintenance() { 
		return vehicleMaintenance; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the vehicleMaintenance of the weeklyReport. </p>
	 * @param vehicleMaintenance : vehicleMaintenance of the weeklyReport.
	 * @return the weeklyReport with the updated vehicleMaintenance.
	 */
	public WeeklyReport setVehicleMaintenance(Integer vehicleMaintenance) { 
		this.vehicleMaintenance = vehicleMaintenance; 
		return this;
	}

	/**
	 * <p> Getter method for the instantiated entity bean to get the total of the weeklyReport. </p>
	 * @return the total of the weeklyReport.
	 */
	public Integer getTotal() { 
		return total; 
	}
	
	/**
	 * <p> Setter method for the instantiated entity bean to set the total of the weeklyReport. </p>
	 * @param total : total of the weeklyReport.
	 * @return the weeklyReport with the updated total.
	 */
	public WeeklyReport setTotal(Integer total) { 
		this.total = total; 
		return this;
	}

	// utilities

	@Override
	public String toString() {
		return "WeeklyReport [id=" + id + 
						  ", stamp=" + stamp + 
						  ", averageDays=" + averageDays + 
						  ", nShipments=" + nShipments + 
						  ", earnings=" + earnings + 
						  ", vehicleMaintenance=" + vehicleMaintenance + 
						  ", total=" + total + "]";
	}

}