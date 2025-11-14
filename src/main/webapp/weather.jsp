<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Météo - Green Fan Tracker</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50 min-h-screen">
    <jsp:include page="components/header.jsp" />
    
    <div class="flex">
        <jsp:include page="components/sidebar.jsp" />
        
        <main class="flex-1 p-6 ml-64">
            <div id="app" class="max-w-7xl mx-auto">
                <!-- En-tête de la page -->
                <div class="mb-8">
                    <div class="flex justify-between items-center">
                        <div>
                            <h1 class="text-3xl font-bold text-gray-800">Météo des Stades</h1>
                            <p class="text-gray-600">Conditions météo et qualité de l'air des grands stades marocains</p>
                        </div>
                        <a href="dashboard.jsp" class="bg-gray-500 text-white px-6 py-3 rounded-lg hover:bg-gray-600 transition font-semibold">
                            <i class="fas fa-arrow-left mr-2"></i>Retour à l'accueil
                        </a>
                    </div>
                </div>

                <!-- Sélecteur de stade -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 mb-8">
                    <div class="flex items-center justify-between">
                        <h2 class="text-xl font-semibold text-gray-800">Sélectionnez un stade</h2>
                        <select v-model="selectedStadium" @change="loadWeatherData" class="border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-green-500 focus:border-green-500">
                            <option v-for="stadium in stadiums" :key="stadium.id" :value="stadium.id">{{ stadium.name }}</option>
                        </select>
                    </div>
                </div>

                <!-- Carte principale météo -->
                <div class="grid lg:grid-cols-3 gap-8 mb-8">
                    <!-- Carte météo principale -->
                    <div class="lg:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
                        <div v-if="loading" class="flex items-center justify-center h-64">
                            <i class="fas fa-spinner fa-spin text-3xl text-green-500 mr-3"></i>
                            <span class="text-gray-600">Chargement des données météo...</span>
                        </div>
                        
                        <div v-else-if="currentWeather" class="space-y-6">
                            <!-- En-tête météo -->
                            <div class="flex items-center justify-between">
                                <div>
                                    <h2 class="text-2xl font-bold text-gray-800">{{ selectedStadiumName }}</h2>
                                    <p class="text-gray-600">{{ currentWeather.location }}</p>
                                </div>
                                <div class="text-right">
                                    <p class="text-4xl font-bold text-gray-800">{{ currentWeather.temperature }}°C</p>
                                    <p class="text-gray-600">{{ currentWeather.condition }}</p>
                                </div>
                            </div>

                            <!-- Icone météo et détails -->
                            <div class="flex items-center justify-between py-4">
                                <div class="flex items-center space-x-4">
                                    <div class="w-20 h-20 bg-blue-50 rounded-full flex items-center justify-center">
                                        <i :class="getWeatherIcon(currentWeather.condition)" class="text-3xl text-blue-500"></i>
                                    </div>
                                    <div>
                                        <p class="text-lg font-semibold text-gray-800">{{ currentWeather.condition }}</p>
                                        <p class="text-gray-600">Ressenti {{ currentWeather.feelsLike }}°C</p>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <p class="text-sm text-gray-600">Dernière mise à jour</p>
                                    <p class="font-semibold text-gray-800">{{ currentWeather.lastUpdate }}</p>
                                </div>
                            </div>

                            <!-- Statistiques météo -->
                            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 pt-4 border-t border-gray-200">
                                <div class="text-center">
                                    <i class="fas fa-wind text-gray-400 text-xl mb-2"></i>
                                    <p class="text-sm text-gray-600">Vent</p>
                                    <p class="font-semibold text-gray-800">{{ currentWeather.windSpeed }} km/h</p>
                                </div>
                                <div class="text-center">
                                    <i class="fas fa-tint text-gray-400 text-xl mb-2"></i>
                                    <p class="text-sm text-gray-600">Humidité</p>
                                    <p class="font-semibold text-gray-800">{{ currentWeather.humidity }}%</p>
                                </div>
                                <div class="text-center">
                                    <i class="fas fa-compress-arrows-alt text-gray-400 text-xl mb-2"></i>
                                    <p class="text-sm text-gray-600">Pression</p>
                                    <p class="font-semibold text-gray-800">{{ currentWeather.pressure }} hPa</p>
                                </div>
                                <div class="text-center">
                                    <i class="fas fa-eye text-gray-400 text-xl mb-2"></i>
                                    <p class="text-sm text-gray-600">Visibilité</p>
                                    <p class="font-semibold text-gray-800">{{ currentWeather.visibility }} km</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Carte qualité de l'air -->
                    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
                        <h3 class="text-xl font-bold text-gray-800 mb-4">Qualité de l'Air</h3>
                        
                        <div v-if="loading" class="flex items-center justify-center h-48">
                            <i class="fas fa-spinner fa-spin text-2xl text-green-500"></i>
                        </div>
                        
                        <div v-else-if="airQuality" class="space-y-6">
                            <!-- Indice principal -->
                            <div class="text-center">
                                <div class="w-24 h-24 rounded-full flex items-center justify-center mx-auto mb-3" :class="getAirQualityColor(airQuality.aqi)">
                                    <span class="text-2xl font-bold text-white">{{ airQuality.aqi }}</span>
                                </div>
                                <p class="text-lg font-semibold" :class="getAirQualityTextColor(airQuality.aqi)">{{ airQuality.level }}</p>
                                <p class="text-sm text-gray-600">Indice de qualité de l'air</p>
                            </div>

                            <!-- Polluants principaux -->
                            <div class="space-y-3">
                                <h4 class="font-semibold text-gray-800">Polluants principaux</h4>
                                <div class="space-y-2">
                                    <div v-for="pollutant in airQuality.mainPollutants" :key="pollutant.name" class="flex justify-between items-center">
                                        <span class="text-sm text-gray-600">{{ pollutant.name }}</span>
                                        <span class="font-semibold" :class="getPollutantColor(pollutant.value)">{{ pollutant.value }} µg/m³</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Recommandations -->
                            <div class="bg-blue-50 rounded-lg p-4">
                                <h4 class="font-semibold text-blue-800 mb-2">Recommandations</h4>
                                <p class="text-sm text-blue-700">{{ airQuality.recommendation }}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Prévisions sur 5 jours -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
                    <h3 class="text-xl font-bold text-gray-800 mb-6">Prévisions sur 5 jours</h3>
                    
                    <div v-if="loading" class="flex justify-center py-8">
                        <i class="fas fa-spinner fa-spin text-2xl text-green-500"></i>
                    </div>
                    
                    <div v-else class="grid grid-cols-2 md:grid-cols-5 gap-4">
                        <div v-for="day in forecast" :key="day.date" class="text-center bg-gray-50 rounded-lg p-4">
                            <p class="font-semibold text-gray-800 mb-2">{{ day.day }}</p>
                            <p class="text-sm text-gray-600 mb-2">{{ day.date }}</p>
                            <div class="w-12 h-12 bg-white rounded-full flex items-center justify-center mx-auto mb-2">
                                <i :class="getWeatherIcon(day.condition)" class="text-xl text-blue-500"></i>
                            </div>
                            <p class="text-lg font-bold text-gray-800">{{ day.maxTemp }}°</p>
                            <p class="text-sm text-gray-600">{{ day.minTemp }}°</p>
                            <p class="text-xs text-gray-500 mt-1">{{ day.condition }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <jsp:include page="components/footer.jsp" />

    <script>
        const { createApp, ref, onMounted } = Vue;
        
        createApp({
            setup() {
                const stadiums = ref([
                    { id: 'complexe-mohammed-vi', name: 'Complexe Mohammed VI - Rabat' },
                    { id: 'stade-adrar', name: 'Stade Adrar - Agadir' },
                    { id: 'stade-marrakech', name: 'Stade de Marrakech - Marrakech' },
                    { id: 'grand-stade-tanger', name: 'Grand Stade de Tanger - Tanger' },
                    { id: 'stade-fes', name: 'Stade de Fès - Fès' },
                    { id: 'stade-casablanca', name: 'Stade Mohammed V - Casablanca' }
                ]);
                
                const selectedStadium = ref('complexe-mohammed-vi');
                const selectedStadiumName = ref('Complexe Mohammed VI - Rabat');
                const currentWeather = ref(null);
                const airQuality = ref(null);
                const forecast = ref([]);
                const loading = ref(false);
                
                // Fonction pour charger les données météo
                const loadWeatherData = async () => {
                    loading.value = true;
                    
                    // Trouver le nom du stade sélectionné
                    const stadium = stadiums.value.find(s => s.id === selectedStadium.value);
                    selectedStadiumName.value = stadium ? stadium.name : '';
                    
                    try {
                        // Simulation de données météo (remplacer par appel API réel)
                        await new Promise(resolve => setTimeout(resolve, 1000));
                        
                        // Données météo simulées
                        currentWeather.value = {
                            location: selectedStadiumName.value,
                            temperature: 22,
                            feelsLike: 24,
                            condition: 'Ensoleillé',
                            windSpeed: 15,
                            humidity: 65,
                            pressure: 1013,
                            visibility: 10,
                            lastUpdate: new Date().toLocaleTimeString('fr-FR')
                        };
                        
                        // Données qualité de l'air simulées
                        airQuality.value = {
                            aqi: 45,
                            level: 'Bon',
                            mainPollutants: [
                                { name: 'PM2.5', value: 12 },
                                { name: 'PM10', value: 20 },
                                { name: 'NO2', value: 25 },
                                { name: 'O3', value: 45 }
                            ],
                            recommendation: 'Qualité de l\'air excellente. Conditions idéales pour les activités en extérieur.'
                        };
                        
                        // Prévisions simulées
                        forecast.value = [
                            { day: 'Auj', date: new Date().toLocaleDateString('fr-FR'), condition: 'Ensoleillé', maxTemp: 22, minTemp: 15 },
                            { day: 'Dem', date: new Date(Date.now() + 86400000).toLocaleDateString('fr-FR'), condition: 'Partiellement nuageux', maxTemp: 20, minTemp: 14 },
                            { day: 'Mer', date: new Date(Date.now() + 172800000).toLocaleDateString('fr-FR'), condition: 'Nuageux', maxTemp: 18, minTemp: 13 },
                            { day: 'Jeu', date: new Date(Date.now() + 259200000).toLocaleDateString('fr-FR'), condition: 'Pluie légère', maxTemp: 16, minTemp: 12 },
                            { day: 'Ven', date: new Date(Date.now() + 345600000).toLocaleDateString('fr-FR'), condition: 'Orageux', maxTemp: 17, minTemp: 11 }
                        ];
                        
                    } catch (error) {
                        console.error('Erreur chargement météo:', error);
                    } finally {
                        loading.value = false;
                    }
                };
                
                // Fonction pour obtenir l'icône météo
                const getWeatherIcon = (condition) => {
                    const icons = {
                        'Ensoleillé': 'fas fa-sun',
                        'Partiellement nuageux': 'fas fa-cloud-sun',
                        'Nuageux': 'fas fa-cloud',
                        'Pluie légère': 'fas fa-cloud-rain',
                        'Pluie': 'fas fa-cloud-showers-heavy',
                        'Orageux': 'fas fa-bolt',
                        'Brouillard': 'fas fa-smog'
                    };
                    return icons[condition] || 'fas fa-cloud';
                };
                
                // Fonction pour la couleur de la qualité de l'air
                const getAirQualityColor = (aqi) => {
                    if (aqi <= 50) return 'bg-green-500';
                    if (aqi <= 100) return 'bg-yellow-500';
                    if (aqi <= 150) return 'bg-orange-500';
                    if (aqi <= 200) return 'bg-red-500';
                    return 'bg-purple-500';
                };
                
                const getAirQualityTextColor = (aqi) => {
                    if (aqi <= 50) return 'text-green-600';
                    if (aqi <= 100) return 'text-yellow-600';
                    if (aqi <= 150) return 'text-orange-600';
                    if (aqi <= 200) return 'text-red-600';
                    return 'text-purple-600';
                };
                
                const getPollutantColor = (value) => {
                    if (value <= 25) return 'text-green-600';
                    if (value <= 50) return 'text-yellow-600';
                    if (value <= 75) return 'text-orange-600';
                    return 'text-red-600';
                };
                
                // Chargement initial
                onMounted(() => {
                    loadWeatherData();
                });
                
                return {
                    stadiums,
                    selectedStadium,
                    selectedStadiumName,
                    currentWeather,
                    airQuality,
                    forecast,
                    loading,
                    loadWeatherData,
                    getWeatherIcon,
                    getAirQualityColor,
                    getAirQualityTextColor,
                    getPollutantColor
                };
            }
        }).mount('#app');
    </script>
</body>
</html>