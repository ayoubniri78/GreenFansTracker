package dev.ayoub.ActionService.dao;

import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;
import org.hibernate.Session;

import dev.ayoub.ActionService.model.Action;
import dev.ayoub.ActionService.model.STATUS;
import dev.ayoub.ActionService.util.ValideAction;
import dev.ayoub.util.HibernateUtil;

public class ActionDaoImpl implements ActionDao {

	@Override
	public void saveAction(Action action) {
		try (Session s = HibernateUtil.getSessionFactory().openSession()) {
			if (ValideAction.estActionValide(action)) {
				s.beginTransaction();
				s.save(action);
				s.getTransaction().commit();
				System.out.println("Action sauvgarder " + action.getId());
			}
			else {
				System.out.println("Action non enregistrer");
			}

		} catch (Exception e) {
			System.out.println("Erreur dans SaveAction "+e.getMessage());
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

            // Récupère l'action existante
            Action existing = s.get(Action.class, action.getId());
            if (existing == null) {
                System.out.println("Action non trouvée pour update : ID " + action.getId());
                s.getTransaction().rollback();
                return;
            }

            // Met à jour les champs nécessaires
            existing.setStatus(action.getStatus());

            // Met à jour les votes
            Map<String, Integer> newVotes = action.getVotes();
            if (newVotes != null) {
                existing.getVotes().clear(); // Vide les anciens
                existing.getVotes().putAll(newVotes); // Ajoute les nouveaux
            }

            s.merge(existing);
            s.getTransaction().commit();
            System.out.println("Action mise à jour avec succès : ID " + action.getId());
        } catch (Exception e) {
            System.out.println("Erreur dans updateAction : " + e.getMessage());
            e.printStackTrace();
        }
    }

}
