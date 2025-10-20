package dev.ayoub.SupporterService.dao;

import java.util.List;

import org.hibernate.Session;

import dev.ayoub.SupporterService.model.AuthToken;
import dev.ayoub.SupporterService.model.Supporter;
import dev.ayoub.util.HibernateUtil;

public class SupporterDaoImpl implements SupporterDao {

	@Override
	public Supporter findByEmail(String email) {
	    if (email == null || email.trim().isEmpty()) {
	        return null;
	    }
	    
	    try (Session session = HibernateUtil.getSessionFactory().openSession()) {
	        String hql = "FROM Supporter WHERE email = :email";
	        List<Supporter> results = session.createQuery(hql, Supporter.class)
	                                       .setParameter("email", email.trim())
	                                       .list();
	        
	        if (results.isEmpty()) {
	            return null;
	        } else if (results.size() == 1) {
	            return results.get(0); 
	        } else {
	            System.out.println("ALERTE: " + results.size() + " doublons pour email: " + email);
	            System.out.println("IDs trouvés: " + results.stream().map(Supporter::getId).toList());
	            return results.get(0);
	        }
	        
	    } catch (Exception e) {
	        System.out.println("Erreur findByEmail: " + e.getMessage());
	        return null;
	    }
	}

	@Override
	public void save(Supporter s) {
		 try (Session session = HibernateUtil.getSessionFactory().openSession()) {
		        session.beginTransaction();
		        session.persist(s); 
		        session.getTransaction().commit(); 
		        System.out.println(" Supporter sauvegardé: " + s.getEmail());
		    } catch (Exception e) {
		        System.out.println("Erreur sauvegarde: " + e.getMessage());
		        e.printStackTrace();
		    }
	}

	@Override
	public Supporter findByPhone(String phone) {
		
		return null;
	}

}
