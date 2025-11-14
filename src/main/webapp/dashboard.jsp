<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
// Vérifier si l'utilisateur a un JWT dans localStorage (côté client)
// La vraie vérification se fait via JavaScript
%>
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tableau de Bord - Green Fan Tracker</title>
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50 min-h-screen">
	<jsp:include page="components/header.jsp" />

	<div class="flex">
		<jsp:include page="components/sidebar.jsp" />

		<main class="flex-1 p-6 ml-64">
			<div id="app" class="max-w-7xl mx-auto">
				<!-- Section Accueil Présentative -->
				<div v-if="currentView === 'home'">
					<!-- [Zone 1 : Hero Section] -->
					<div
						class="relative bg-gradient-to-r from-green-600 to-emerald-700 rounded-2xl overflow-hidden mb-8">
						<div class="absolute inset-0 bg-green-800 z-0">
							<!-- Bannière CAN 2025 - Image à ajouter -->
						</div>

						<div class="relative z-10 p-12 text-white">
							<div class="flex items-center justify-between">
								<div class="max-w-2xl">
									<h1 class="text-5xl font-bold mb-4">Green Fan Tracker</h1>
									<p class="text-xl mb-8 opacity-90">
										Le Sport durable commence <span class="relative inline-block">
											ici <img src="images/home.png" alt=""
											class="absolute -top-2 -right-8 w-6 h-6 rounded-full">
										</span>
									</p>
								</div>
								<div
									class="w-64 h-64 bg-white/20 rounded-2xl flex items-center justify-center">
									<!-- Photo à côté de "ici" -->
									<img src="assets/home.png" alt="Sport durable"
										class="w-full h-full object-cover rounded-2xl">
								</div>
							</div>
						</div>
					</div>

					<!-- [Zone 2 : Le Concept] -->
					<div
						class="bg-white rounded-2xl shadow-sm border border-gray-200 p-8 mb-8">
						<h2 class="text-3xl font-bold text-center text-gray-800 mb-12">Comment
							ça marche ?</h2>

						<div class="grid md:grid-cols-3 gap-8">
							<!-- Bloc 1 : Transport Vert -->
							<div class="text-center">
								<div
									class="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
									<i class="fas fa-car-alt text-green-600 text-3xl"></i>
								</div>
								<h3 class="text-xl font-bold text-gray-800 mb-4">Transport
									Vert</h3>
								<p class="text-gray-600">Privilégiez les transports
									écologiques pour vous rendre aux matchs et gagnez des points.</p>
							</div>

							<!-- Bloc 2 : Déchets Zéro -->
							<div class="text-center">
								<div
									class="w-20 h-20 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-6">
									<i class="fas fa-recycle text-blue-600 text-3xl"></i>
								</div>
								<h3 class="text-xl font-bold text-gray-800 mb-4">Déchets
									Zéro</h3>
								<p class="text-gray-600">Adoptez une gestion responsable des
									déchets pendant les événements sportifs.</p>
							</div>

							<!-- Bloc 3 : Communauté -->
							<div class="text-center">
								<div
									class="w-20 h-20 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-6">
									<i class="fas fa-hands-helping text-purple-600 text-3xl"></i>
								</div>
								<h3 class="text-xl font-bold text-gray-800 mb-4">Communauté</h3>
								<p class="text-gray-600">Rejoignez une communauté de fans
									engagés pour un sport plus durable.</p>
							</div>
						</div>
					</div>

					<!-- [Zone 4 : Les Récompenses] -->
					<div
						class="bg-white rounded-2xl shadow-sm border border-gray-200 p-8 mb-8">
						<h2 class="text-3xl font-bold text-center text-gray-800 mb-12">Gagnez
							en étant Vert !</h2>

						<div class="grid md:grid-cols-3 gap-8 mb-8">
							<!-- Prix 1 : Marrakech -->
							<div class="text-center">
								<div
									class="bg-yellow-50 rounded-2xl p-6 mb-4 h-48 flex items-center justify-center border-2 border-yellow-200">
									<div class="text-center text-yellow-600">
										<i class="fas fa-hotel text-4xl mb-3"></i>
										<p class="font-semibold">Séjour Marrakech</p>
									</div>
								</div>
								<h3 class="text-xl font-bold text-gray-800 mb-2">Séjour à
									Marrakech</h3>
								<p class="text-gray-600 text-sm">Week-end écologique pour 2
									personnes</p>
							</div>

							<!-- Prix 2 : Tickets -->
							<div class="text-center">
								<div
									class="bg-green-50 rounded-2xl p-6 mb-4 h-48 flex items-center justify-center border-2 border-green-200">
									<div class="text-center text-green-600">
										<i class="fas fa-ticket-alt text-4xl mb-3"></i>
										<p class="font-semibold">Tickets VIP</p>
									</div>
								</div>
								<h3 class="text-xl font-bold text-gray-800 mb-2">Tickets
									CAN 2025</h3>
								<p class="text-gray-600 text-sm">Placements VIP pour les
									matchs</p>
							</div>

							<!-- Prix 3 : Maillot -->
							<div class="text-center">
								<div
									class="bg-red-50 rounded-2xl p-6 mb-4 h-48 flex items-center justify-center border-2 border-red-200">
									<div class="text-center text-red-600">
										<i class="fas fa-tshirt text-4xl mb-3"></i>
										<p class="font-semibold">Maillot Officiel</p>
									</div>
								</div>
								<h3 class="text-xl font-bold text-gray-800 mb-2">Maillot
									Officiel</h3>
								<p class="text-gray-600 text-sm">Maillot collector de
									l'équipe nationale</p>
							</div>
						</div>



						<div class="text-center">
							<a href="ranking.jsp">
								<button @click="switchView('dashboard')"
									class="bg-green-500 text-white px-8 py-4 rounded-lg font-bold text-lg hover:bg-green-600 transition">
									Voir le classement</button>
							</a>
						</div>

					</div>
				</div>

				<!-- Vue Tableau de Bord Original -->
				<div v-if="currentView === 'dashboard'">
					<!-- En-tête du tableau de bord -->
					<div class="mb-8">
						<div class="flex justify-between items-center">
							<div>
								<h1 class="text-3xl font-bold text-gray-800">Tableau de
									Bord</h1>
								<p class="text-gray-600">Vos actions écologiques et
									statistiques</p>
							</div>
							<div class="flex space-x-4">
								<button @click="switchView('home')"
									class="bg-gray-500 text-white px-6 py-3 rounded-lg hover:bg-gray-600 transition font-semibold">
									<i class="fas fa-home mr-2"></i>Retour à l'accueil
								</button>
								<a href="submit-action.jsp"
									class="bg-green-500 text-white px-6 py-3 rounded-lg hover:bg-green-600 transition font-semibold">
									<i class="fas fa-plus mr-2"></i>Nouvelle Action
								</a>
							</div>
						</div>
					</div>

					<!-- Statistiques rapides -->
					<div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
						<div
							class="bg-white rounded-xl p-6 shadow-sm border border-gray-200">
							<div class="flex items-center justify-between">
								<div>
									<p class="text-gray-500 text-sm">Points Totaux</p>
									<p class="text-2xl font-bold text-gray-800">{{ totalPoints
										}}</p>
								</div>
								<div
									class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center">
									<i class="fas fa-star text-green-600 text-xl"></i>
								</div>
							</div>
						</div>

						<div
							class="bg-white rounded-xl p-6 shadow-sm border border-gray-200">
							<div class="flex items-center justify-between">
								<div>
									<p class="text-gray-500 text-sm">Actions Validées</p>
									<p class="text-2xl font-bold text-gray-800">{{
										validatedActions }}</p>
								</div>
								<div
									class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
									<i class="fas fa-check-circle text-blue-600 text-xl"></i>
								</div>
							</div>
						</div>

						<div
							class="bg-white rounded-xl p-6 shadow-sm border border-gray-200">
							<div class="flex items-center justify-between">
								<div>
									<p class="text-gray-500 text-sm">En Attente</p>
									<p class="text-2xl font-bold text-gray-800">{{
										pendingActions }}</p>
								</div>
								<div
									class="w-12 h-12 bg-yellow-100 rounded-full flex items-center justify-center">
									<i class="fas fa-clock text-yellow-600 text-xl"></i>
								</div>
							</div>
						</div>

						<div
							class="bg-white rounded-xl p-6 shadow-sm border border-gray-200">
							<div class="flex items-center justify-between">
								<div>
									<p class="text-gray-500 text-sm">Classement</p>
									<p class="text-2xl font-bold text-gray-800">#{{ userRank }}</p>
								</div>
								<div
									class="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center">
									<i class="fas fa-trophy text-purple-600 text-xl"></i>
								</div>
							</div>
						</div>
					</div>

					<!-- Filtres et recherche -->
					<div
						class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 mb-6">
						<div
							class="flex flex-col md:flex-row md:items-center md:justify-between space-y-4 md:space-y-0">
							<div class="flex space-x-4">
								<button v-for="filter in filters" :key="filter.value"
									@click="setFilter(filter.value)"
									:class="currentFilter === filter.value 
                                        ? 'bg-green-500 text-white' 
                                        : 'bg-gray-100 text-gray-700 hover:bg-gray-200'"
									class="px-4 py-2 rounded-lg font-medium transition">
									{{ filter.label }}</button>
							</div>

							<div class="relative">
								<input type="text" v-model="searchQuery"
									placeholder="Rechercher une action..."
									class="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 w-full md:w-64">
								<i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
							</div>
						</div>
					</div>

					<!-- Liste des actions -->
					<div
						class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
						<div v-if="loading" class="p-8 text-center">
							<i class="fas fa-spinner fa-spin text-2xl text-green-500 mb-4"></i>
							<p class="text-gray-600">Chargement des actions...</p>
						</div>

						<div v-else-if="filteredActions.length === 0"
							class="p-8 text-center">
							<i class="fas fa-seedling text-4xl text-gray-300 mb-4"></i>
							<h3 class="text-lg font-semibold text-gray-800 mb-2">Aucune
								action trouvée</h3>
							<p class="text-gray-600 mb-4">Commencez par soumettre votre
								première action écologique!</p>
							<a href="submit-action.jsp"
								class="inline-block bg-green-500 text-white px-6 py-2 rounded-lg hover:bg-green-600 transition">
								Soumettre une action </a>
						</div>

						<div v-else class="divide-y divide-gray-200">
							<div v-for="action in filteredActions" :key="action.id"
								class="p-6 hover:bg-gray-50 transition">
								<div class="flex items-start space-x-4">
									<!-- Image de l'action -->
									<div class="flex-shrink-0">
										<div
											class="w-16 h-16 bg-gray-200 rounded-lg flex items-center justify-center">
											<template v-if="action.mediaFileName">
												<img :src="getMediaUrl(action.mediaFilePath)"
													:alt="action.type"
													class="w-16 h-16 rounded-lg object-cover">
											</template>
											<template v-else>
												<i class="fas fa-leaf text-gray-400 text-xl"></i>
											</template>
										</div>
									</div>

									<!-- Détails de l'action -->
									<div class="flex-1 min-w-0">
										<div class="flex items-center justify-between mb-2">
											<h3 class="text-lg font-semibold text-gray-800 truncate">
												{{ action.type }}</h3>
											<span class="flex items-center space-x-2"> <span
												class="bg-green-100 text-green-800 px-2 py-1 rounded-full text-sm font-medium">
													{{ action.points }} points </span> <span
												:class="getStatusBadgeClass(action.status)"
												class="px-2 py-1 rounded-full text-sm font-medium">
													{{ getStatusText(action.status) }} </span>
											</span>
										</div>

										<p class="text-gray-600 mb-3 line-clamp-2">{{
											action.details }}</p>

										<div
											class="flex items-center justify-between text-sm text-gray-500">
											<div class="flex items-center space-x-4">
												<span class="flex items-center"> <i
													class="fas fa-calendar mr-1"></i> {{
													formatDate(action.submissionDate) }}
												</span> <span v-if="action.votes" class="flex items-center">
													<i class="fas fa-thumbs-up mr-1"></i> {{ action.votes.valid
													|| 0 }} votes
												</span>
											</div>

											<div class="flex space-x-2">
												<button @click="viewAction(action.id)"
													class="text-green-600 hover:text-green-700 font-medium">
													Voir détails</button>
												<button v-if="action.status === 'PENDING'"
													@click="editAction(action.id)"
													class="text-blue-600 hover:text-blue-700 font-medium ml-4">
													Modifier</button>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>

						<!-- Pagination -->
						<div v-if="filteredActions.length > 0"
							class="px-6 py-4 border-t border-gray-200">
							<div class="flex items-center justify-between">
								<p class="text-sm text-gray-700">Affichage de {{
									Math.min((currentPage - 1) * itemsPerPage + 1,
									filteredActions.length) }} à {{ Math.min(currentPage *
									itemsPerPage, filteredActions.length) }} sur {{
									filteredActions.length }} actions</p>
								<div class="flex space-x-2">
									<button @click="prevPage" :disabled="currentPage === 1"
										:class="currentPage === 1 ? 'opacity-50 cursor-not-allowed' : 'hover:bg-gray-200'"
										class="px-3 py-1 border border-gray-300 rounded-md text-gray-700">
										Précédent</button>
									<button @click="nextPage" :disabled="currentPage >= totalPages"
										:class="currentPage >= totalPages ? 'opacity-50 cursor-not-allowed' : 'hover:bg-gray-200'"
										class="px-3 py-1 border border-gray-300 rounded-md text-gray-700">
										Suivant</button>
								</div>
							</div>
						</div>
					</div>

					<!-- Actions récentes de la communauté -->
					<div class="mt-8">
						<h2 class="text-2xl font-bold text-gray-800 mb-4">Actions de
							la communauté</h2>
						<div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
							<div v-for="communityAction in communityActions"
								:key="communityAction.id"
								class="bg-white rounded-xl shadow-sm border border-gray-200 p-4 hover:shadow-md transition">
								<div class="flex items-center space-x-3 mb-3">
									<div
										class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
										<i class="fas fa-user text-green-600"></i>
									</div>
									<div>
										<p class="font-medium text-gray-800">Utilisateur #{{ communityAction.supporterId }}</p>
										<p class="text-xs text-gray-500">{{
											formatDate(communityAction.submissionDate) }}</p>
									</div>
								</div>
								<h4 class="font-semibold text-gray-800 mb-2">{{
									communityAction.type }}</h4>
								<p class="text-gray-600 text-sm line-clamp-2">{{
									communityAction.details }}</p>
								<div class="flex justify-between items-center mt-3">
									<span
										class="bg-green-100 text-green-800 px-2 py-1 rounded-full text-xs font-medium">
										+{{ communityAction.points }} pts </span> <span
										class="text-gray-500 text-xs"> {{
										communityAction.votes?.valid || 0 }} 👍 </span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</main>
	</div>

	<jsp:include page="components/footer.jsp" />

	<script>
        const { createApp, ref, computed, onMounted } = Vue;
        
        createApp({
            setup() {
                const currentView = ref('home');
                
                // Données existantes du tableau de bord
                const actions = ref([]);
                const communityActions = ref([]);
                const loading = ref(true);
                const currentFilter = ref('all');
                const searchQuery = ref('');
                const currentPage = ref(1);
                const itemsPerPage = ref(10);
                
                // Statistiques
                const totalPoints = ref(0);
                const validatedActions = ref(0);
                const pendingActions = ref(0);
                const userRank = ref(1);
                
                const filters = [
                    { label: 'Toutes', value: 'all' },
                    { label: 'Validées', value: 'VALIDATED' },
                    { label: 'En attente', value: 'PENDING' },
                    { label: 'Rejetées', value: 'REJECTED' }
                ];
                
                const jwtToken = localStorage.getItem('jwtToken');
                
                if (!jwtToken) {
                    window.location.href = 'index.jsp';
                }
                
                // Fonction pour changer de vue
                const switchView = (view) => {
                    currentView.value = view;
                };
                
                // Charger les actions de l'utilisateur
                const loadUserActions = async () => {
                    try {
                        const response = await fetch('ActionController?action=getUserActions', {
                            headers: {
                                'Authorization': 'Bearer ' + jwtToken
                            }
                        });
                        
                        if (response.ok) {
                            const data = await response.json();
                            actions.value = data;
                            calculateStats(data);
                        } else {
                            console.error('Erreur chargement actions');
                        }
                    } catch (error) {
                        console.error('Erreur:', error);
                    } finally {
                        loading.value = false;
                    }
                };
                
                // Charger les actions de la communauté
                const loadCommunityActions = async () => {
                    try {
                        const response = await fetch('ActionController?action=getCommunityActions');
                        if (response.ok) {
                            communityActions.value = await response.json();
                        }
                    } catch (error) {
                        console.error('Erreur chargement communauté:', error);
                    }
                };
                
                // Calculer les statistiques
                const calculateStats = (actionsList) => {
                    totalPoints.value = actionsList
                        .filter(action => action.status === 'VALIDATED')
                        .reduce((sum, action) => sum + action.points, 0);
                    
                    validatedActions.value = actionsList.filter(action => action.status === 'VALIDATED').length;
                    pendingActions.value = actionsList.filter(action => action.status === 'PENDING').length;
                };
                
                // Filtrage et recherche
                const filteredActions = computed(() => {
                    let filtered = actions.value;
                    
                    // Filtre par statut
                    if (currentFilter.value !== 'all') {
                        filtered = filtered.filter(action => action.status === currentFilter.value);
                    }
                    
                    // Recherche
                    if (searchQuery.value) {
                        const query = searchQuery.value.toLowerCase();
                        filtered = filtered.filter(action => 
                            action.type.toLowerCase().includes(query) ||
                            action.details.toLowerCase().includes(query)
                        );
                    }
                    
                    return filtered;
                });
                
                // Pagination
                const totalPages = computed(() => Math.ceil(filteredActions.value.length / itemsPerPage.value));
                const paginatedActions = computed(() => {
                    const start = (currentPage.value - 1) * itemsPerPage.value;
                    const end = start + itemsPerPage.value;
                    return filteredActions.value.slice(start, end);
                });
                
                const nextPage = () => {
                    if (currentPage.value < totalPages.value) {
                        currentPage.value++;
                    }
                };
                
                const prevPage = () => {
                    if (currentPage.value > 1) {
                        currentPage.value--;
                    }
                };
                
                const setFilter = (filter) => {
                    currentFilter.value = filter;
                    currentPage.value = 1;
                };
                
                // Utilitaires
                const getStatusBadgeClass = (status) => {
                    switch (status) {
                        case 'VALIDATED': return 'bg-green-100 text-green-800';
                        case 'PENDING': return 'bg-yellow-100 text-yellow-800';
                        case 'REJECTED': return 'bg-red-100 text-red-800';
                        default: return 'bg-gray-100 text-gray-800';
                    }
                };
                
                const getStatusText = (status) => {
                    switch (status) {
                        case 'VALIDATED': return 'Validée';
                        case 'PENDING': return 'En attente';
                        case 'REJECTED': return 'Rejetée';
                        default: return status;
                    }
                };
                
                const formatDate = (dateString) => {
                    return new Date(dateString).toLocaleDateString('fr-FR');
                };
                
                const getMediaUrl = (filePath) => {
                    return filePath ? filePath.replace('/home/ayoub/GreenFansTracker/', './') : '';
                };
                
                const viewAction = (actionId) => {
                    window.location.href = `view-action.jsp?id=${actionId}`;
                };
                
                const editAction = (actionId) => {
                    window.location.href = `edit-action.jsp?id=${actionId}`;
                };
                
                // Initialisation
                onMounted(() => {
                    loadUserActions();
                    loadCommunityActions();
                });
                
                return {
                    currentView,
                    actions: paginatedActions,
                    communityActions,
                    loading,
                    currentFilter,
                    searchQuery,
                    currentPage,
                    totalPages,
                    filters,
                    totalPoints,
                    validatedActions,
                    pendingActions,
                    userRank,
                    switchView,
                    setFilter,
                    nextPage,
                    prevPage,
                    getStatusBadgeClass,
                    getStatusText,
                    formatDate,
                    getMediaUrl,
                    viewAction,
                    editAction
                };
            }
        }).mount('#app');
    </script>
</body>
</html>