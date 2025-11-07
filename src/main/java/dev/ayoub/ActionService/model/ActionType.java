package dev.ayoub.ActionService.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name="ActionType")
@Data
@NoArgsConstructor

public class ActionType {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(name="name",nullable = false)
	private String name;
	
	@Column(name="defaultPoints",nullable = false)
	private int defaultPoints;

	public ActionType(String name, int defaultPoints) {
		super();
		this.name = name;
		this.defaultPoints = defaultPoints;
	}
	

}
