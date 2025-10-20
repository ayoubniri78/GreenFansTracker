<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Green Fan Tracker - Marhba bik!</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gradient-to-br from-green-50 to-emerald-100 min-h-screen">
    <div id="app" class="min-h-screen flex items-center justify-center p-4">
        <!-- Container Principal -->
        <div class="max-w-6xl w-full grid grid-cols-1 lg:grid-cols-2 gap-8 items-center">
            
            <!-- Section Gauche - Hero -->
            <div class="text-center lg:text-left space-y-6">
                <h1 class="text-5xl lg:text-6xl font-bold text-green-800">
                    Green Fan <span class="text-emerald-600">Tracker</span>
                </h1>
                <p class="text-xl text-gray-600">
                    <span class="text-2xl text-emerald-600 font-arabic">ⵎⴰⵕⵀⴱⴰ ⴱⵉⴽ!</span><br>
                    Rejoins la communauté éco-responsable des supporters engagés
                </p>
                
                <!-- Image Coupe d'Afrique des Nations -->
                <div class="bg-white rounded-2xl p-4 shadow-lg">
                    <img src="assets/images/login/image_du_coupe_bg_vert.jpg" 
                         alt="Coupe d'Afrique des Nations 2025 Maroc" 
                         class="w-full h-auto rounded-xl">
                </div>
            </div>

            <!-- Section Droite - Formulaire -->
            <div class="bg-white rounded-3xl shadow-2xl p-8 lg:p-10">
                <!-- Switch Login/Register -->
                <div class="flex bg-gray-100 rounded-2xl p-1 mb-8">
                    <button 
                        @click="currentForm = 'login'"
                        :class="currentForm === 'login' 
                            ? 'bg-green-600 text-white shadow-lg transform scale-105' 
                            : 'text-gray-600 hover:text-green-700'"
                        class="flex-1 py-3 px-6 rounded-2xl font-semibold transition-all duration-300"
                    >
                        <i class="fas fa-sign-in-alt mr-2"></i>Se connecter
                    </button>
                    <button 
                        @click="currentForm = 'register'"
                        :class="currentForm === 'register' 
                            ? 'bg-green-600 text-white shadow-lg transform scale-105' 
                            : 'text-gray-600 hover:text-green-700'"
                        class="flex-1 py-3 px-6 rounded-2xl font-semibold transition-all duration-300"
                    >
                        <i class="fas fa-user-plus mr-2"></i>S'inscrire
                    </button>
                </div>

                <!-- Formulaire Login -->
                <div v-if="currentForm === 'login'" class="space-y-6 animate-fade-in">
                    <div>
                        <h2 class="text-3xl font-bold text-green-800 mb-2">Marhba bik!</h2>
                        <p class="text-gray-600">Content de te revoir dans notre communauté</p>
                    </div>
                    
                    <form @submit.prevent="handleLogin" class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                <i class="fas fa-envelope mr-2 text-green-600"></i>Email
                            </label>
                            <input 
                                v-model="loginForm.email"
                                type="email" 
                                required
                                class="w-full px-4 py-3 border border-gray-300 rounded-2xl focus:ring-2 focus:ring-green-500 focus:border-transparent transition-all duration-300"
                                placeholder="ton@email.com"
                            >
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                <i class="fas fa-lock mr-2 text-green-600"></i>Mot de passe
                            </label>
                            <input 
                                v-model="loginForm.password"
                                type="password" 
                                required
                                class="w-full px-4 py-3 border border-gray-300 rounded-2xl focus:ring-2 focus:ring-green-500 focus:border-transparent transition-all duration-300"
                                placeholder="••••••••"
                            >
                        </div>
                        
                        <button 
                            type="submit"
                            :disabled="isLoading"
                            :class="isLoading 
                                ? 'bg-gray-400 cursor-not-allowed' 
                                : 'bg-gradient-to-r from-green-600 to-emerald-600 hover:shadow-xl transform hover:scale-105'"
                            class="w-full text-white py-4 rounded-2xl font-semibold shadow-lg transition-all duration-300">
                            <i v-if="isLoading" class="fas fa-spinner fa-spin mr-2"></i>
                            <i v-else class="fas fa-sign-in-alt mr-2"></i>
                            {{ isLoading ? 'Connexion...' : 'Yalla, connecte-toi!' }}
                        </button>
                    </form>
                    
                    <p class="text-center text-gray-600">
                        <a href="Test" class="text-green-600 hover:text-green-700 font-semibold">
                            Mot de passe oublié ?
                        </a>
                    </p>
                </div>

                <!-- Formulaire Register -->
                <div v-if="currentForm === 'register'" class="space-y-6 animate-fade-in">
                    <div>
                        <h2 class="text-3xl font-bold text-green-800 mb-2">Bienvenue!</h2>
                        <p class="text-gray-600">Rejoins la communauté éco-responsable</p>
                    </div>
                    
                    <form @submit.prevent="handleRegister" class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                <i class="fas fa-envelope mr-2 text-green-600"></i>Email
                            </label>
                            <input 
                                v-model="registerForm.email"
                                type="email" 
                                required
                                class="w-full px-4 py-3 border border-gray-300 rounded-2xl focus:ring-2 focus:ring-green-500 focus:border-transparent transition-all duration-300"
                                placeholder="ton@email.com"
                            >
                        </div>

                        <!-- Champ téléphone avec sélecteur de code et vraies images -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                <i class="fas fa-phone mr-2 text-green-600"></i>Téléphone
                            </label>
                            <div class="flex space-x-2">
                                <!-- Sélecteur de code pays avec images -->
                                <div class="relative w-2/5">
                                    <select 
                                        v-model="registerForm.phoneCode"
                                        :disabled="loadingCountries"
                                        class="w-full px-4 py-3 border border-gray-300 rounded-2xl focus:ring-2 focus:ring-green-500 focus:border-transparent appearance-none bg-white"
                                    >
                                        <option v-if="loadingCountries" value="+212">Chargement des pays...</option>
                                        <option v-else v-for="country in countries" :key="country.code" :value="country.dialCode">
                                            {{ country.dialCode }} • {{ country.name }}
                                        </option>
                                    </select>
                                    <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                        <i class="fas fa-chevron-down"></i>
                                    </div>
                                </div>
                                
                                <!-- Champ numéro -->
                                <input 
                                    v-model="registerForm.phone"
                                    type="tel" 
                                    required
                                    class="flex-1 px-4 py-3 border border-gray-300 rounded-2xl focus:ring-2 focus:ring-green-500 focus:border-transparent transition-all duration-300"
                                    placeholder="612345678"
                                >
                            </div>
                            <div v-if="registerForm.phoneCode && !loadingCountries" class="flex items-center space-x-2 mt-2">
                                <img 
                                    v-if="getSelectedCountry()?.flag" 
                                    :src="getSelectedCountry()?.flag" 
                                    :alt="getSelectedCountry()?.name"
                                    class="w-6 h-4 rounded object-cover"
                                >
                                <span class="text-xs text-gray-500">
                                    {{ getSelectedCountry()?.name }} • {{ registerForm.phoneCode }}{{ registerForm.phone }}
                                    <span v-if="registerForm.phone" class="text-green-600 font-semibold">✓ Valide</span>
                                </span>
                            </div>
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                <i class="fas fa-lock mr-2 text-green-600"></i>Mot de passe
                            </label>
                            <input 
                                v-model="registerForm.password"
                                type="password" 
                                required
                                @input="validatePassword"
                                :class="passwordStrength.class"
                                class="w-full px-4 py-3 border rounded-2xl focus:ring-2 focus:border-transparent transition-all duration-300"
                                placeholder="Au moins 8 caractères"
                            >
                            <div v-if="registerForm.password" class="mt-2">
                                <div class="flex items-center space-x-2 text-sm">
                                    <span :class="passwordStrength.textClass">{{ passwordStrength.message }}</span>
                                </div>
                                <div class="mt-1 text-xs text-gray-600 grid grid-cols-2 gap-1">
                                    <p :class="registerForm.password.length >= 8 ? 'text-green-600' : 'text-gray-400'">✓ 8 caractères minimum</p>
                                    <p :class="/[A-Z]/.test(registerForm.password) ? 'text-green-600' : 'text-gray-400'">✓ Une majuscule</p>
                                    <p :class="/[a-z]/.test(registerForm.password) ? 'text-green-600' : 'text-gray-400'">✓ Une minuscule</p>
                                    <p :class="/\d/.test(registerForm.password) ? 'text-green-600' : 'text-gray-400'">✓ Un chiffre (0-9)</p>
                                </div>
                            </div>
                        </div>
                        
                        <button 
                            type="submit"
                            :disabled="!isRegisterValid || isLoading"
                            :class="(!isRegisterValid || isLoading) 
                                ? 'bg-gray-400 cursor-not-allowed' 
                                : 'bg-gradient-to-r from-green-600 to-emerald-600 hover:shadow-xl transform hover:scale-105'"
                            class="w-full text-white py-4 rounded-2xl font-semibold shadow-lg transition-all duration-300"
                        >
                            <i v-if="isLoading" class="fas fa-spinner fa-spin mr-2"></i>
                            <i v-else class="fas fa-rocket mr-2"></i>
                            {{ isLoading ? 'Inscription...' : 'Yalla, commence l\'aventure!' }}
                        </button>
                    </form>
                </div>

                <!-- Messages de succès/erreur -->
                <div v-if="message" :class="messageType === 'success' ? 'bg-green-100 border-green-500 text-green-700' : 'bg-red-100 border-red-500 text-red-700'" 
                     class="mt-4 p-4 rounded-2xl border">
                    {{ message }}
                </div>
            </div>
        </div>
    </div>

    <style>
        .animate-fade-in {
            animation: fadeIn 0.5s ease-in-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .font-arabic {
            font-family: system-ui, -apple-system, sans-serif;
        }
        
        /* Style pour le sélecteur avec images */
        select option {
            padding: 8px;
            background-repeat: no-repeat;
            background-position: left 8px center;
            padding-left: 30px;
        }
    </style>
    <script>
    const { createApp, ref, computed, watch, onMounted } = Vue;
    
    createApp({
        setup() {
            const currentForm = ref('login');
            const message = ref('');
            const messageType = ref('');
            const isLoading = ref(false);
            const loadingCountries = ref(true);
            
            const loginForm = ref({
                email: '',
                password: ''
            });
            
            const registerForm = ref({
                email: '',
                phoneCode: '+212',
                phone: '',
                password: ''
            });
            
            const passwordStrength = ref({
                message: '',
                class: 'border-gray-300 focus:ring-green-500',
                textClass: 'text-gray-600'
            });
            
            // Liste des pays (vide au début, remplie par API)
            const countries = ref([]);
            
            // ✅ Récupérer les pays depuis l'API externe avec vraies images
            const fetchCountries = async () => {
                loadingCountries.value = true;
                try {
                    const response = await fetch('https://restcountries.com/v3.1/all?fields=name,flags,idd,cca2');
                    const data = await response.json();
                    
                    countries.value = data
                        .filter(country => country.idd?.root && country.idd.suffixes)
                        .map(country => {
                            const root = country.idd.root;
                            const suffix = country.idd.suffixes[0];
                            const dialCode = root + suffix;
                            
                            return {
                                code: country.cca2,
                                name: country.name.common,
                                dialCode: dialCode,
                                flag: country.flags?.png || country.flags?.svg,
                                fullName: country.name.official
                            };
                        })
                        .sort((a, b) => a.name.localeCompare(b.name));
                        
                } catch (error) {
                    console.error('Erreur API countries:', error);
                    // Fallback vers liste statique si l'API échoue
                    countries.value = getDefaultCountries();
                } finally {
                    loadingCountries.value = false;
                }
            };
            
            // ✅ Obtenir le pays sélectionné
            const getSelectedCountry = () => {
                return countries.value.find(country => country.dialCode === registerForm.value.phoneCode);
            };
            
            // ✅ Liste par défaut (fallback) avec images
            const getDefaultCountries = () => [
                { code: 'MA', name: 'Maroc', dialCode: '+212', flag: 'https://flagcdn.com/w40/ma.png' },
                { code: 'FR', name: 'France', dialCode: '+33', flag: 'https://flagcdn.com/w40/fr.png' },
                { code: 'US', name: 'USA', dialCode: '+1', flag: 'https://flagcdn.com/w40/us.png' },
                { code: 'DZ', name: 'Algérie', dialCode: '+213', flag: 'https://flagcdn.com/w40/dz.png' },
                { code: 'TN', name: 'Tunisie', dialCode: '+216', flag: 'https://flagcdn.com/w40/tn.png' },
                { code: 'BE', name: 'Belgique', dialCode: '+32', flag: 'https://flagcdn.com/w40/be.png' },
                { code: 'CA', name: 'Canada', dialCode: '+1', flag: 'https://flagcdn.com/w40/ca.png' },
                { code: 'DE', name: 'Allemagne', dialCode: '+49', flag: 'https://flagcdn.com/w40/de.png' },
                { code: 'ES', name: 'Espagne', dialCode: '+34', flag: 'https://flagcdn.com/w40/es.png' },
                { code: 'IT', name: 'Italie', dialCode: '+39', flag: 'https://flagcdn.com/w40/it.png' },
                { code: 'GB', name: 'Royaume-Uni', dialCode: '+44', flag: 'https://flagcdn.com/w40/gb.png' },
                { code: 'SN', name: 'Sénégal', dialCode: '+221', flag: 'https://flagcdn.com/w40/sn.png' },
                { code: 'CI', name: 'Côte d\'Ivoire', dialCode: '+225', flag: 'https://flagcdn.com/w40/ci.png' },
                { code: 'CM', name: 'Cameroun', dialCode: '+237', flag: 'https://flagcdn.com/w40/cm.png' },
                { code: 'EG', name: 'Égypte', dialCode: '+20', flag: 'https://flagcdn.com/w40/eg.png' }
            ];
            
            // ✅ Charger les pays au démarrage
            onMounted(() => {
                fetchCountries();
            });
            
            const validatePassword = () => {
                const password = registerForm.value.password;
                
                if (password.length === 0) {
                    passwordStrength.value = {
                        message: '',
                        class: 'border-gray-300 focus:ring-green-500',
                        textClass: 'text-gray-600'
                    };
                    return;
                }
                
                const hasMinLength = password.length >= 8;
                const hasUpperCase = /[A-Z]/.test(password);
                const hasLowerCase = /[a-z]/.test(password);
                const hasNumbers = /\d/.test(password);
                
                const requirements = [hasMinLength, hasUpperCase, hasLowerCase, hasNumbers];
                const metRequirements = requirements.filter(Boolean).length;
                
                if (metRequirements === 4) {
                    passwordStrength.value = {
                        message: '✅ Mot de passe fort!',
                        class: 'border-green-500 focus:ring-green-500',
                        textClass: 'text-green-600 font-semibold'
                    };
                } else if (metRequirements >= 2) {
                    passwordStrength.value = {
                        message: '⚠️ Mot de passe moyen',
                        class: 'border-yellow-500 focus:ring-yellow-500',
                        textClass: 'text-yellow-600'
                    };
                } else {
                    passwordStrength.value = {
                        message: '❌ Doit contenir 8 caractères, majuscule, minuscule et chiffre',
                        class: 'border-red-500 focus:ring-red-500',
                        textClass: 'text-red-600'
                    };
                }
            };
            
            const isRegisterValid = computed(() => {
                const form = registerForm.value;
                return form.email && 
                       form.phone &&
                       form.password &&
                       passwordStrength.value.class.includes('green');
            });
            
            const showMessage = (text, type = 'success') => {
                message.value = text;
                messageType.value = type;
                setTimeout(() => {
                    message.value = '';
                }, 5000);
            };
            
            const handleLogin = async () => {
                isLoading.value = true;
                
                try {
                    const formData = new URLSearchParams();
                    formData.append('action', 'login');
                    formData.append('email', loginForm.value.email);
                    formData.append('password', loginForm.value.password);
                    
                    const response = await fetch('AuthController', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: formData
                    });
                    
                    const result = await response.json();
                    
                    if (result.success) {
                        showMessage('Marhba bik! ' + result.message + ' 🎉', 'success');
                        
                        if (result.redirect) {
                            setTimeout(() => {
                                window.location.href = result.redirect;
                            }, 1000);
                        }
                    } else {
                        showMessage(result.error, 'error');
                    }
                    
                } catch (error) {
                    showMessage('Erreur de connexion au serveur', 'error');
                } finally {
                    isLoading.value = false;
                }
            };
            
            const handleRegister = async () => {
                isLoading.value = true;
                
                try {
                    const formData = new URLSearchParams();
                    formData.append('action', 'register');
                    formData.append('email', registerForm.value.email);
                    // ✅ Envoyer le numéro complet avec code international
                    formData.append('phone', registerForm.value.phoneCode + registerForm.value.phone);
                    formData.append('password', registerForm.value.password);
                    
                    const response = await fetch('AuthController', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: formData
                    });
                    
                    const result = await response.json();
                    
                    if (result.success) {
                        showMessage('Bienvenue! ' + result.message + ' 🌱', 'success');
                        setTimeout(() => {
                            currentForm.value = 'login';
                            registerForm.value = { 
                                email: '', 
                                phoneCode: '+212', 
                                phone: '', 
                                password: '' 
                            };
                        }, 2000);
                    } else {
                        showMessage(result.error, 'error');
                    }
                    
                } catch (error) {
                    showMessage('Erreur de connexion au serveur', 'error');
                } finally {
                    isLoading.value = false;
                }
            };
            
            // Watch password changes for validation
            watch(() => registerForm.value.password, validatePassword);
            
            return {
                currentForm,
                loginForm,
                registerForm,
                countries,
                loadingCountries,
                passwordStrength,
                isRegisterValid,
                message,
                messageType,
                isLoading,
                handleLogin,
                handleRegister,
                validatePassword,
                getSelectedCountry
            };
        }
    }).mount('#app');
    </script> 
</body>
</html>