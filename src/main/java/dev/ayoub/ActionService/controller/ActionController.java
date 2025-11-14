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
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import dev.ayoub.ActionService.model.Action;
import dev.ayoub.ActionService.model.ActionType;
import dev.ayoub.ActionService.model.STATUS;
import dev.ayoub.ActionService.service.ActionService;
import dev.ayoub.ActionService.service.ActionServiceImpl;
import dev.ayoub.ActionService.util.JwtUtil;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.*;

/**
 * Servlet implementation class ActionController
 */
@WebServlet("/ActionController")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50, fileSizeThreshold = 1024 * 1024)
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
	    System.out.println("📝 Action demandée: " + action);
	    
	    try {
	        switch (action) {
	            case "my-actions":
	                showMyActions(request, response);
	                break;
	            case "allMedia":
	                getAllMedia(request, response);
	                break;
	            case "showForm":
	                showActionForm(request, response);
	                break;
	            case "serveMedia":
	                serveMediaFile(request, response);
	                break;
	            case "getActionVotes":
	                getActionVotes(request, response);
	                break;
	            default:
	                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action non supportée: " + action);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur serveur");
	    }
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		if ("submitAction".equalsIgnoreCase(action)) {
			sumbitAction(request, response);
		} else if ("voteOnAction".equalsIgnoreCase(action)) {
			voteOnAction(request, response);
		} else if ("getActionVotes".equalsIgnoreCase(action)) {
			getActionVotes(request, response);
		} else if ("allMedia".equalsIgnoreCase(action)) {
			List<Action> actions = actionService.getAllActionsWithMedia();
			List<Action> actionOrig = new ArrayList<>();
			for(Action i : actions) {
				if(i.getStatus()==STATUS.PENDING) {
					actionOrig.add(i);
				}
			}
			request.setAttribute("actions", actionOrig);
			request.getRequestDispatcher("all-media.jsp").forward(request, response);
		} else {
			response.getWriter().write("Option inconnu");
		}
	}

	void showActionForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		System.out.println("=== DEBUT showActionForm ===");

		try {
			System.out.println("ActionService instance: " + (actionService != null ? "OK" : "NULL"));

			List<ActionType> actionTypes = actionService.getAllActionTypes();

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
			request.setAttribute("actionTypes", List.of());
		}

		System.out.println("=== FIN showActionForm ===");
		request.getRequestDispatcher("/submit-action.jsp").forward(request, response);
	}

	void sumbitAction(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String token = null;

		String jwtTokenParam = request.getParameter("jwtToken");
		if (jwtTokenParam != null && !jwtTokenParam.trim().isEmpty()) {
			token = jwtTokenParam.trim();
			System.out.println("🔑 Token récupéré du paramètre jwtToken: "
					+ token.substring(0, Math.min(20, token.length())) + "...");
		}

		if (token == null) {
			String authHeader = request.getHeader("Authorization");
			if (authHeader != null && authHeader.startsWith("Bearer ")) {
				token = authHeader.substring(7);
				System.out.println("🔑 Token récupéré du header Authorization: "
						+ token.substring(0, Math.min(20, token.length())) + "...");
			}
		}

		if (token == null || token.trim().isEmpty()) {
			System.out.println("❌ ERREUR: Aucun token trouvé");
			sendError(response, 401, "Token manquant ou invalide");
			return;
		}

		// Valider le token
		Claims claim = JwtUtil.validerJwtToken(token);
		if (claim == null) {
			System.out.println("❌ ERREUR: Token invalide selon JWTUtil");
			sendError(response, 401, "Token invalide");
			return;
		}

		int suppId = Integer.parseInt(claim.getSubject());
		System.out.println("✅ Token valide! User ID: " + suppId);

		System.out.println("=== SOUMISSION D'ACTION ===");

		String type = null;
		String detail = null;
		String pointsStr = null;
		Part filePart = null;

		try {
			for (Part part : request.getParts()) {
				String name = part.getName();
				System.out.println(" Partie multipart: " + name);

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
				} else if ("jwtToken".equals(name)) {
					System.out.println("Token trouvé dans multipart, ignoré car déjà traité");
				}
			}
		} catch (Exception e) {
			System.err.println("Erreur lecture des données: " + e.getMessage());
			e.printStackTrace();
			sendError(response, 500, "Erreur de lecture des données");
			return;
		}

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
				response.sendRedirect("ActionController?action=allMedia");			} else {
				sendError(response, 500, "Erreur lors de la sauvegarde de l'action");
			}

		} catch (Exception e) {
			System.err.println("Erreur dans submitAction: " + e.getMessage());
			e.printStackTrace();
			sendError(response, 500, "Erreur interne du serveur");
		}
	}

	void voteOnAction(HttpServletRequest request, HttpServletResponse response) throws IOException {
		System.out.println("=== DÉBUT VOTE ===");

		String token = null;
		String jwtTokenParam = request.getParameter("jwtToken");
		if (jwtTokenParam != null && !jwtTokenParam.trim().isEmpty()) {
			token = jwtTokenParam.trim();
			System.out.println(
					"🔑 Token récupéré du paramètre: " + token.substring(0, Math.min(20, token.length())) + "...");
		}

		if (token == null) {
			String authHeader = request.getHeader("Authorization");
			if (authHeader != null && authHeader.startsWith("Bearer ")) {
				token = authHeader.substring(7);
				System.out.println(
						"🔑 Token récupéré du header: " + token.substring(0, Math.min(20, token.length())) + "...");
			}
		}

		if (token == null || token.trim().isEmpty()) {
			System.out.println("❌ ERREUR: Token manquant pour voter");
			sendError(response, 401, "Token manquant ou invalide");
			return;
		}

		// Valider le token
		Claims claim = JwtUtil.validerJwtToken(token);
		if (claim == null) {
			System.out.println("❌ ERREUR: Token invalide");
			sendError(response, 401, "Token invalide");
			return;
		}

		int suppId = Integer.parseInt(claim.getSubject());
		System.out.println("✅ Token valide! User ID: " + suppId);

		String actionIdStr = request.getParameter("actionId");
		String voteType = request.getParameter("vote");

		System.out.println("📊 Paramètres vote - Action ID: " + actionIdStr + ", Vote: " + voteType);

		if (actionIdStr == null || voteType == null) {
			System.out.println("❌ ERREUR: Paramètres manquants");
			sendError(response, 400, "actionId ou vote manquant");
			return;
		}

		int actionId;
		try {
			actionId = Integer.parseInt(actionIdStr);
		} catch (NumberFormatException e) {
			System.out.println("❌ ERREUR: actionId invalide");
			sendError(response, 400, "actionId invalide");
			return;
		}

		if (!"valid".equals(voteType) && !"nonValid".equals(voteType)) {
			System.out.println("❌ ERREUR: Type de vote invalide: " + voteType);
			sendError(response, 400, "vote doit être 'valid' ou 'nonValid'");
			return;
		}

		try {
			System.out.println(
					"🗳️ Tentative de vote - User: " + suppId + ", Action: " + actionId + ", Vote: " + voteType);

			boolean success = actionService.voteOnAction(actionId, suppId, voteType);

			if (success) {
				System.out.println("✅ Vote enregistré avec succès");

				// Récupérer l'action mise à jour pour avoir les votes
				Action action = actionService.getActionById(actionId);
				Map<Integer, String> votes = action != null ? action.getVotes() : new HashMap<>();

				// Compter les votes par type
				int validVotes = 0;
				int nonValidVotes = 0;

				if (votes != null) {
					for (String vType : votes.values()) {
						if ("valid".equals(vType)) {
							validVotes++;
						} else if ("nonValid".equals(vType)) {
							nonValidVotes++;
						}
					}
				}

				response.setContentType("application/json");
				String jsonResponse = String.format(
						"{\"success\": true, \"message\": \"Vote enregistré\", \"votes\": {\"valid\": %d, \"nonValid\": %d}}",
						validVotes, nonValidVotes);
				response.getWriter().write(jsonResponse);

				System.out.println("📈 Stats mises à jour - Valid: " + validVotes + ", NonValid: " + nonValidVotes);
			} else {
				System.out.println("❌ Échec du vote - Action introuvable ou déjà votée");
				sendError(response, 400, "Échec du vote (action introuvable ou déjà votée)");
			}

		} catch (Exception e) {
			System.err.println("❌ ERREUR lors du vote: " + e.getMessage());
			e.printStackTrace();
			sendError(response, 500, "Erreur interne du serveur lors du vote");
		}

		System.out.println("=== FIN VOTE ===");
	}

	void getActionVotes(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String actionIdStr = request.getParameter("actionId");

		if (actionIdStr == null || actionIdStr.trim().isEmpty()) {
			sendError(response, 400, "actionId manquant");
			return;
		}

		try {
			int actionId = Integer.parseInt(actionIdStr);

			// Utiliser la méthode du service qui retourne directement les compteurs
			Map<String, Integer> voteCounts = actionService.getActionVotes(actionId);

			if (voteCounts == null) {
				sendError(response, 404, "Action non trouvée");
				return;
			}

			int validVotes = voteCounts.getOrDefault("valid", 0);
			int nonValidVotes = voteCounts.getOrDefault("nonValid", 0);

			response.setContentType("application/json");
			String jsonResponse = String.format("{\"success\": true, \"votes\": {\"valid\": %d, \"nonValid\": %d}}",
					validVotes, nonValidVotes);
			response.getWriter().write(jsonResponse);

			System.out.println("📊 Votes récupérés pour l'action " + actionId + " - Valid: " + validVotes
					+ ", NonValid: " + nonValidVotes);

		} catch (NumberFormatException e) {
			sendError(response, 400, "actionId invalide");
		} catch (Exception e) {
			System.err.println("Erreur lors de la récupération des votes: " + e.getMessage());
			sendError(response, 500, "Erreur interne du serveur");
		}
	}

	void getPendingAction(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<Action> ListePendingAction = actionService.getPendingAction();
		request.setAttribute("ListPenAction", ListePendingAction);
		request.getRequestDispatcher("/WEB-INF/views/pendingAction.jsp").forward(request, response);
	}

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

	public List<ActionType> getAllActionTypes() {
		return actionService.getAllActionTypes();
	}

	void getUserActions(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String authHeader = request.getHeader("Authorization");
		if (authHeader == null || !authHeader.startsWith("Bearer ")) {
			sendError(response, 401, "Token manquant");
			return;
		}

		String token = authHeader.substring(7);
		Claims claim = JwtUtil.validerJwtToken(token);
		if (claim == null) {
			sendError(response, 401, "Token invalide");
			return;
		}

		int suppId = Integer.parseInt(claim.getSubject());

		try {
			List<Action> userActions = actionService.getUserActions(suppId);

			String json = userActions.stream().map(action -> {
				// Compter les votes pour l'affichage JSON
				Map<Integer, String> votes = action.getVotes();
				int validCount = 0;
				int nonValidCount = 0;

				if (votes != null) {
					for (String voteType : votes.values()) {
						if ("valid".equals(voteType))
							validCount++;
						else if ("nonValid".equals(voteType))
							nonValidCount++;
					}
				}

				return String.format(
						"{\"id\":%d,\"type\":\"%s\",\"details\":\"%s\",\"points\":%d,\"status\":\"%s\",\"submissionDate\":\"%s\",\"mediaFileName\":\"%s\",\"mediaFilePath\":\"%s\",\"votes\":{\"valid\":%d,\"nonValid\":%d}}",
						action.getId(), action.getType(), escapeJson(action.getDetails()), action.getPoints(),
						action.getStatus(), action.getSubmissionDate(),
						action.getMediaFileName() != null ? action.getMediaFileName() : "",
						action.getMediaFilePath() != null ? action.getMediaFilePath() : "", validCount, nonValidCount);
			}).collect(Collectors.joining(",", "[", "]"));

			response.setContentType("application/json");
			response.getWriter().write(json);
		} catch (Exception e) {
			sendError(response, 500, "Erreur lors du chargement des actions");
		}
	}

	void getCommunityActions(HttpServletRequest request, HttpServletResponse response) throws IOException {
		try {
			List<Action> communityActions = actionService.getCommunityActions();

			String json = communityActions.stream().map(action -> {
				// Compter les votes pour l'affichage JSON
				Map<Integer, String> votes = action.getVotes();
				int validCount = 0;
				int nonValidCount = 0;

				if (votes != null) {
					for (String voteType : votes.values()) {
						if ("valid".equals(voteType))
							validCount++;
						else if ("nonValid".equals(voteType))
							nonValidCount++;
					}
				}

				return String.format(
						"{\"id\":%d,\"type\":\"%s\",\"details\":\"%s\",\"points\":%d,\"status\":\"%s\",\"submissionDate\":\"%s\",\"supporterId\":%d,\"votes\":{\"valid\":%d,\"nonValid\":%d}}",
						action.getId(), action.getType(), escapeJson(action.getDetails()), action.getPoints(),
						action.getStatus(), action.getSubmissionDate(), action.getSupporterId(), validCount,
						nonValidCount);
			}).collect(Collectors.joining(",", "[", "]"));

			response.setContentType("application/json");
			response.getWriter().write(json);
		} catch (Exception e) {
			sendError(response, 500, "Erreur lors du chargement des actions communautaires");
		}
	}

	void getAllMedia(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		System.out.println("=== AFFICHAGE TOUS LES MÉDIAS ===");

		try {
			List<Action> actionsWithMedia = actionService.getAllActionsWithMedia();

			// Debug
			System.out.println("Nombre d'actions avec médias: " + actionsWithMedia.size());
			for (Action action : actionsWithMedia) {
				System.out.println("Action ID: " + action.getId() + " | Media Path: " + action.getMediaFilePath()
						+ " | File Name: " + action.getMediaFileName());
			}

			request.setAttribute("actions", actionsWithMedia);
			request.getRequestDispatcher("all-media.jsp").forward(request, response);

		} catch (Exception e) {
			System.err.println("Erreur dans getAllMedia: " + e.getMessage());
			e.printStackTrace();
			sendError(response, 500, "Erreur lors du chargement des médias");
		}
	}

	// Méthode pour afficher les médias d'un utilisateur spécifique
	void getUserMedia(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String token = null;
		String jwtTokenParam = request.getParameter("jwtToken");
		if (jwtTokenParam != null && !jwtTokenParam.trim().isEmpty()) {
			token = jwtTokenParam.trim();
		}

		if (token == null) {
			String authHeader = request.getHeader("Authorization");
			if (authHeader != null && authHeader.startsWith("Bearer ")) {
				token = authHeader.substring(7);
			}
		}

		if (token == null || token.trim().isEmpty()) {
			sendError(response, 401, "Token manquant pour accéder aux médias utilisateur");
			return;
		}

		Claims claim = JwtUtil.validerJwtToken(token);
		if (claim == null) {
			sendError(response, 401, "Token invalide");
			return;
		}

		int suppId = Integer.parseInt(claim.getSubject());

		try {
			List<Action> userActions = actionService.getUserActions(suppId);
			List<Action> userMediaActions = userActions.stream()
					.filter(action -> action.getMediaFilePath() != null && !action.getMediaFilePath().isEmpty())
					.collect(Collectors.toList());

			System.out.println("Médias utilisateur " + suppId + ": " + userMediaActions.size() + " fichiers");

			request.setAttribute("userMedia", userMediaActions);
			request.getRequestDispatcher("user-media.jsp").forward(request, response);

		} catch (Exception e) {
			System.err.println("Erreur dans getUserMedia: " + e.getMessage());
			e.printStackTrace();
			sendError(response, 500, "Erreur lors du chargement des médias utilisateur");
		}
	}

	// Méthode pour servir les fichiers média (streaming)
	void serveMediaFile(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String mediaPath = request.getParameter("path");
		System.out.println("🔍 Chemin média demandé: " + mediaPath);

		if (mediaPath == null || mediaPath.trim().isEmpty()) {
			System.err.println("❌ Chemin du média manquant");
			sendError(response, 400, "Chemin du média manquant");
			return;
		}

		// Nettoyer le chemin - prendre seulement le nom du fichier
		String cleanPath = new File(mediaPath).getName();
		String uploadDir = "/home/ayoub/GreenFansTracker/uploads";
		File mediaFile = new File(uploadDir, cleanPath);

		System.out.println("📁 Fichier recherché: " + mediaFile.getAbsolutePath());
		System.out.println("📁 Fichier existe: " + mediaFile.exists());

		if (!mediaFile.exists()) {
			// Essayer avec le chemin complet
			mediaFile = new File(mediaPath);
			System.out.println("🔄 Essai avec chemin complet: " + mediaFile.getAbsolutePath());
			System.out.println("🔄 Fichier existe: " + mediaFile.exists());

			if (!mediaFile.exists()) {
				System.err.println("❌ Fichier non trouvé: " + mediaPath);
				sendError(response, 404, "Fichier média non trouvé: " + cleanPath);
				return;
			}
		}

		try {
			// Déterminer le type MIME
			String mimeType = getServletContext().getMimeType(mediaFile.getName());
			if (mimeType == null) {
				mimeType = "application/octet-stream";
			}

			response.setContentType(mimeType);
			response.setContentLengthLong(mediaFile.length());
			response.setHeader("Content-Disposition", "inline; filename=\"" + mediaFile.getName() + "\"");

			// Copier le fichier dans la réponse
			Files.copy(mediaFile.toPath(), response.getOutputStream());
			System.out.println("✅ Fichier servi avec succès: " + mediaFile.getName());

		} catch (Exception e) {
			System.err.println("❌ Erreur lors du service du fichier: " + e.getMessage());
			e.printStackTrace();
			sendError(response, 500, "Erreur lors du chargement du fichier");
		}
	}

	// Méthode pour récupérer les infos média d'une action spécifique
	void getMediaInfo(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String actionIdStr = request.getParameter("actionId");
		if (actionIdStr == null || actionIdStr.trim().isEmpty()) {
			sendError(response, 400, "ID d'action manquant");
			return;
		}

		try {
			int actionId = Integer.parseInt(actionIdStr);
			String mediaPath = actionService.getMediaPathByActionId(actionId);

			if (mediaPath != null) {
				response.setContentType("application/json");
				response.getWriter().write("{\"mediaPath\": \"" + mediaPath + "\"}");
			} else {
				sendError(response, 404, "Aucun média trouvé pour cette action");
			}

		} catch (NumberFormatException e) {
			sendError(response, 400, "ID d'action invalide");
		} catch (Exception e) {
			System.err.println("Erreur dans getMediaInfo: " + e.getMessage());
			e.printStackTrace();
			sendError(response, 500, "Erreur interne");
		}
	}

	private void showMyActions(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    
	    System.out.println("=== DÉBUT showMyActions ===");
	    
	    try {
	        System.out.println("🔍 URL: " + request.getRequestURL());
	        System.out.println("🔍 Query String: " + request.getQueryString());
	        
	        String token = request.getParameter("jwtToken");
	        System.out.println("🔍 Token du paramètre: " + (token != null ? token.substring(0, 10) + "..." : "NULL"));
	        
	        if (token == null) {
	            String authHeader = request.getHeader("Authorization");
	            System.out.println("🔍 Authorization header: " + authHeader);
	            if (authHeader != null && authHeader.startsWith("Bearer ")) {
	                token = authHeader.substring(7);
	                System.out.println("🔍 Token du header: " + token.substring(0, 10) + "...");
	            }
	        }
	        
	        if (token == null) {
	            token = request.getParameter("token");
	            System.out.println("🔍 Token param 'token': " + (token != null ? token.substring(0, 10) + "..." : "NULL"));
	        }
	        
	        if (token == null) {
	            System.out.println("❌ Aucun token trouvé dans la requête");
	            System.out.println("ℹ️  Redirection vers login...");
	            response.sendRedirect("index.jsp?error=not_logged_in");
	            return;
	        }
	        
	        Integer userId = extractUserIdFromToken(token);
	        System.out.println("🔍 UserId extrait: " + userId);
	        
	        if (userId == null) {
	            System.out.println("❌ Impossible d'extraire userId");
	            response.sendRedirect("index.jsp?error=invalid_token");
	            return;
	        }
	        
	        ActionService actionService = new ActionServiceImpl();
	        List<Action> userActions = actionService.getUserActions1(userId);
	        System.out.println("✅ Actions récupérées: " + userActions.size());
	        
	        request.setAttribute("userActions", userActions);
	        request.setAttribute("userId", userId);
	        request.getRequestDispatcher("/my-actions.jsp").forward(request, response);
	        
	    } catch (Exception e) {
	        System.err.println("❌ ERREUR showMyActions: " + e.getMessage());
	        e.printStackTrace();
	        response.sendRedirect("error.jsp?message=Erreur chargement actions");
	    } finally {
	        System.out.println("=== FIN showMyActions ===");
	    }
	}

	// AJOUTEZ CETTE MÉTHODE (identique à celle utilisée pour voter)
	private Integer extractUserIdFromToken(String token) {
	    try {
	        // MÊME CODE QUE DANS VOTRE MÉTHODE voteOnAction
	        // Exemple basique - adaptez selon votre implémentation réelle
	        String[] parts = token.split("\\.");
	        if (parts.length < 2) {
	            System.out.println("❌ Token mal formaté");
	            return null;
	        }
	        
	        String payload = new String(java.util.Base64.getUrlDecoder().decode(parts[1]));
	        System.out.println("📄 Payload: " + payload);
	        
	        // Utilisez votre bibliothèque JSON préférée
	        // Exemple avec Gson ou Jackson
	        if (payload.contains("\"sub\":")) {
	            String subStr = payload.split("\"sub\":")[1].split(",")[0].replaceAll("\"", "").trim();
	            return Integer.parseInt(subStr);
	        }
	        
	        return null;
	        
	    } catch (Exception e) {
	        System.err.println("❌ Erreur extraction userId: " + e.getMessage());
	        return null;
	    }
	}



	private String escapeJson(String text) {
		return text != null ? text.replace("\"", "\\\"").replace("\n", "\\n") : "";
	}
}