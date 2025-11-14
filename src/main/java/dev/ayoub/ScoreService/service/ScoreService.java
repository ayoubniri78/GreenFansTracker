package dev.ayoub.ScoreService.service;

import dev.ayoub.ScoreService.model.Score;
import dev.ayoub.ScoreService.model.Ranking;
import java.util.List;

public interface ScoreService {
    Score calculateScore(int supporterId);
    List<Ranking> getRanking();
    int getSupporterRank(int supporterId);
    void generateScoresFromValidatedActions();
}