<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Redirection...</title>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const token = localStorage.getItem('jwtToken');
            console.log("🔑 Token trouvé dans localStorage:", token ? "OUI" : "NON");
            
            if (token) {
                // Rediriger vers Mes Actions avec le token
                const newUrl = 'ActionController?action=my-actions&jwtToken=' + encodeURIComponent(token);
                console.log("🔄 Redirection vers:", newUrl);
                window.location.href = newUrl;
            } else {
                console.log("❌ Pas de token - Redirection vers login");
                alert('Veuillez vous connecter pour accéder à vos actions');
                window.location.href = 'index.jsp?error=not_logged_in';
            }
        });
    </script>
</head>
<body>
    <div style="display: flex; justify-content: center; align-items: center; height: 100vh; flex-direction: column;">
        <div class="loader" style="border: 5px solid #f3f3f3; border-top: 5px solid #3498db; border-radius: 50%; width: 50px; height: 50px; animation: spin 2s linear infinite;"></div>
        <p style="margin-top: 20px; font-size: 18px; color: #666;">Redirection vers vos actions...</p>
    </div>
    
    <style>
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</body>
</html>