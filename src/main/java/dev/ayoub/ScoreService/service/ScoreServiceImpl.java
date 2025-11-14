package dev.ayoub.ScoreService.service;

import dev.ayoub.ScoreService.dao.ScoreDao;
import dev.ayoub.ScoreService.dao.HibernateDao;
import dev.ayoub.ScoreService.model.Score;
import dev.ayoub.ScoreService.model.Ranking;
import dev.ayoub.ActionService.model.Action;
import dev.ayoub.ActionService.model.STATUS;
import dev.ayoub.ActionService.service.ActionService;
import dev.ayoub.ActionService.service.ActionServiceImpl;
import dev.ayoub.SupporterService.dao.SupporterDao;
import dev.ayoub.SupporterService.dao.SupporterDaoImpl;
import dev.ayoub.SupporterService.model.Supporter;
import dev.ayoub.util.HibernateUtil;

import java.util.*;

import org.hibernate.Session;

public class ScoreServiceImpl implements ScoreService {

	private ScoreDao scoreDao;
	private ActionService actionService;
	private SupporterDao supporterDao;

	public ScoreServiceImpl() {
		this.scoreDao = new HibernateDao();
		this.actionService = new ActionServiceImpl();
		this.supporterDao = new SupporterDaoImpl();
	}

	@Override
	public Score calculateScore(int supporterId) {
		try {
			System.out.println("🎯 Calcul du score pour supporter: " + supporterId);
			List<Action> actions = actionService.getUserActions1(supporterId);

			int totalScore = 0;
			int validatedActions = 0;

			for (Action action : actions) {
				if (action.getStatus() == STATUS.VALIDATED) {
					totalScore += action.getPoints();
					validatedActions++;
				}
			}

			System.out.println("📊 Supporter " + supporterId + ": " + validatedActions + " actions validées, "
					+ totalScore + " points");

			java.sql.Date now = new java.sql.Date(System.currentTimeMillis());

			Score existingScore = scoreDao.findBySupporterId(supporterId);
			if (existingScore != null) {
				existingScore.setTotalScore(totalScore);
				existingScore.setLastUpdate(now);
				scoreDao.updateScore(existingScore);
				return existingScore;
			} else {
				Score newScore = new Score(supporterId, totalScore);
				newScore.setLastUpdate(now);
				scoreDao.saveOrUpdate(newScore);
				return newScore;
			}

		} catch (Exception e) {
			System.out.println("❌ Erreur calculateScore: " + e.getMessage());
			return new Score(supporterId, 0);
		}
	}

	@Override
	public List<Ranking> getRanking() {
		try {
			System.out.println("🏆 Génération du classement...");
			List<Score> scores = scoreDao.findAllScores();
			System.out.println("📈 " + scores.size() + " scores trouvés dans la base");

			if (scores.isEmpty()) {
				System.out.println("ℹ️ Aucun score trouvé, le classement sera vide");
				return new ArrayList<>();
			}

			Collections.sort(scores, (s1, s2) -> Integer.compare(s2.getTotalScore(), s1.getTotalScore()));

			List<Ranking> rankings = new ArrayList<>();
			for (int i = 0; i < scores.size(); i++) {
				Score score = scores.get(i);
				String username = getSupporterUsername(score.getSupporterId());

				System.out.println("🥇 Position " + (i + 1) + ": Supporter " + score.getSupporterId() + " - "
						+ score.getTotalScore() + " points");

				Ranking ranking = new Ranking(score.getSupporterId(), i + 1, score.getTotalScore(), username);
				rankings.add(ranking);
			}

			System.out.println("✅ Classement généré: " + rankings.size() + " participants");
			return rankings;

		} catch (Exception e) {
			System.out.println("❌ Erreur getRanking: " + e.getMessage());
			e.printStackTrace();
			return new ArrayList<>();
		}
	}

	@Override
	public int getSupporterRank(int supporterId) {
		try {
			int rank = scoreDao.getRanking(supporterId);
			System.out.println("🔍 Rang du supporter " + supporterId + ": " + rank);
			return rank;
		} catch (Exception e) {
			System.out.println("❌ Erreur getSupporterRank: " + e.getMessage());
			return 0;
		}
	}

	@Override
	public void generateScoresFromValidatedActions() {
		try {
			System.out.println("🚀 DÉBUT - Génération des scores...");

			List<Action> validatedActions = getAllValidatedActions();
			System.out.println("📋 " + validatedActions.size() + " actions validées trouvées");

			if (validatedActions.isEmpty()) {
				System.out.println("❌ AUCUNE action validée - Vérifiez vos actions");
				return;
			}

			Map<Integer, Integer> scoresMap = new HashMap<>();
			for (Action action : validatedActions) {
				int supporterId = action.getSupporterId();
				scoresMap.put(supporterId, scoresMap.getOrDefault(supporterId, 0) + action.getPoints());
			}

			java.sql.Date now = new java.sql.Date(System.currentTimeMillis());
			for (Map.Entry<Integer, Integer> entry : scoresMap.entrySet()) {
				int supporterId = entry.getKey();
				int totalScore = entry.getValue();

				Score score = new Score(supporterId, totalScore);
				score.setLastUpdate(now);

				scoreDao.saveOrUpdate(score);
				System.out.println("🎯 Supporter " + supporterId + " = " + totalScore + " points");
			}

			System.out.println("🎉 SUCCÈS - " + scoresMap.size() + " scores générés !");

		} catch (Exception e) {
			System.out.println("💥 ERREUR GRAVE: " + e.getMessage());
			e.printStackTrace();
		}
	}

	private List<Action> getAllValidatedActions() {
		try (Session session = HibernateUtil.getSessionFactory().openSession()) {
			String hql = "FROM Action WHERE status = 'VALIDATED'";
			return session.createQuery(hql, Action.class).list();
		} catch (Exception e) {
			System.out.println("❌ Erreur récupération actions: " + e.getMessage());
			return new ArrayList<>();
		}
	}

//	private List<Action> getAllActions() {
//		try {
//			
//			return actionService.getUserActions1(0); 
//		} catch (Exception e) {
//			System.out.println("❌ Erreur récupération actions: " + e.getMessage());
//			return new ArrayList<>();
//		}
//	}

	private String getSupporterUsername(int supporterId) {
		return "Supporter_" + supporterId;
	}
}