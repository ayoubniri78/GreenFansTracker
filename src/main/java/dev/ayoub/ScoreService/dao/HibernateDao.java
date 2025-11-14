package dev.ayoub.ScoreService.dao;

import org.hibernate.Session;
import dev.ayoub.ScoreService.model.Ranking;
import dev.ayoub.ScoreService.model.Score;
import dev.ayoub.util.HibernateUtil;
import java.util.List;

public class HibernateDao implements ScoreDao {

    @Override
    public Score findBySupporterId(int supId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String req = "FROM Score WHERE supporterId = :supId";
            return session.createQuery(req, Score.class)
                    .setParameter("supId", supId)
                    .uniqueResult();
        } catch (Exception e) {
            System.out.println("Erreur dans findBySupporterId : " + e.getMessage());
            return null;
        }
    }

    @Override
    public void saveOrUpdate(Score score) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            session.beginTransaction();
            
            Score existing = findBySupporterId(score.getSupporterId());
            
            if (existing != null) {
                existing.setTotalScore(score.getTotalScore());
                existing.setLastUpdate(score.getLastUpdate());
                existing.setRank(score.getRank());
                session.merge(existing);
                System.out.println("🔄 Score UPDATÉ - Supporter " + score.getSupporterId());
            } else {
                session.persist(score);
                System.out.println("✅ Score CRÉÉ - Supporter " + score.getSupporterId());
            }
            
            session.getTransaction().commit();
            
        } catch (Exception e) {
            System.out.println("❌ ERREUR CRITIQUE saveOrUpdate: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void updateScore(Score s) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            session.beginTransaction();
            
            String req = "UPDATE Score SET totalScore = :newScore, lastUpdate = CURRENT_TIMESTAMP WHERE supporterId = :supId";
            session.createQuery(req)
                    .setParameter("newScore", s.getTotalScore()) // Corrigé: totalScore au lieu de totalPoints
                    .setParameter("supId", s.getSupporterId())
                    .executeUpdate();
                    
            session.getTransaction().commit();
        } catch (Exception e) {
            System.out.println("Erreur dans updateScore : " + e.getMessage());
        }
    }

    @Override
    public int getRanking(int supId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Calcul du rang en temps réel basé sur les scores
            String req = "SELECT COUNT(s) + 1 FROM Score s WHERE s.totalScore > " +
                        "(SELECT s2.totalScore FROM Score s2 WHERE s2.supporterId = :supId)";
            Long rank = session.createQuery(req, Long.class)
                    .setParameter("supId", supId)
                    .uniqueResult();
            return rank != null ? rank.intValue() : 0;
        } catch (Exception e) {
            System.out.println("Erreur dans getRanking : " + e.getMessage());
            return 0;
        }
    }

    @Override
    public List<Score> findAllScores() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String req = "FROM Score ORDER BY totalScore DESC";
            return session.createQuery(req, Score.class).getResultList();
        } catch (Exception e) {
            System.out.println("Erreur dans findAllScores : " + e.getMessage());
            return List.of();
        }
    }

    @Override
    public List<Score> findTopScores(int limit) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String req = "FROM Score ORDER BY totalScore DESC";
            return session.createQuery(req, Score.class)
                    .setMaxResults(limit)
                    .getResultList();
        } catch (Exception e) {
            System.out.println("Erreur dans findTopScores : " + e.getMessage());
            return List.of();
        }
    }

    @Override
    public void deleteBySupporterId(int supId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            session.beginTransaction();
            
            String req = "DELETE FROM Score WHERE supporterId = :supId";
            session.createQuery(req)
                    .setParameter("supId", supId)
                    .executeUpdate();
                    
            session.getTransaction().commit();
        } catch (Exception e) {
            System.out.println("Erreur dans deleteBySupporterId : " + e.getMessage());
        }
    }
}