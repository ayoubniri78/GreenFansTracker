package dev.ayoub.ScoreService.model;

import java.sql.Date;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.ToString;


@ToString
@Entity
@Table(name="Score")
@Data
@NoArgsConstructor

public class Score {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	
	private int supporterId;
	
	private int totalPoints;
	
	private Date lastUpdate;
	

	public Score(int supporterId, int totalPoints,Date lastUp) {
		this.supporterId = supporterId;
		this.totalPoints = totalPoints;
		this.lastUpdate=lastUp;
	}
	
	
}
