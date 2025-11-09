package dev.ayoub.ActionService.service;

import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

	@Override
	public boolean voteOnAction(int actionId, int suppId, String voteType) {
		Action a = dao.findActionById(actionId);
		if (a == null) {
			return false;
		}

		if (!"valid".equals(voteType) && !"nonValid".equals(voteType)) {
			return false;
		}

		Map<String, Integer> votes = a.getVotes();
		if (votes == null) {
			votes = new HashMap<>();
			a.setVotes(votes);
		}
		votes.put(voteType, votes.getOrDefault(voteType, 0) + 1);
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

		Map<String, Integer> votes = a.getVotes();
		if (votes == null) {
			return false;
		}

		int valid = votes.getOrDefault("valid", 0);
		int nonValid = votes.getOrDefault("nonValid", 0);

		if (valid >= 10 && nonValid <= 2) {
			a.setStatus(STATUS.VALIDATED);
			dao.updateAction(a);
			return true;
		}

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

}