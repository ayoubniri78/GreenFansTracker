package dev.ayoub.ScoreService.dao;


import org.hibernate.Session;

import dev.ayoub.ScoreService.model.Ranking;
import dev.ayoub.ScoreService.model.Score;
import dev.ayoub.util.HibernateUtil;
import jakarta.transaction.Transaction;

public class HibernateDao implements ScoreDao{

	@Override
	public Score findBySupporterId(int supId) {
		try(Session session = HibernateUtil.getSessionFactory().openSession()){
			String req = "FROM Score WHERE supporterId = :supId";
			return  session.createQuery(req, Score.class)
					.setParameter("supId",supId)
					.uniqueResult();
			
		}
		catch(Exception e) {
			System.out.println("Erreur dans findBySupporterId : "+e);
			return null;
		}
	}

	@Override
	public void updateScore(Score s) {
		
		try(Session session = HibernateUtil.getSessionFactory().openSession()){
			 session.beginTransaction();
		        
		        String req = "UPDATE Score SET score = :newScore WHERE id = :id";
		        session.createQuery(req)
		                .setParameter("newScore", s.getTotalPoints())
		                .setParameter("id", s.getId())
		                .executeUpdate();
		                
		        session.getTransaction().commit();
			
		}catch(Exception e) {
	        System.out.println("Erreur dans update score "+e);
	    }
	}

	@Override
	public int getRanking(int supId) {
		try (Session s = HibernateUtil.getSessionFactory().openSession()){
			String req = "FROM Ranking WHERE supporterId = :supId";
			Ranking r = s.createQuery(req, Ranking.class)
					.setParameter("supId",supId)
					.uniqueResult();
			return r != null ? r.getRank() : 0;
		} catch (Exception e) {
			System.out.println("Erreur dans getRanking "+e);
			return 0;
		}
	}

}
