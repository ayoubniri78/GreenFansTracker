package dev.ayoub.ActionService.dao;

import java.util.List;

import java.util.Map;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.Transaction;

import dev.ayoub.ActionService.model.Action;
import dev.ayoub.ActionService.model.STATUS;
import dev.ayoub.ActionService.util.ValideAction;
import dev.ayoub.util.HibernateUtil;

public class ActionDaoImpl implements ActionDao {

//	@Override
//	public void saveAction(Action action) {
//		try (Session s = HibernateUtil.getSessionFactory().openSession()) {
//			if (ValideAction.estActionValide(action)) {
//				s.beginTransaction();
//				s.save(action);
//				s.getTransaction().commit();
//				System.out.println("Action sauvgarder " + action.getId());
//			}
//			else {
//				System.out.println("Action non enregistrer");
//			}
//
//		} catch (Exception e) {
//			System.out.println("Erreur dans SaveAction "+e.getMessage());
//		}
//	}
	@Override
	public void saveAction(Action action) {
	    Session s = null;
	    Transaction tx = null;
	    try {
	        s = HibernateUtil.getSessionFactory().openSession();
	        tx = s.beginTransaction();

	        if (ValideAction.estActionValide(action)) {
	            s.save(action);
	            tx.commit();
	            System.out.println("Action sauvegardée : ID = " + action.getId());
	        } else {
	            tx.rollback(); // Annule la transaction
	            System.out.println("Action REJETÉE : validation échouée");
	        }

	    } catch (Exception e) {
	        if (tx != null) tx.rollback();
	        System.err.println("ERREUR SAVE : " + e.getMessage());
	        e.printStackTrace();
	    } finally {
	        if (s != null && s.isOpen()) s.close();
	    }
	}

	@Override
	public Action findActionById(int id) {
		try(Session s = HibernateUtil.getSessionFactory().openSession()) {
			if (id <= 0) {
		        System.out.println("ID invalide: " + id);
		        return null;
		    }
			String req = "FROM Action WHERE id = :id";
			Action a = s.createQuery(req, Action.class)
					.setParameter("id",id)
					.uniqueResult();
			return a;
		} catch (Exception e) {
			System.out.println("Erreur dans FindActionById "+e.getMessage());
			return null;
		}
	}

	@Override
	public List<Action> findPendingAction() {
		try (Session s = HibernateUtil.getSessionFactory().openSession()){
	        String hql = "FROM Action WHERE status = :status";
	        List<Action>ListeAction=s.createQuery(hql,Action.class)
	        		.setParameter("status",STATUS.PENDING)
	        		.list();
	        return ListeAction;
		} catch (Exception e) {
			System.out.println("Erreur dans findPendingAction "+e.getMessage());
			return null;
		}
	}

	@Override
    public void updateAction(Action action) {
        if (action == null || action.getId() <= 0) {
            System.out.println("Action invalide pour update");
            return;
        }

        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            s.beginTransaction();

            Action existing = s.get(Action.class, action.getId());
            if (existing == null) {
                System.out.println("Action non trouvée pour update : ID " + action.getId());
                s.getTransaction().rollback();
                return;
            }

            
            existing.setStatus(action.getStatus());

            
            Map<Integer, String> newVotes = action.getVotes();
            if (newVotes != null) {
                existing.getVotes().clear(); 
                existing.getVotes().putAll(newVotes); 
            }

            s.merge(existing);
            s.getTransaction().commit();
            System.out.println("Action mise à jour avec succès : ID " + action.getId());
        } catch (Exception e) {
            System.out.println("Erreur dans updateAction : " + e.getMessage());
            e.printStackTrace();
        }
    }
	@Override
	public List<Action> findActionsBySupporter(int supporterId) {
	    try (Session s = HibernateUtil.getSessionFactory().openSession()) {
	        String hql = "FROM Action WHERE supporterId = :supporterId ORDER BY submissionDate DESC";
	        List<Action> userActions = s.createQuery(hql, Action.class)
	                .setParameter("supporterId", supporterId)
	                .list();
	        System.out.println("Actions trouvées pour supporter " + supporterId + ": " + userActions.size());
	        return userActions;
	    } catch (Exception e) {
	        System.out.println("Erreur dans findActionsBySupporter: " + e.getMessage());
	        e.printStackTrace();
	        return List.of();
	    }
	}

	@Override
	public List<Action> findRecentValidatedActions() {
	    try (Session s = HibernateUtil.getSessionFactory().openSession()) {
	        String hql = "FROM Action WHERE status = :status ORDER BY submissionDate DESC";
	        List<Action> communityActions = s.createQuery(hql, Action.class)
	                .setParameter("status", STATUS.VALIDATED)
	                .setMaxResults(6) 
	                .list();
	        System.out.println("Actions communautaires trouvées: " + communityActions.size());
	        return communityActions;
	    } catch (Exception e) {
	        System.out.println("Erreur dans findRecentValidatedActions: " + e.getMessage());
	        e.printStackTrace();
	        return List.of();
	    }
	}
	// ActionDaoImpl.java
	@Override
	public List<Action> findAllWithMedia() {
	    try (Session s = HibernateUtil.getSessionFactory().openSession()) {
	        return s.createQuery("FROM Action WHERE mediaFilePath IS NOT NULL", Action.class).list();
	    }
	}

}
