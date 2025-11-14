package dev.ayoub.ScoreService.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "rankings")
@Data
@NoArgsConstructor
public class Ranking {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    private int supporterId;
    
    @Column(name = "ranking_position")
    private int position;
    
    private int score;
    
    private String username;
    
    public Ranking(int supporterId, int position, int score, String username) {
        this.supporterId = supporterId;
        this.position = position;
        this.score = score;
        this.username = username;
    }
}