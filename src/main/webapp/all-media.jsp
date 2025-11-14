<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dev.ayoub.ActionService.model.Action" %>
<%
    List<Action> actions = (List<Action>) request.getAttribute("actions");
    boolean hasActions = actions != null && !actions.isEmpty();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Galerie des Médias - Green Fan Tracker</title>
    
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
        .vote-btn {
            transition: all 0.3s ease;
        }
        .vote-btn:hover {
            transform: scale(1.05);
        }
        .vote-btn:active {
            transform: scale(0.95);
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
                                <i class="fas fa-images mr-3 text-green-500"></i>
                                Galerie des Actions Écologiques
                            </h1>
                            <p class="text-gray-600">Découvrez et votez pour les actions de la communauté</p>
                        </div>
                        <div class="flex space-x-4">
                            <button onclick="refreshGallery()" 
                                    class="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition flex items-center">
                                <i class="fas fa-sync-alt mr-2"></i>Actualiser
                            </button>
                            <a href="ActionController?action=showForm" 
                               class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition flex items-center">
                                <i class="fas fa-plus mr-2"></i>Nouvelle Action
                            </a>
                        </div>
                    </div>

                    <!-- Section utilisateur connecté -->
                    <div id="userSection" class="hidden mb-6 p-4 bg-green-50 rounded-lg border border-green-200">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center">
                                <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center mr-3">
                                    <i class="fas fa-user-check text-green-500"></i>
                                </div>
                                <div>
                                    <h3 class="font-semibold text-green-800" id="userGreeting">Connecté</h3>
                                    <p class="text-green-600 text-sm">Prêt à voter sur les actions</p>
                                </div>
                            </div>
                            <button onclick="logout()" class="text-sm text-red-600 hover:text-red-800 flex items-center">
                                <i class="fas fa-sign-out-alt mr-1"></i>Déconnexion
                            </button>
                        </div>
                    </div>

                    <!-- Section connexion requise -->
                    <div id="loginRequired" class="hidden mb-6 p-4 bg-yellow-50 rounded-lg border border-yellow-200">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center">
                                <div class="w-10 h-10 bg-yellow-100 rounded-full flex items-center justify-center mr-3">
                                    <i class="fas fa-exclamation-triangle text-yellow-500"></i>
                                </div>
                                <div>
                                    <h3 class="font-semibold text-yellow-800">Connexion requise</h3>
                                    <p class="text-yellow-600 text-sm">Connectez-vous pour voter sur les actions</p>
                                </div>
                            </div>
                            <button onclick="window.location.href='index.jsp'" 
                                    class="px-4 py-2 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600 transition text-sm">
                                Se connecter
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Grille des médias -->
                <div id="mediaContainer">
                    <% if (hasActions) { %>
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                            <% for (Action action : actions) { %>
                                <div class="media-card bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden hover:shadow-lg transition-all duration-300 fade-in">
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
                                    
                                    <!-- Contenu et votes -->
                                    <div class="p-4">
                                        <p class="text-gray-600 text-sm mb-3 line-clamp-2"><%= action.getDetails() %></p>
                                        
                                        <!-- Section votes -->
                                        <div class="border-t border-gray-100 pt-3">
                                            <div class="flex justify-between items-center mb-2">
                                                <span class="text-xs text-gray-500">Votes de la communauté:</span>
                                                <button onclick="getActionVotes(<%= action.getId() %>)" 
                                                        class="text-blue-500 hover:text-blue-700 text-xs">
                                                    <i class="fas fa-chart-bar mr-1"></i>Détails
                                                </button>
                                            </div>
                                            
                                            <div class="flex space-x-2 mb-3">
                                                <button onclick="voteOnAction(<%= action.getId() %>, 'valid')" 
                                                        class="vote-btn flex-1 bg-green-500 hover:bg-green-600 text-white py-2 rounded-lg transition flex items-center justify-center text-sm">
                                                    <i class="fas fa-thumbs-up mr-2"></i>
                                                    <span id="validCount-<%= action.getId() %>">0</span>
                                                </button>
                                                
                                                <button onclick="voteOnAction(<%= action.getId() %>, 'nonValid')" 
                                                        class="vote-btn flex-1 bg-red-500 hover:bg-red-600 text-white py-2 rounded-lg transition flex items-center justify-center text-sm">
                                                    <i class="fas fa-thumbs-down mr-2"></i>
                                                    <span id="nonValidCount-<%= action.getId() %>">0</span>
                                                </button>
                                            </div>
                                            
                                            <!-- Statut -->
                                            <div class="flex justify-between items-center text-xs">
                                                <span class="px-2 py-1 rounded-full 
                                                    <%= "VALIDATED".equals(action.getStatus()) ? "bg-green-100 text-green-800" : 
                                                        "PENDING".equals(action.getStatus()) ? "bg-yellow-100 text-yellow-800" : 
                                                        "REJECTED".equals(action.getStatus()) ? "bg-red-100 text-red-800" : 
                                                        "bg-gray-100 text-gray-800" %>">
                                                    <%= action.getStatus() != null ? action.getStatus() : "INCONNU" %>
                                                </span>
                                                
                                                <span class="text-gray-500">
                                                    ID: <%= action.getId() %>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="text-center py-12 fade-in">
                            <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                                <i class="fas fa-images text-gray-400 text-3xl"></i>
                            </div>
                            <h3 class="text-xl font-bold text-gray-700 mb-2">Aucun média disponible</h3>
                            <p class="text-gray-500 mb-6">Aucune action avec média n'a été partagée pour le moment.</p>
                            <a href="ActionController?action=showForm" 
                               class="inline-flex items-center px-6 py-3 bg-green-500 text-white rounded-lg hover:bg-green-600 transition font-semibold">
                                <i class="fas fa-plus mr-2"></i>
                                Soumettre la première action
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
            loadVotesForAllActions();
        });

        function checkAuthStatus() {
            const token = localStorage.getItem('jwtToken');
            console.log("🔑 Token trouvé:", token ? "OUI" : "NON");
            
            if (token && isTokenValid(token)) {
                currentToken = token;
                isUserLoggedIn = true;
                showUserSection();
                console.log("✅ Utilisateur connecté");
            } else {
                isUserLoggedIn = false;
                showLoginRequired();
                console.log("❌ Utilisateur non connecté");
                
                // Supprimer le token invalide
                if (token) {
                    localStorage.removeItem('jwtToken');
                    console.log("🗑️ Token invalide supprimé");
                }
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

        function showUserSection() {
            document.getElementById('userSection').classList.remove('hidden');
            document.getElementById('loginRequired').classList.add('hidden');
            
            try {
                const payload = JSON.parse(atob(currentToken.split('.')[1]));
                document.getElementById('userGreeting').textContent = `Bonjour, Utilisateur #${payload.sub}`;
            } catch (e) {
                console.error("Erreur affichage utilisateur:", e);
            }
        }

        function showLoginRequired() {
            document.getElementById('userSection').classList.add('hidden');
            document.getElementById('loginRequired').classList.remove('hidden');
        }

        function logout() {
            localStorage.removeItem('jwtToken');
            localStorage.removeItem('currentUser');
            showNotification('👋 Déconnexion réussie', 'info');
            setTimeout(() => {
                window.location.reload();
            }, 1000);
        }

        // Système de votes
        async function voteOnAction(actionId, voteType) {
            if (!isUserLoggedIn || !currentToken) {
                showNotification('🔒 Connectez-vous pour voter', 'error');
                showLoginRequired();
                return;
            }

            console.log(`🗳️ Tentative de vote - Action: ${actionId}, Vote: ${voteType}`);

            const formData = new FormData();
            formData.append('action', 'voteOnAction');
            formData.append('actionId', actionId);
            formData.append('vote', voteType);
            formData.append('jwtToken', currentToken);

            try {
                const response = await fetch('ActionController', {
                    method: 'POST',
                    body: formData
                });

                const data = await response.json();
                console.log('📊 Réponse vote:', data);

                if (data.success) {
                    showNotification('✅ Vote enregistré avec succès!', 'success');
                    // Mettre à jour les compteurs de votes localement
                    updateVoteCounts(actionId, data.votes.valid, data.votes.nonValid);
                } else {
                    showNotification('❌ ' + (data.error || 'Échec du vote'), 'error');
                }
            } catch (error) {
                console.error('❌ Erreur vote:', error);
                showNotification('❌ Erreur de connexion', 'error');
            }
        }

        async function getActionVotes(actionId) {
            try {
                const response = await fetch(`ActionController?action=getActionVotes&actionId=${actionId}`);
                const data = await response.json();
                
                if (data.success) {
                    showNotification(
                        `📊 Votes pour l'action #${actionId}:<br>✅ ${data.votes.valid} validations<br>❌ ${data.votes.nonValid} rejets`,
                        'info'
                    );
                } else {
                    showNotification('❌ ' + (data.error || 'Impossible de récupérer les votes'), 'error');
                }
            } catch (error) {
                console.error('❌ Erreur récupération votes:', error);
                showNotification('❌ Erreur de connexion', 'error');
            }
        }

        function updateVoteCounts(actionId, validCount, nonValidCount) {
            const validElement = document.getElementById(`validCount-${actionId}`);
            const nonValidElement = document.getElementById(`nonValidCount-${actionId}`);
            
            if (validElement) validElement.textContent = validCount;
            if (nonValidElement) nonValidElement.textContent = nonValidCount;
        }

        async function loadVotesForAllActions() {
            <% if (hasActions) { %>
                <% for (Action action : actions) { %>
                    try {
                        const response = await fetch(`ActionController?action=getActionVotes&actionId=${<%= action.getId() %>}`);
                        const data = await response.json();
                        
                        if (data.success) {
                            updateVoteCounts(<%= action.getId() %>, data.votes.valid, data.votes.nonValid);
                        }
                    } catch (error) {
                        console.error(`❌ Erreur chargement votes action ${<%= action.getId() %>}:`, error);
                    }
                <% } %>
            <% } %>
        }

        function refreshGallery() {
            showNotification('🔄 Actualisation en cours...', 'info');
            setTimeout(() => {
                window.location.reload();
            }, 1000);
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

        document.addEventListener('error', function(e) {
            if (e.target.tagName === 'IMG') {
                e.target.style.display = 'none';
                const errorDiv = e.target.nextElementSibling;
                if (errorDiv) {
                    errorDiv.style.display = 'block';
                }
            }
        }, true);

        console.log('🎯 Galerie des médias chargée avec succès!');
    </script>
</body>
</html>