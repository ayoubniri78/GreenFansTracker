package dev.ayoub.ActionService.service;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Session;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.io.IOException;

import dev.ayoub.ActionService.dao.ActionDao;
import dev.ayoub.ActionService.dao.ActionDaoImpl;
import dev.ayoub.ActionService.dao.ActionTypeDao;
import dev.ayoub.ActionService.dao.ActionTypeDaoImpl;
import dev.ayoub.ActionService.model.Action;
import dev.ayoub.ActionService.model.ActionType;
import dev.ayoub.ActionService.model.STATUS;
import dev.ayoub.util.HibernateUtil;

public class ActionServiceImpl implements ActionService {

	ActionDao dao = new ActionDaoImpl();
	ActionTypeDao actionTypeDao = new ActionTypeDaoImpl();

	private static final String UPLOAD_BASE_DIR = "/home/ayoub/GreenFansTracker/uploads";

	@Override
	public Action submitAction(int suppId, String type, String detail, int points, InputStream fileStream,
			String fileName, String fileType) {

		try {
			Path uploadPath = Paths.get(UPLOAD_BASE_DIR);
			Files.createDirectories(uploadPath);

			String fileExtension = getFileExtension(fileName);
			String uniqueFileName = suppId + "_" + System.currentTimeMillis() + fileExtension;

			Path filePath = uploadPath.resolve(uniqueFileName);

			Files.copy(fileStream, filePath, StandardCopyOption.REPLACE_EXISTING);

			String filePathInDb = filePath.toString();

			Action action = new Action(suppId, type, detail, points, fileName, fileType, filePathInDb);
			action.setStatus(STATUS.PENDING);

			dao.saveAction(action);

			System.out.println("=== FICHIER SAUVEGARDÉ AVEC SUCCÈS ===");
			System.out.println("Type d'action: " + type);
			System.out.println("Points: " + points);
			System.out.println("Chemin: " + filePath);

			return action;

		} catch (IOException e) {
			System.err.println("ERREUR lors de la sauvegarde du fichier: " + e.getMessage());
			e.printStackTrace();
			return null;
		}
	}

	private String getFileExtension(String fileName) {
		if (fileName == null) {
			return "";
		}
		int lastDotIndex = fileName.lastIndexOf(".");
		if (lastDotIndex > 0) {
			return fileName.substring(lastDotIndex);
		}
		return "";
	}

//	@Override
//	public boolean voteOnAction(int actionId, int suppId, String voteType) {
//		Action a = dao.findActionById(actionId);
//		if (a == null) {
//			return false;
//		}
//
//		if (!"valid".equals(voteType) && !"nonValid".equals(voteType)) {
//			return false;
//		}
//
//		Map<String, Integer> votes = a.getVotes();
//		if (votes == null) {
//			votes = new HashMap<>();
//			a.setVotes(votes);
//		}
//		votes.put(voteType, votes.getOrDefault(voteType, 0) + 1);
//		dao.updateAction(a);
//
//		checkValidation(actionId);
//		return true;
//	}
	
	@Override
	public boolean voteOnAction(int actionId, int suppId, String voteType) {
	    Action a = dao.findActionById(actionId);
	    if (a == null) {
	        System.out.println("❌ Action non trouvée: " + actionId);
	        return false;
	    }

	    if (!"valid".equals(voteType) && !"nonValid".equals(voteType)) {
	        System.out.println("❌ Type de vote invalide: " + voteType);
	        return false;
	    }

	    Map<Integer, String> votes = a.getVotes(); 
	    if (votes == null) {
	        votes = new HashMap<>();
	        a.setVotes(votes);
	    }
	    
	    if (votes.containsKey(suppId)) {
	        System.out.println("❌ L'utilisateur " + suppId + " a déjà voté pour l'action " + actionId);
	        return false;
	    }
	    
	    votes.put(suppId, voteType);
	    
	    System.out.println("✅ Vote enregistré - Action: " + actionId + 
	                      ", User: " + suppId + 
	                      ", Type: " + voteType);
	    
	    dao.updateAction(a);
	    checkValidation(actionId);
	    return true;
	}

	@Override
	public boolean checkValidation(int actionId) {
	    Action a = dao.findActionById(actionId);
	    if (a == null || a.getStatus() != STATUS.PENDING) {
	        return false;
	    }

	    Map<Integer, String> votes = a.getVotes();
	    if (votes == null) {
	        return false;
	    }

	    int valid = 0;
	    int nonValid = 0;
	    
	    for (String voteType : votes.values()) {
	        if ("valid".equals(voteType)) {
	            valid++;
	        } else if ("nonValid".equals(voteType)) {
	            nonValid++;
	        }
	    }

	    System.out.println(" Validation - Action: " + actionId + 
	                      " | Valid: " + valid + " | NonValid: " + nonValid);

	    if (valid >= 10 && nonValid <= 2) {
	        a.setStatus(STATUS.VALIDATED);
	        dao.updateAction(a);
	        System.out.println(" ACTION VALIDÉE - ID: " + actionId);
	        return true;
	    }

	    if (nonValid >= 2) {
	        a.setStatus(STATUS.REJECTED);
	        dao.updateAction(a);
	        System.out.println("🚫 ACTION REJETÉE - ID: " + actionId);
	        return true;
	    }

	    System.out.println("⏳ En attente - Valid: " + valid + "/10, NonValid: " + nonValid + "/5");
	    return false;
	}

