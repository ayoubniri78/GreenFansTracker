<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dev.ayoub.ActionService.model.Action" %>
<%@ page import="dev.ayoub.ActionService.model.STATUS" %>
<%@ page import="java.util.Map" %>
<%
    List<Action> userActions = (List<Action>) request.getAttribute("userActions");
    Integer userId = (Integer) request.getAttribute("userId");
    boolean hasActions = userActions != null && !userActions.isEmpty();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Actions - Green Fan Tracker</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .fade-in {
            animation: fadeIn 0.5s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .image-loading {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
        }
        @keyframes loading {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }
        .progress-bar {
            transition: width 0.5s ease-in-out;
        }
        .status-badge {
            transition: all 0.3s ease;
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">
    <jsp:include page="components/header.jsp" />

    <div class="flex">
        <jsp:include page="components/sidebar.jsp" />

        <main class="flex-1 p-6 ml-64">
            <div class="max-w-7xl mx-auto">
                
                <!-- En-tête -->
                <div class="mb-8 fade-in">
                    <div class="flex justify-between items-center mb-6">
                        <div>
                            <h1 class="text-3xl font-bold text-gray-800 mb-2">
                                <i class="fas fa-user-circle mr-3 text-blue-500"></i>
                                Mes Actions Écologiques
                            </h1>
                            <p class="text-gray-600">Suivez l'état de vos soumissions et leur progression</p>
                        </div>
                        <div class="flex space-x-4">
                            <button onclick="refreshPage()" 
                                    class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition flex items-center">
                                <i class="fas fa-sync-alt mr-2"></i>Actualiser
                            </button>
                            <a href="ActionController?action=showForm" 
                               class="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition flex items-center">
                                <i class="fas fa-plus mr-2"></i>Nouvelle Action
                            </a>
                        </div>
                    </div>

                    <!-- Section utilisateur -->
                    <div class="mb-6 p-4 bg-blue-50 rounded-lg border border-blue-200">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center">
                                <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center mr-4">
                                    <i class="fas fa-user text-blue-500 text-xl"></i>
                                </div>
                                <div>
                                    <h3 class="font-semibold text-blue-800 text-lg" id="userGreeting">Utilisateur #<%= userId != null ? userId : "Inconnu" %></h3>
                                    <p class="text-blue-600">Gérez vos actions écologiques soumises</p>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="text-2xl font-bold text-blue-700">
                                    <%= hasActions ? userActions.size() : 0 %>
                                </div>
                                <div class="text-blue-600 text-sm">Actions soumises</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Statistiques rapides -->
                <% if (hasActions) { 
                    long pendingCount = userActions.stream().filter(a -> a.getStatus() == STATUS.PENDING).count();
                    long validatedCount = userActions.stream().filter(a -> a.getStatus() == STATUS.VALIDATED).count();
                    long rejectedCount = userActions.stream().filter(a -> a.getStatus() == STATUS.REJECTED).count();
                %>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8 fade-in">
                    <div class="bg-white p-6 rounded-2xl shadow-sm border border-yellow-200">
                        <div class="flex items-center">
                            <div class="w-12 h-12 bg-yellow-100 rounded-full flex items-center justify-center mr-4">
                                <i class="fas fa-clock text-yellow-500 text-xl"></i>
                            </div>
                            <div>
                                <div class="text-2xl font-bold text-yellow-700"><%= pendingCount %></div>
                                <div class="text-yellow-600 font-semibold">En attente</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white p-6 rounded-2xl shadow-sm border border-green-200">
                        <div class="flex items-center">
                            <div class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center mr-4">
                                <i class="fas fa-check-circle text-green-500 text-xl"></i>
                            </div>
                            <div>
                                <div class="text-2xl font-bold text-green-700"><%= validatedCount %></div>
                                <div class="text-green-600 font-semibold">Validées</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white p-6 rounded-2xl shadow-sm border border-red-200">
                        <div class="flex items-center">
                            <div class="w-12 h-12 bg-red-100 rounded-full flex items-center justify-center mr-4">
                                <i class="fas fa-times-circle text-red-500 text-xl"></i>
                            </div>
                            <div>
                                <div class="text-2xl font-bold text-red-700"><%= rejectedCount %></div>
                                <div class="text-red-600 font-semibold">Rejetées</div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>

                <!-- Liste des actions -->
                <div id="actionsContainer">
                    <% if (hasActions) { %>
                        <div class="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
                            <% for (Action action : userActions) { 
                                Map<Integer, String> votes = action.getVotes();
                                int valid = votes != null ? (int) votes.values().stream().filter(v -> "valid".equals(v)).count() : 0;
                                int nonValid = votes != null ? (int) votes.values().stream().filter(v -> "nonValid".equals(v)).count() : 0;
                                int totalVotes = valid + nonValid;
                                int progress = totalVotes > 0 ? (valid * 100) / totalVotes : 0;
                            %>
                                <div class="action-card bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden hover:shadow-lg transition-all duration-300 fade-in">
                                    <!-- En-tête de la carte -->
                                    <div class="p-4 border-b border-gray-100">
                                        <div class="flex justify-between items-center mb-2">
                                            <span class="bg-green-100 text-green-800 px-2 py-1 rounded-full text-xs font-semibold">
                                                <i class="fas fa-star mr-1"></i><%= action.getPoints() %> pts
                                            </span>
                                            <span class="text-xs text-gray-500">
                                                <i class="far fa-calendar mr-1"></i>
                                                <%= action.getSubmissionDate() != null ? 
                                                    action.getSubmissionDate().toString().substring(0, 10) : "" %>
                                            </span>
                                        </div>
                                        <h3 class="font-semibold text-gray-800 text-sm line-clamp-1"><%= action.getType() %></h3>
                                    </div>
                                    
                                    <!-- Média -->
                                    <div class="aspect-w-16 aspect-h-9 bg-gray-100 relative">
                                        <% 
                                            String mediaUrl = "ActionController?action=serveMedia&path=" + 
                                                             java.net.URLEncoder.encode(action.getMediaFilePath() != null ? action.getMediaFilePath() : "", "UTF-8");
                                            boolean isVideo = action.getMediaFileName() != null && 
                                                             (action.getMediaFileName().toLowerCase().endsWith(".mp4") || 
                                                              action.getMediaFileName().toLowerCase().endsWith(".mov"));
                                        %>
                                        
                                        <% if (isVideo) { %>
                                            <video controls class="w-full h-48 object-cover" 
                                                   poster="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='400' height='300' viewBox='0 0 400 300'%3E%3Crect width='400' height='300' fill='%23f3f4f6'/%3E%3Cpath d='M160 120v60l40-30z' fill='%239ca3af'/%3E%3C/svg%3E">
                                                <source src="<%= mediaUrl %>" type="video/mp4">
                                                Votre navigateur ne supporte pas la vidéo.
                                            </video>
                                            <div class="absolute top-2 right-2 bg-black bg-opacity-50 text-white px-2 py-1 rounded text-xs">
                                                <i class="fas fa-play mr-1"></i>Vidéo
                                            </div>
                                        <% } else { %>
                                            <img src="<%= mediaUrl %>" 
                                                 alt="Action écologique: <%= action.getType() %>" 
                                                 class="w-full h-48 object-cover image-loading"
                                                 onload="this.classList.remove('image-loading')"
                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                                            <div style="display:none;" class="w-full h-48 bg-gray-200 flex items-center justify-center">
                                                <div class="text-center">
                                                    <i class="fas fa-exclamation-triangle text-gray-400 text-2xl mb-2"></i>
                                                    <p class="text-gray-500 text-sm">Image non disponible</p>
                                                </div>
                                            </div>
                                            <div class="absolute top-2 right-2 bg-black bg-opacity-50 text-white px-2 py-1 rounded text-xs">
                                                <i class="fas fa-image mr-1"></i>Image
                                            </div>
                                        <% } %>
                                    </div>
                                    
                                    <!-- Contenu et statut -->
                                    <div class="p-4">
                                        <p class="text-gray-600 text-sm mb-3 line-clamp-2"><%= action.getDetails() %></p>
                                        
                                        <!-- Barre de progression des votes -->
                                        <div class="mb-4">
                                            <div class="flex justify-between text-xs text-gray-500 mb-1">
                                                <span>Progression de validation</span>
                                                <span><%= valid %>/<%= totalVotes %> votes</span>
                                            </div>
                                            <div class="w-full bg-gray-200 rounded-full h-2">
                                                <div class="bg-green-500 h-2 rounded-full progress-bar" 
                                                     style="width: <%= progress %>%"></div>
                                            </div>
                                        </div>
                                        
                                        <!-- Détails des votes -->
                                        <div class="flex justify-between text-xs text-gray-600 mb-3">
                                            <div class="flex items-center">
                                                <i class="fas fa-thumbs-up text-green-500 mr-1"></i>
                                                <span><%= valid %> validations</span>
                                            </div>
                                            <div class="flex items-center">
                                                <i class="fas fa-thumbs-down text-red-500 mr-1"></i>
                                                <span><%= nonValid %> rejets</span>
                                            </div>
                                        </div>
                                        
                                        <!-- Statut -->
                                        <div class="flex justify-between items-center">
                                            <span class="px-3 py-1 rounded-full text-xs font-semibold status-badge
                                                <%= action.getStatus() == STATUS.VALIDATED ? "bg-green-100 text-green-800 border border-green-200" : 
                                                   action.getStatus() == STATUS.PENDING ? "bg-yellow-100 text-yellow-800 border border-yellow-200" : 
                                                   action.getStatus() == STATUS.REJECTED ? "bg-red-100 text-red-800 border border-red-200" : 
                                                   "bg-gray-100 text-gray-800 border border-gray-200" %>">
                                                <i class="fas 
                                                    <%= action.getStatus() == STATUS.VALIDATED ? "fa-check-circle" : 
                                                       action.getStatus() == STATUS.PENDING ? "fa-clock" : 
                                                       action.getStatus() == STATUS.REJECTED ? "fa-times-circle" : "fa-question" %> 
                                                    mr-1"></i>
                                                <%= action.getStatus() != null ? action.getStatus() : "INCONNU" %>
                                            </span>
                                            
                                            <% if (action.getStatus() == STATUS.VALIDATED) { %>
                                                <div class="text-green-600 text-xs font-semibold">
                                                    <i class="fas fa-trophy mr-1"></i>Récompense obtenue!
                                                </div>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="text-center py-12 fade-in">
                            <div class="w-24 h-24 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-6">
                                <i class="fas fa-leaf text-blue-400 text-3xl"></i>
                            </div>
                            <h3 class="text-xl font-bold text-gray-700 mb-2">Aucune action soumise</h3>
                            <p class="text-gray-500 mb-6">Vous n'avez pas encore soumis d'action écologique.</p>
                            <a href="ActionController?action=showForm" 
                               class="inline-flex items-center px-6 py-3 bg-green-500 text-white rounded-lg hover:bg-green-600 transition font-semibold">
                                <i class="fas fa-plus mr-2"></i>
                                Soumettre ma première action
                            </a>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>

    <!-- Notification -->
    <div id="notification" class="fixed top-4 right-4 p-4 rounded-lg shadow-lg z-50 hidden fade-in"></div>

    <script>
        // Token JWT et état utilisateur
        let currentToken = null;
        let isUserLoggedIn = false;

        document.addEventListener('DOMContentLoaded', function() {
            checkAuthStatus();
            initializePage();
        });

        function checkAuthStatus() {
            const token = localStorage.getItem('jwtToken');
            console.log("🔑 Token trouvé:", token ? "OUI" : "NON");
            
            if (token && isTokenValid(token)) {
                currentToken = token;
                isUserLoggedIn = true;
                console.log("✅ Utilisateur connecté");
            } else {
                isUserLoggedIn = false;
                console.log("❌ Utilisateur non connecté");
                
                if (token) {
                    localStorage.removeItem('jwtToken');
                    console.log("🗑️ Token invalide supprimé");
                }
                
                // Redirection si pas connecté
                setTimeout(() => {
                    window.location.href = 'index.jsp?error=not_logged_in';
                }, 1000);
            }
        }

        function isTokenValid(token) {
            try {
                const payload = JSON.parse(atob(token.split('.')[1]));
                const expiration = payload.exp * 1000;
                const now = Date.now();
                return now < expiration;
            } catch (e) {
                console.error("❌ Erreur parsing token:", e);
                return false;
            }
        }

        function initializePage() {
            // Vérifier que la page a été chargée avec le bon userId
            const pageUserId = <%= userId != null ? userId : "null" %>;
            console.log("👤 UserId de la page:", pageUserId);
            
            if (!pageUserId) {
                showNotification('❌ Erreur de chargement des données', 'error');
            }
        }

        function refreshPage() {
            showNotification('🔄 Actualisation en cours...', 'info');
            
            // Recharger avec le token
            const token = localStorage.getItem('jwtToken');
            if (token) {
                setTimeout(() => {
                    window.location.href = 'ActionController?action=my-actions&jwtToken=' + encodeURIComponent(token);
                }, 1000);
            } else {
                window.location.reload();
            }
        }

        function showNotification(message, type) {
            const notification = document.getElementById('notification');
            const bgColor = type === 'success' ? 'bg-green-500' :
                          type === 'error' ? 'bg-red-500' :
                          type === 'info' ? 'bg-blue-500' : 'bg-gray-500';
            
            notification.className = `fixed top-4 right-4 p-4 rounded-lg shadow-lg z-50 fade-in text-white ${bgColor}`;
            notification.innerHTML = `
                <div class="flex items-center">
                    <i class="fas fa-${type === 'success' ? 'check' : type === 'error' ? 'exclamation-triangle' : 'info'}-circle mr-2"></i>
                    <span>${message}</span>
                </div>
            `;
            notification.classList.remove('hidden');
            
            setTimeout(() => {
                notification.classList.add('hidden');
            }, 4000);
        }

        // Gestion des erreurs de chargement d'images
        document.addEventListener('error', function(e) {
            if (e.target.tagName === 'IMG') {
                e.target.style.display = 'none';
                const errorDiv = e.target.nextElementSibling;
                if (errorDiv) {
                    errorDiv.style.display = 'block';
                }
            }
        }, true);

        // Vérifier périodiquement la connexion
        setInterval(() => {
            if (!localStorage.getItem('jwtToken')) {
                showNotification('🔒 Session expirée', 'error');
                setTimeout(() => {
                    window.location.href = 'index.jsp';
                }, 2000);
            }
        }, 60000); // Vérifier toutes les minutes

        console.log('🎯 Page "Mes Actions" chargée avec succès!');
    </script>
</body>
</html>