package dev.ayoub.ActionService.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.File;
import java.io.InputStream;
import java.util.List;

import dev.ayoub.ActionService.model.Action;
import dev.ayoub.ActionService.model.ActionType;
import dev.ayoub.ActionService.service.ActionService;
import dev.ayoub.ActionService.service.ActionServiceImpl;
import dev.ayoub.ActionService.util.JwtUtil;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.*;

/**
 * Servlet implementation class ActionController
 */
@WebServlet("/ActionController")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10, // 10 MB
		maxRequestSize = 1024 * 1024 * 50, // 50 MB
		fileSizeThreshold = 1024 * 1024 // 1 MB
)
public class ActionController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	ActionServiceImpl actionService = new ActionServiceImpl();

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ActionController() {
		super();
	}

	@Override
	public void init() throws ServletException {
		// Créer le répertoire d'upload au démarrage
		String uploadDir = "/home/ayoub/GreenFansTracker/uploads";
		File dir = new File(uploadDir);
		if (!dir.exists()) {
			if (dir.mkdirs()) {
				System.out.println("Répertoire d'upload créé: " + uploadDir);
			} else {
				System.err.println("Échec de création du répertoire: " + uploadDir);
			}
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if ("showForm".equalsIgnoreCase(action)) {
			showActionForm(request, response);
		} else if ("getPendingAction".equalsIgnoreCase(action)) {
			getPendingAction(request, response);
		} else {
			response.getWriter().append("Served at: ").append(request.getContextPath());
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if ("submitAction".equalsIgnoreCase(action)) {
			sumbitAction(request, response);
		} else if ("voteOnAction".equalsIgnoreCase(action)) {
			voteOnAction(request, response);
		} else {
			response.getWriter().write("Option inconnu");
		}
	}

	void showActionForm(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    
	    System.out.println("=== DEBUT showActionForm ===");
	    
	    try {
	        // DEBUG: Vérifier si le service est accessible
	        System.out.println("ActionService instance: " + (actionService != null ? "OK" : "NULL"));
	        
	        // Utilisez directement actionService pour récupérer les types
	        List<ActionType> actionTypes = actionService.getAllActionTypes();
	        
	        // DEBUG: Afficher ce qui est récupéré
	        System.out.println("=== DEBUG ACTIONTYPES ===");
	        System.out.println("actionTypes: " + actionTypes);
	        if (actionTypes != null) {
	            System.out.println("Nombre de types: " + actionTypes.size());
	            for (ActionType type : actionTypes) {
	                System.out.println(" - " + type.getName() + " (" + type.getDefaultPoints() + " points)");
	            }
	        } else {
	            System.out.println("actionTypes est NULL - probablement une exception dans getAllActionTypes()");
	        }
	        
	        request.setAttribute("actionTypes", actionTypes);
	        
	    } catch (Exception e) {
	        System.err.println("ERREUR dans showActionForm: " + e.getMessage());
	        e.printStackTrace();
	        // Même en cas d'erreur, on passe une liste vide
	        request.setAttribute("actionTypes", List.of());
	    }
	    
	    System.out.println("=== FIN showActionForm ===");
	    request.getRequestDispatcher("/submit-action.jsp").forward(request, response);
	}

	void sumbitAction(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		int suppId = 22;

		System.out.println("=== SOUMISSION D'ACTION ===");

		String type = null;
		String detail = null;
		String pointsStr = null;
		Part filePart = null;

		try {
			// Lecture des parties multipart
			for (Part part : request.getParts()) {
				String name = part.getName();

				if ("type".equals(name)) {
					type = readPartValue(part);
					System.out.println("Type: " + type);
				} else if ("detail".equals(name)) {
					detail = readPartValue(part);
					System.out.println("Detail: " + detail);
				} else if ("points".equals(name)) {
					pointsStr = readPartValue(part);
					System.out.println("Points: " + pointsStr);
				} else if ("file".equals(name)) {
					filePart = part;
					System.out.println(
							"Fichier: " + getSubmittedFileName(filePart) + " (" + filePart.getSize() + " bytes)");
				}
			}
		} catch (Exception e) {
			System.err.println("Erreur lecture des données: " + e.getMessage());
			sendError(response, 500, "Erreur de lecture des données");
			return;
		}

		// Validation
		if (type == null || type.trim().isEmpty()) {
			sendError(response, 400, "Type manquant");
			return;
		}

		if (detail == null || detail.trim().isEmpty()) {
			sendError(response, 400, "Détails manquants");
			return;
		}

		if (pointsStr == null || pointsStr.trim().isEmpty()) {
			sendError(response, 400, "Points manquant");
			return;
		}

		int points;
		try {
			points = Integer.parseInt(pointsStr.trim());
			if (points <= 0) {
				sendError(response, 400, "Les points doivent être positifs");
				return;
			}
		} catch (NumberFormatException e) {
			sendError(response, 400, "Points invalides");
			return;
		}

		if (filePart == null || filePart.getSize() == 0) {
			sendError(response, 400, "Fichier requis");
			return;
		}

		String fileName = getSubmittedFileName(filePart);
		String fileType = filePart.getContentType();

		try {
			Action action = actionService.submitAction(suppId, type.trim(), detail.trim(), points,
					filePart.getInputStream(), fileName, fileType);

			if (action != null) {
				response.setContentType("application/json");
				response.getWriter().write("{\"success\": true, \"actionId\": " + action.getId() + "}");
				System.out.println("✅ Action créée avec ID: " + action.getId());
			} else {
				sendError(response, 500, "Erreur lors de la sauvegarde de l'action");
			}

		} catch (Exception e) {
			System.err.println("Erreur dans submitAction: " + e.getMessage());
			e.printStackTrace();
			sendError(response, 500, "Erreur interne du serveur");
		}
	}

	void voteOnAction(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String authHeader = request.getHeader("Authorization");
		if (authHeader == null || !authHeader.startsWith("Bearer ")) {
			sendError(response, 401, "Token manquant ou invalide");
			return;
		}
		String token = authHeader.substring(7);
		Claims claim = JwtUtil.validerJwtToken(token);
		if (claim == null) {
			sendError(response, 401, "Token invalide");
			return;
		}

		int suppId = Integer.parseInt(claim.getSubject());

		String actionIdStr = request.getParameter("actionId");
		String voteType = request.getParameter("vote");
		if (actionIdStr == null || voteType == null) {
			sendError(response, 400, "actionId ou vote manquant");
			return;
		}

		int actionId;
		try {
			actionId = Integer.parseInt(actionIdStr);
		} catch (NumberFormatException e) {
			sendError(response, 400, "actionId invalide");
			return;
		}

		if (!"valid".equals(voteType) && !"nonValid".equals(voteType)) {
			sendError(response, 400, "vote doit être 'valid' ou 'nonValid'");
			return;
		}

		boolean success = actionService.voteOnAction(actionId, suppId, voteType);

		if (success) {
			response.setContentType("application/json");
			response.getWriter().write("{\"success\": true, \"message\": \"Vote enregistré\"}");
		} else {
			sendError(response, 400, "Échec du vote (action introuvable ou déjà votée)");
		}
	}

	void getPendingAction(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<Action> ListePendingAction = actionService.getPendingAction();
		request.setAttribute("ListPenAction", ListePendingAction);
		request.getRequestDispatcher("/WEB-INF/views/pendingAction.jsp").forward(request, response);
	}

	// Méthode pour lire la valeur d'une partie textuelle
	private String readPartValue(Part part) throws IOException {
		InputStream inputStream = part.getInputStream();
		StringBuilder value = new StringBuilder();
		byte[] buffer = new byte[1024];
		int bytesRead;
		while ((bytesRead = inputStream.read(buffer)) != -1) {
			value.append(new String(buffer, 0, bytesRead, "UTF-8"));
		}
		inputStream.close();
		return value.toString().trim();
	}

	private String getSubmittedFileName(Part part) {
		String header = part.getHeader("content-disposition");
		for (String headerPart : header.split(";")) {
			if (headerPart.trim().startsWith("filename")) {
				return headerPart.substring(headerPart.indexOf('=') + 1).trim().replace("\"", "");
			}
		}
		return "unknown";
	}

	private void sendError(HttpServletResponse response, int status, String message) throws IOException {
		response.setStatus(status);
		response.setContentType("application/json");
		response.getWriter().write("{\"error\": \"" + message + "\"}");
	}

	// Ajout des méthodes pour ActionType dans l'interface (si nécessaire)
	public List<ActionType> getAllActionTypes() {
		return actionService.getAllActionTypes();
	}
}