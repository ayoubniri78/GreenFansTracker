package dev.ayoub.ScoreService.dao;

import dev.ayoub.ScoreService.model.Score;
import java.util.List;

public interface ScoreDao {
    Score findBySupporterId(int supId);
    void saveOrUpdate(Score score);
    void updateScore(Score s);
    int getRanking(int supId);
    List<Score> findAllScores();
    List<Score> findTopScores(int limit);
    void deleteBySupporterId(int supId);
}