	@Override
	public List<Action> getPendingAction() {
		return dao.findPendingAction();
	}

	public List<ActionType> getAllActionTypes() {
	    System.out.println("=== DEBUT getAllActionTypes ===");
	    try {
	        List<ActionType> result = actionTypeDao.findAll();
	        System.out.println("Résultat DAO: " + result);
	        System.out.println("Taille résultat: " + (result != null ? result.size() : "null"));
	        return result;
	    } catch (Exception e) {
	        System.err.println("ERREUR dans getAllActionTypes: " + e.getMessage());
	        e.printStackTrace();
	        return null;
	    } finally {
	        System.out.println("=== FIN getAllActionTypes ===");
	    }
	}

	public ActionType getActionTypeByName(String name) {
		return actionTypeDao.findByName(name);
	}

	public int getDefaultPointsForActionType(String actionTypeName) {
		ActionType actionType = actionTypeDao.findByName(actionTypeName);
		if (actionType != null) {
			return actionType.getDefaultPoints();
		}
		return 0; // Valeur par défaut si le type n'est pas trouvé
	}
	
	public List<Action> getUserActions(int supporterId) {
	    return dao.findActionsBySupporter(supporterId);
	}

	public List<Action> getCommunityActions() {
	    return dao.findRecentValidatedActions();
	}
	@Override
	public String getMediaPathByActionId(int actionId) {
	    Action action = dao.findActionById(actionId);
	    return action != null ? action.getMediaFilePath() : null;
	}

	@Override
	public List<Action> getAllActionsWithMedia() {
	    try (var s = HibernateUtil.getSessionFactory().openSession()) {
	        List<Action> list = s.createQuery("FROM Action", Action.class).list();
	        System.out.println("ACTIONS TROUVÉES : " + list.size());
	        list.forEach(a -> System.out.println("ID=" + a.getId() + " | FICHIER=" + a.getMediaFilePath()));
	        return list;
	    }
	}
	public Action getActionById(int actionId) {
	    return dao.findActionById(actionId);
	}
	@Override
	public Map<String, Integer> getActionVotes(int actionId) {
	    try (var session = HibernateUtil.getSessionFactory().openSession()) {
	        String hql = "SELECT a FROM Action a LEFT JOIN FETCH a.votes WHERE a.id = :actionId";
	        Action action = session.createQuery(hql, Action.class)
	                .setParameter("actionId", actionId)
	                .uniqueResult();
	        
	        if (action == null) return null;
	        
	        Map<Integer, String> votes = action.getVotes(); // ← Changez ici
	        Map<String, Integer> result = new HashMap<>();
	        result.put("valid", 0);
	        result.put("nonValid", 0);
	        
	        // Compter les votes par type
	        if (votes != null) {
	            for (String voteType : votes.values()) {
	                if ("valid".equals(voteType)) {
	                    result.put("valid", result.get("valid") + 1);
	                } else if ("nonValid".equals(voteType)) {
	                    result.put("nonValid", result.get("nonValid") + 1);
	                }
	            }
	        }
	        
	        System.out.println("📊 Votes récupérés: " + result);
	        return result;
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        Map<String, Integer> defaultVotes = new HashMap<>();
	        defaultVotes.put("valid", 0);
	        defaultVotes.put("nonValid", 0);
	        return defaultVotes;
	    }
	}
	@Override
	public List<Action> getUserActions1(int supporterId) {
	    System.out.println("=== DEBUT getUserActions ===");
	    System.out.println("🔍 Recherche des actions pour supporterId: " + supporterId);
	    
	    try (Session session = HibernateUtil.getSessionFactory().openSession()) {
	        // Requête HQL pour récupérer les actions avec leurs votes
	        String hql = "SELECT DISTINCT a FROM Action a LEFT JOIN FETCH a.votes WHERE a.supporterId = :supporterId ORDER BY a.submissionDate DESC";
	        
	        List<Action> actions = session.createQuery(hql, Action.class)
	                .setParameter("supporterId", supporterId)
	                .list();
	        
	        System.out.println("✅ Nombre d'actions trouvées: " + actions.size());
	        
	        for (Action action : actions) {
	            System.out.println("📋 Action ID: " + action.getId() + 
	                             " | Type: " + action.getType() + 
	                             " | Statut: " + action.getStatus() +
	                             " | Votes: " + (action.getVotes() != null ? action.getVotes().size() : 0));
	        }
	        
	        return actions;
	        
	    } catch (Exception e) {
	        System.err.println("❌ ERREUR dans getUserActions: " + e.getMessage());
	        e.printStackTrace();
	        return new ArrayList<>(); // Retourne une liste vide en cas d'erreur
	    } finally {
	        System.out.println("=== FIN getUserActions ===");
	    }
	}

}