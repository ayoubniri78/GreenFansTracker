<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dev.ayoub.ActionService.model.ActionType" %>
<%@ page import="dev.ayoub.ActionService.service.ActionServiceImpl" %>
<%
    List<ActionType> actionTypes = null;
    try {
        ActionServiceImpl actionService = new ActionServiceImpl();
        actionTypes = actionService.getAllActionTypes();
    } catch (Exception e) {
        actionTypes = java.util.List.of();
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Soumettre une Action - Green Fan Tracker</title>
    
    <!-- Tailwind CSS local -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50 min-h-screen">
    <jsp:include page="components/header.jsp" />

    <div class="flex">
        <jsp:include page="components/sidebar.jsp" />

        <main class="flex-1 p-6 ml-64">
            <div class="max-w-4xl mx-auto">
                
                <!-- Page Header -->
                <div class="mb-8">
                    <h1 class="text-3xl font-bold text-gray-800 mb-2">
                        <i class="fas fa-upload mr-3 text-green-500"></i>
                        Soumettre une Action Écologique
                    </h1>
                    <p class="text-gray-600">Partagez votre geste pour la planète et inspirez la communauté</p>
                </div>

                <!-- Container principal -->
                <div id="mainContent">
                    <div class="text-center py-12">
                        <div class="w-12 h-12 border-4 border-green-500 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
                        <p class="text-gray-600">Chargement...</p>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const token = localStorage.getItem('jwtToken');
            console.log("Token trouvé:", token ? "OUI" : "NON");
            console.log("Token valeur:", token);
            
            if (token && isTokenValid(token)) {
                showForm(token);
            } else {
                console.log("Token invalide ou manquant");
                showLoginRequired();
            }
        });

        // Vérifier si le token est expiré
        function isTokenValid(token) {
            try {
                const payload = JSON.parse(atob(token.split('.')[1]));
                const expiration = payload.exp * 1000; // Convertir en ms
                const now = Date.now();
                
                console.log("Token expire à:", new Date(expiration));
                console.log("Maintenant:", new Date(now));
                console.log("Token valide:", now < expiration);
                
                return now < expiration;
            } catch (e) {
                console.error("Erreur parsing token:", e);
                return false;
            }
        }
        
        function showForm(token) {
            const container = document.getElementById('mainContent');
            container.innerHTML = `
                <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-8">
                    <!-- Section utilisateur -->
                    <div class="mb-6 p-4 bg-green-50 rounded-lg border border-green-200">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center">
                                <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center mr-3">
                                    <i class="fas fa-user-check text-green-500"></i>
                                </div>
                                <div>
                                    <h3 class="font-semibold text-green-800">Connecté</h3>
                                    <p class="text-green-600 text-sm">Prêt à soumettre votre action</p>
                                </div>
                            </div>
                            <button onclick="logout()" class="text-sm text-red-600 hover:text-red-800">
                                <i class="fas fa-sign-out-alt mr-1"></i>Déconnexion
                            </button>
                        </div>
                    </div>
                    
                    <!-- Formulaire avec méthode POST standard -->
                    <form action="ActionController" method="post" enctype="multipart/form-data" id="actionForm">
                        <!-- Champs cachés pour l'action et le token -->
                        <input type="hidden" name="action" value="submitAction">
                        <input type="hidden" name="jwtToken" value="${token}">
                        
                        <!-- Section Upload -->
                        <div class="mb-8">
                            <h2 class="text-xl font-semibold text-gray-800 mb-4">
                                <i class="fas fa-camera mr-2 text-green-500"></i>
                                Preuve Visuelle
                            </h2>
                            
                            <div class="border-2 border-dashed border-gray-300 rounded-xl p-8 text-center transition-all hover:border-green-400 hover:bg-green-50"
                                 onclick="document.getElementById('fileInput').click()"
                                 id="uploadArea">
                                <input type="file" id="fileInput" name="file" 
                                       accept="image/*,video/*" required 
                                       onchange="handleFileSelect(this)" 
                                       style="display: none;">
                                
                                <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-green-100 flex items-center justify-center">
                                    <i class="fas fa-cloud-upload-alt text-2xl text-green-500"></i>
                                </div>
                                
                                <h3 class="text-lg font-semibold text-gray-700 mb-2">
                                    Glissez-déposez votre fichier ici
                                </h3>
                                <p class="text-gray-500 text-sm mb-4">
                                    Formats supportés : JPG, PNG, MP4, MOV (max. 10MB)
                                </p>
                                
                                <button type="button" class="bg-green-500 text-white px-6 py-2 rounded-lg font-medium hover:bg-green-600">
                                    <i class="fas fa-folder-open mr-2"></i>
                                    Sélectionner un fichier
                                </button>
                                
                                <div id="fileInfo" class="mt-4 p-3 bg-green-50 rounded-lg border border-green-200 hidden">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <i class="fas fa-file text-green-500 mr-3"></i>
                                            <div>
                                                <p class="font-medium text-green-800" id="fileName"></p>
                                                <p class="text-sm text-green-600" id="fileSize"></p>
                                            </div>
                                        </div>
                                        <button type="button" onclick="removeFile()" class="text-red-400 hover:text-red-600">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Type d'action et Points -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    <i class="fas fa-tag mr-2 text-green-500"></i>
                                    Type d'action
                                </label>
                                <select id="actionType" name="type" required onchange="updatePoints()"
                                        class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 transition">
                                    <option value="">Sélectionnez un type</option>
                                    <% if (actionTypes != null && !actionTypes.isEmpty()) { 
                                        for (ActionType type : actionTypes) { %>
                                        <option value="<%= type.getName() %>" data-points="<%= type.getDefaultPoints() %>">
                                            <%= type.getName() %> (<%= type.getDefaultPoints() %> points)
                                        </option>
                                    <%   }
                                       } %>
                                </select>
                            </div>
                            
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    <i class="fas fa-star mr-2 text-green-500"></i>
                                    Points gagnés
                                </label>
                                <div class="flex items-center">
                                    <input type="number" id="points" name="points" readonly
                                           class="w-full p-3 border border-gray-300 rounded-lg bg-gray-50 text-green-600 font-semibold">
                                    <div class="ml-2 w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                                        <i class="fas fa-coins text-green-500"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="mb-8">
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                <i class="fas fa-align-left mr-2 text-green-500"></i>
                                Description de l'action
                            </label>
                            <textarea id="description" name="detail" required
                                      placeholder="Décrivez en détail votre action écologique..."
                                      class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 transition h-32"
                                      oninput="updateCharCount()"></textarea>
                            <div class="flex justify-between text-sm text-gray-500 mt-1">
                                <span>Décrivez l'impact de votre action</span>
                                <span id="charCount">0/500</span>
                            </div>
                        </div>

                        <!-- Boutons -->
                        <div class="flex justify-end space-x-4 pt-6 border-t border-gray-200">
                            <button type="button" onclick="window.history.back()" class="px-6 py-3 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition">
                                <i class="fas fa-times mr-2"></i>
                                Annuler
                            </button>
                            <button type="submit" id="submitBtn"
                                    class="px-8 py-3 bg-green-500 text-white rounded-lg font-semibold transition hover:bg-green-600">
                                <i class="fas fa-paper-plane mr-2"></i>
                                Publier l'action
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Section Conseils -->
                <div class="mt-8 grid md:grid-cols-3 gap-6">
                    <div class="bg-white rounded-xl p-6 border border-gray-200">
                        <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center mb-4">
                            <i class="fas fa-lightbulb text-blue-500 text-xl"></i>
                        </div>
                        <h3 class="font-semibold text-gray-800 mb-2">Conseil Pro</h3>
                        <p class="text-gray-600 text-sm">Prenez des photos sous différents angles pour mieux illustrer votre action.</p>
                    </div>
                    
                    <div class="bg-white rounded-xl p-6 border border-gray-200">
                        <div class="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center mb-4">
                            <i class="fas fa-chart-line text-green-500 text-xl"></i>
                        </div>
                        <h3 class="font-semibold text-gray-800 mb-2">Impact Visible</h3>
                        <p class="text-gray-600 text-sm">Montrez l'avant/après pour maximiser l'impact de votre publication.</p>
                    </div>
                    
                    <div class="bg-white rounded-xl p-6 border border-gray-200">
                        <div class="w-12 h-12 rounded-full bg-purple-100 flex items-center justify-center mb-4">
                            <i class="fas fa-users text-purple-500 text-xl"></i>
                        </div>
                        <h3 class="font-semibold text-gray-800 mb-2">Engagement Communautaire</h3>
                        <p class="text-gray-600 text-sm">Répondez aux commentaires pour créer du lien avec la communauté.</p>
                    </div>
                </div>
            `;
            
            initializeFormEvents();
        }
        
        function showLoginRequired() {
            const container = document.getElementById('mainContent');
            container.innerHTML = `
                <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-8">
                    <div class="text-center py-12">
                        <div class="w-24 h-24 bg-yellow-100 rounded-full flex items-center justify-center mx-auto mb-6">
                            <i class="fas fa-lock text-yellow-500 text-3xl"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-700 mb-2">Connexion requise</h3>
                        <p class="text-gray-500 mb-6">Votre session a expiré ou vous n'êtes pas connecté.</p>
                        <div class="flex space-x-4 justify-center">
                            <button onclick="window.history.back()" 
                                    class="px-6 py-3 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition">
                                Retour
                            </button>
                            <button onclick="window.location.href='index.jsp'" 
                                    class="px-6 py-3 bg-green-500 text-white rounded-lg hover:bg-green-600 transition font-semibold">
                                Se connecter
                            </button>
                        </div>
                    </div>
                </div>
            `;
        }

        function logout() {
            localStorage.removeItem('jwtToken');
            localStorage.removeItem('currentUser');
            window.location.href = 'index.jsp';
        }

        // Fonctions utilitaires
        function initializeFormEvents() {
            const form = document.getElementById('actionForm');
            if (form) {
                form.addEventListener('submit', function(e) {
                    const token = localStorage.getItem('jwtToken');
                    if (!token || !isTokenValid(token)) {
                        e.preventDefault();
                        alert('Session expirée. Veuillez vous reconnecter.');
                        logout();
                        return;
                    }
                    
                    // Validation des champs
                    const fileInput = document.getElementById('fileInput');
                    const actionType = document.getElementById('actionType');
                    const description = document.getElementById('description');
                    
                    if (!fileInput.files[0]) {
                        e.preventDefault();
                        alert('Veuillez sélectionner un fichier.');
                        return;
                    }
                    
                    if (!actionType.value) {
                        e.preventDefault();
                        alert('Veuillez sélectionner un type d\'action.');
                        return;
                    }
                    
                    if (description.value.trim().length < 10) {
                        e.preventDefault();
                        alert('Veuillez décrire votre action (au moins 10 caractères).');
                        return;
                    }
                    
                    // Feedback utilisateur
                    const submitBtn = document.getElementById('submitBtn');
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Publication en cours...';
                });
            }
        }

        function handleFileSelect(input) {
            const file = input.files[0];
            if (file) {
                const validTypes = ['image/jpeg', 'image/png', 'image/gif', 'video/mp4', 'video/quicktime'];
                const maxSize = 10 * 1024 * 1024;
                
                if (!validTypes.includes(file.type)) {
                    alert('Format de fichier non supporté. Utilisez JPG, PNG, GIF, MP4 ou MOV.');
                    input.value = '';
                    return;
                }
                
                if (file.size > maxSize) {
                    alert('Fichier trop volumineux. Taille maximale: 10MB.');
                    input.value = '';
                    return;
                }
                
                document.getElementById('fileName').textContent = file.name;
                document.getElementById('fileSize').textContent = formatFileSize(file.size);
                document.getElementById('fileInfo').classList.remove('hidden');
            }
        }
        
        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }
        
        function removeFile() {
            document.getElementById('fileInput').value = '';
            document.getElementById('fileInfo').classList.add('hidden');
        }
        
        function updatePoints() {
            const select = document.getElementById('actionType');
            const pointsInput = document.getElementById('points');
            if (select && pointsInput) {
                const selectedOption = select.options[select.selectedIndex];
                const points = selectedOption.getAttribute('data-points') || '';
                pointsInput.value = points;
            }
        }
        
        function updateCharCount() {
            const textarea = document.getElementById('description');
            const charCount = document.getElementById('charCount');
            if (textarea && charCount) {
                const count = textarea.value.length;
                charCount.textContent = count + '/500';
                
                if (count > 450) {
                    charCount.className = 'text-sm text-red-500';
                } else if (count > 400) {
                    charCount.className = 'text-sm text-yellow-500';
                } else {
                    charCount.className = 'text-sm text-gray-500';
                }
            }
        }
    </script>
</body>
</html>