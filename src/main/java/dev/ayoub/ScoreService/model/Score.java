package dev.ayoub.ScoreService.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.sql.Date;

@Entity
@Table(name = "Score")
@Data
@NoArgsConstructor
public class Score {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    private int supporterId;
    
    private int totalScore;  
    
    private Date lastUpdate;
    
    @Column(name = "`rank`")
    private int rank = 0;    

    public Score(int supporterId, int totalScore) {
        this.supporterId = supporterId;
        this.totalScore = totalScore;
        this.lastUpdate = new Date(System.currentTimeMillis());
        this.rank = 0;
    }
}