package dev.ayoub.ActionService.dao;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.Transaction;
import dev.ayoub.util.HibernateUtil;
import dev.ayoub.ActionService.model.ActionType;
import jakarta.persistence.TypedQuery;

public class ActionTypeDaoImpl implements ActionTypeDao {

	@Override
	public List<ActionType> findAll() {
	    System.out.println("=== DEBUT ActionTypeDaoImpl.findAll ===");
	    try (Session session = HibernateUtil.getSessionFactory().openSession()) {
	        System.out.println("Session créée: " + (session != null ? "OK" : "NULL"));
	        
	        TypedQuery<ActionType> query = session.createQuery("FROM ActionType", ActionType.class);
	        List<ActionType> result = query.getResultList();
	        
	        System.out.println("Requête exécutée, résultat: " + result);
	        System.out.println("Nombre d'éléments: " + result.size());
	        
	        return result;
	    } catch (Exception e) {
	        System.err.println("ERREUR dans ActionTypeDaoImpl.findAll: " + e.getMessage());
	        e.printStackTrace();
	        return List.of();
	    } finally {
	        System.out.println("=== FIN ActionTypeDaoImpl.findAll ===");
	    }
	}

    @Override
    public ActionType findByName(String name) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            TypedQuery<ActionType> query = session.createQuery("FROM ActionType WHERE name = :name", ActionType.class);
            query.setParameter("name", name);
            return query.getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public ActionType findById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(ActionType.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}