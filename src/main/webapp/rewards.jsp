<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Récompenses - Green Fan Tracker</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50 min-h-screen">
    <jsp:include page="components/header.jsp" />
    
    <div class="flex">
        <jsp:include page="components/sidebar.jsp" />
        
        <main class="flex-1 p-6 ml-64">
            <div class="max-w-7xl mx-auto">
                <!-- En-tête de la page -->
                <div class="mb-8">
                    <div class="flex justify-between items-center">
                        <div>
                            <h1 class="text-3xl font-bold text-gray-800">Nos Récompenses</h1>
                            <p class="text-gray-600">Découvrez les prix exceptionnels que vous pouvez gagner</p>
                        </div>
                        <a href="dashboard.jsp" class="bg-gray-500 text-white px-6 py-3 rounded-lg hover:bg-gray-600 transition font-semibold">
                            <i class="fas fa-arrow-left mr-2"></i>Retour à l'accueil
                        </a>
                    </div>
                </div>

                <!-- Section des récompenses -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-8 mb-8">
                    <h2 class="text-3xl font-bold text-center text-gray-800 mb-12">Gagnez en étant Vert !</h2>
                    
                    <div class="grid md:grid-cols-3 gap-8 mb-8">
                        <!-- Premier prix : Visite de Marrakech -->
                        <div class="text-center bg-gradient-to-b from-yellow-50 to-white rounded-2xl p-6 border-2 border-yellow-200 hover:shadow-lg transition">
                            <div class="mb-6 h-80 flex items-center justify-center">
                                <img src="assets/images/prize/firstPrize.png" alt="Visite de Marrakech" class="w-full h-full object-cover rounded-xl">
                            </div>
                            <div class="flex items-center justify-center mb-4">
                                <i class="fas fa-trophy text-yellow-500 text-2xl mr-2"></i>
                                <span class="bg-yellow-500 text-white px-3 py-1 rounded-full text-sm font-bold">1er PRIX</span>
                            </div>
                            <h3 class="text-xl font-bold text-gray-800 mb-2">Visite de Marrakech</h3>
                        </div>
                        
                        <!-- Deuxième prix : Tickets pour la Finale -->
                        <div class="text-center bg-gradient-to-b from-green-50 to-white rounded-2xl p-6 border-2 border-green-200 hover:shadow-lg transition">
                            <div class="mb-6 h-80 flex items-center justify-center">
                                <img src="assets/images/prize/secondePrize.png" alt="Tickets pour la Finale" class="w-full h-full object-cover rounded-xl">
                            </div>
                            <div class="flex items-center justify-center mb-4">
                                <i class="fas fa-medal text-green-500 text-2xl mr-2"></i>
                                <span class="bg-green-500 text-white px-3 py-1 rounded-full text-sm font-bold">2ème PRIX</span>
                            </div>
                            <h3 class="text-xl font-bold text-gray-800 mb-2">Tickets pour la Finale</h3>
                        </div>
                        
                        <!-- Troisième prix : Tenue Officielle -->
                        <div class="text-center bg-gradient-to-b from-red-50 to-white rounded-2xl p-6 border-2 border-red-200 hover:shadow-lg transition">
                            <div class="mb-6 h-80 flex items-center justify-center">
                                <img src="assets/images/prize/3rdPrize.png" alt="Tenue Officielle" class="w-full h-full object-cover rounded-xl">
                            </div>
                            <div class="flex items-center justify-center mb-4">
                                <i class="fas fa-award text-red-500 text-2xl mr-2"></i>
                                <span class="bg-red-500 text-white px-3 py-1 rounded-full text-sm font-bold">3ème PRIX</span>
                            </div>
                            <h3 class="text-xl font-bold text-gray-800 mb-2">Tenue Officielle</h3>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <jsp:include page="components/footer.jsp" />
</body>
</html>