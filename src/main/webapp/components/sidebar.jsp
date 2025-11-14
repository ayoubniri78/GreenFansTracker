<!-- Sidebar -->
<aside
	class="fixed left-0 top-0 h-full w-64 bg-white border-r border-gray-200 shadow-sm z-40">
	<div class="flex flex-col h-full">
		<!-- Sidebar Header -->
		<div class="p-6 border-b border-gray-200">
			<div class="flex items-center space-x-3">
				<div
					class="w-12 h-12 bg-gradient-to-r from-green-400 to-green-600 rounded-xl flex items-center justify-center">
					<i class="fas fa-seedling text-white text-xl"></i>
				</div>
				<div>
					<h2 class="font-bold text-gray-800">Tableau de Bord</h2>
					<p class="text-sm text-green-600">En ligne</p>
				</div>
			</div>
		</div>

		<!-- Navigation -->
		<nav class="flex-1 p-4 space-y-2">
			<!-- Menu Items -->
			<a href="dashboard.jsp"
				class="flex items-center space-x-3 p-3 text-gray-700 hover:bg-green-50 hover:text-green-600 rounded-lg transition group">
				<i
				class="fas fa-home text-lg w-6 text-gray-400 group-hover:text-green-500"></i>
				<span class="font-medium">Accueil</span>
			</a> <a href="ActionController?action=showForm"
				class="flex items-center space-x-3 p-3 text-gray-700 hover:bg-green-50 hover:text-green-600 rounded-lg transition group">
				<i
				class="fas fa-upload text-lg w-6 text-gray-400 group-hover:text-green-500"></i>
				<span class="font-medium">Soumettre une Action</span>
			</a>

			<!-- Lien corrigé pour Mes Actions -->
			<a href="redirect-my-actions.jsp"
				class="flex items-center space-x-3 p-3 text-gray-700 hover:bg-green-50 hover:text-green-600 rounded-lg transition group">
				<i
				class="fas fa-list text-lg w-6 text-gray-400 group-hover:text-green-500"></i>
				<span class="font-medium">Mes Actions</span>
			</a> <a href="ranking.jsp"
				class="flex items-center space-x-3 p-3 text-gray-700 hover:bg-green-50 hover:text-green-600 rounded-lg transition group">
				<i
				class="fas fa-chart-bar text-lg w-6 text-gray-400 group-hover:text-green-500"></i>
				<span class="font-medium">Classement</span>
			</a> <a href="ActionController?action=allMedia"
				class="flex items-center space-x-3 p-3 text-gray-700 hover:bg-green-50 hover:text-green-600 rounded-lg transition group">
				<i
				class="fas fa-users text-lg w-6 text-gray-400 group-hover:text-green-500"></i>
				<span class="font-medium">Communaute</span>
			</a> <a href="rewards.jsp"
				class="flex items-center space-x-3 p-3 text-gray-700 hover:bg-green-50 hover:text-green-600 rounded-lg transition group">
				<i
				class="fas fa-gift text-lg w-6 text-gray-400 group-hover:text-green-500"></i>
				<span class="font-medium">Recompenses</span>
			</a>

			<!-- Divider -->
			<div class="border-t border-gray-200 my-4"></div>

			<!-- Settings -->
			<a href="weather.jsp"
				class="flex items-center space-x-3 p-3 text-gray-700 hover:bg-green-50 hover:text-green-600 rounded-lg transition group">
				<i
				class="fas fa-cloud-sun text-lg w-6 text-gray-400 group-hover:text-green-500"></i>
				<span class="font-medium">Meteo</span>
			</a> <a href="javascript:void(0)" onclick="logout()"
				class="flex items-center space-x-3 p-3 text-gray-700 hover:bg-red-50 hover:text-red-600 rounded-lg transition group">
				<i
				class="fas fa-sign-out-alt text-lg w-6 text-gray-400 group-hover:text-red-500"></i>
				<span class="font-medium">Deconnexion</span>
			</a>
		</nav>

		<!-- Sidebar Footer -->
		
	</div>
</aside>

<script>
	// Fonction de déconnexion
	function logout() {
		if (confirm('Êtes-vous sûr de vouloir vous déconnecter ?')) {
			localStorage.removeItem('jwtToken');
			localStorage.removeItem('userId');
			localStorage.removeItem('currentUser');
			window.location.href = 'index.jsp';
		}
	}

	// Vérifier l'authentification au chargement
	document.addEventListener('DOMContentLoaded', function() {
		const token = localStorage.getItem('jwtToken');
		if (!token) {
			console.log('⚠️ Utilisateur non connecté');
		} else {
			console.log('✅ Utilisateur connecté, token présent');
		}
	});
</script>