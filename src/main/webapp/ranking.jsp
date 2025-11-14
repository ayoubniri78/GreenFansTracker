<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Classement des Supporters - Green Fan Tracker</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50 min-h-screen">
    <jsp:include page="components/header.jsp" />

    <div class="flex">
        <jsp:include page="components/sidebar.jsp" />

        <main class="flex-1 p-6 ml-64">
            <div class="max-w-6xl mx-auto">
                
                <!-- En-tête -->
                <div class="mb-8">
                    <div class="flex justify-between items-center mb-6">
                        <div>
                            <h1 class="text-3xl font-bold text-gray-800 mb-2">
                                <i class="fas fa-trophy mr-3 text-yellow-500"></i>
                                Classement des Supporters
                            </h1>
                            <p class="text-gray-600">Découvrez le classement basé sur les actions écologiques validées</p>
                        </div>
                        <div class="flex space-x-4">
                            <button onclick="loadRanking()" 
                                    class="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition flex items-center">
                                <i class="fas fa-sync-alt mr-2"></i>Actualiser
                            </button>
                            <button onclick="generateScores()" 
                                    class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition flex items-center">
                                <i class="fas fa-bolt mr-2"></i>Générer Scores
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Contenu du classement -->
                <div id="rankingResults">
                    <!-- État de chargement -->
                    <div id="loading" class="text-center py-12 hidden">
                        <div class="w-12 h-12 border-4 border-green-500 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
                        <p class="text-gray-600">Chargement du classement...</p>
                    </div>

                    <!-- État vide -->
                    <div id="emptyState" class="text-center py-12 hidden">
                        <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                            <i class="fas fa-trophy text-gray-400 text-3xl"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-700 mb-2">Aucun score disponible</h3>
                        <p class="text-gray-500 mb-6">Le classement est vide. Générez les scores pour créer le classement.</p>
                        <button onclick="generateScores()" 
                                class="inline-flex items-center px-6 py-3 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition font-semibold">
                            <i class="fas fa-bolt mr-2"></i>
                            Générer les Scores
                        </button>
                    </div>

                    <!-- Tableau du classement -->
                    <div id="rankingTable" class="hidden">
                        <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
                            <table class="w-full">
                                <thead class="bg-gray-50 border-b border-gray-200">
                                    <tr>
                                        <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Position</th>
                                        <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Supporter</th>
                                        <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Score</th>
                                        <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">ID</th>
                                    </tr>
                                </thead>
                                <tbody id="rankingBody" class="divide-y divide-gray-200">
                                    <!-- Les données seront chargées ici par JavaScript -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Charger le classement au démarrage
        window.onload = loadRanking;

        function showLoading() {
            document.getElementById('loading').classList.remove('hidden');
            document.getElementById('emptyState').classList.add('hidden');
            document.getElementById('rankingTable').classList.add('hidden');
        }

        function hideLoading() {
            document.getElementById('loading').classList.add('hidden');
        }

        function loadRanking() {
            showLoading();
            
            fetch('ranking?action=getRanking')
                .then(response => response.json())
                .then(data => {
                    hideLoading();
                    if (data.success) {
                        if (data.ranking.length > 0) {
                            displayRanking(data.ranking);
                        } else {
                            showEmptyState();
                        }
                    } else {
                        showNotification('❌ Erreur: ' + data.error, 'error');
                        showEmptyState();
                    }
                })
                .catch(error => {
                    hideLoading();
                    console.error('Erreur:', error);
                    showNotification('❌ Erreur réseau lors du chargement', 'error');
                    showEmptyState();
                });
        }

        function displayRanking(ranking) {
            const tbody = document.getElementById('rankingBody');
            tbody.innerHTML = '';
            
            ranking.forEach(item => {
                const row = document.createElement('tr');
                
                // Styles pour les 3 premiers
                let positionClass = '';
                let trophyIcon = '';
                
                if (item.position === 1) {
                    positionClass = 'bg-yellow-50 border-l-4 border-yellow-500';
                    trophyIcon = '🥇';
                } else if (item.position === 2) {
                    positionClass = 'bg-gray-50 border-l-4 border-gray-400';
                    trophyIcon = '🥈';
                } else if (item.position === 3) {
                    positionClass = 'bg-orange-50 border-l-4 border-orange-700';
                    trophyIcon = '🥉';
                } else {
                    positionClass = 'hover:bg-gray-50';
                }
                
                row.className = positionClass;
                
                row.innerHTML = `
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="flex items-center">
                            <span class="text-lg font-bold ${item.position <= 3 ? 'text-gray-800' : 'text-gray-600'}">
                                ${trophyIcon} ${item.position}
                            </span>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="flex items-center">
                            <div class="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center mr-3">
                                <i class="fas fa-user text-green-500 text-sm"></i>
                            </div>
                            <div>
                                <div class="text-sm font-medium text-gray-900">${item.username}</div>
                                <div class="text-sm text-gray-500">Supporter écologique</div>
                            </div>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-green-100 text-green-800">
                            <i class="fas fa-star mr-1"></i>
                            ${item.score} points
                        </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        #${item.supporterId}
                    </td>
                `;
                tbody.appendChild(row);
            });
            
            document.getElementById('rankingTable').classList.remove('hidden');
            document.getElementById('emptyState').classList.add('hidden');
        }

        function showEmptyState() {
            document.getElementById('rankingTable').classList.add('hidden');
            document.getElementById('emptyState').classList.remove('hidden');
        }

        function generateScores() {
            if(confirm('🚀 Générer les scores depuis les actions validées ?\n\nCette opération va calculer les scores de tous les supporters.')) {
                showLoading();
                
                fetch('ranking?action=generateScores')
                    .then(response => response.json())
                    .then(data => {
                        hideLoading();
                        if(data.success) {
                            showNotification('✅ Scores générés avec succès !', 'success');
                            loadRanking(); // Recharger le classement
                        } else {
                            showNotification('❌ Erreur: ' + data.error, 'error');
                        }
                    })
                    .catch(error => {
                        hideLoading();
                        showNotification('❌ Erreur réseau', 'error');
                    });
            }
        }

        function showNotification(message, type) {
            // Créer une notification temporaire
            const notification = document.createElement('div');
            const bgColor = type === 'success' ? 'bg-green-500' : 'bg-red-500';
            
            notification.className = `fixed top-4 right-4 p-4 rounded-lg shadow-lg text-white ${bgColor} z-50`;
            notification.innerHTML = `
                <div class="flex items-center">
                    <i class="fas fa-${type === 'success' ? 'check' : 'exclamation-triangle'} mr-2"></i>
                    <span>${message}</span>
                </div>
            `;
            
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.remove();
            }, 4000);
        }
    </script>
</body>
</html>