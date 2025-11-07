package dev.ayoub.ScoreService.dao;

import dev.ayoub.ScoreService.model.Score;

public interface ScoreDao {
	Score findBySupporterId(int supId);
	void updateScore(Score s);
	int getRanking(int supId);
}
