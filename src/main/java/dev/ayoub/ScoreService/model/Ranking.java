package dev.ayoub.ScoreService.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name="Ranking")
@Data
@Getter
@Setter
@ToString
@NoArgsConstructor

public class Ranking {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	private int supporterId;
	
	private int rank;
	
	public Ranking(int supId,int rank) {
		this.supporterId=supId;
		this.rank=rank;
	}

}
