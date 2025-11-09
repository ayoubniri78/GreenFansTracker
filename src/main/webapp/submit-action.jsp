<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dev.ayoub.ActionService.model.ActionType" %>
<%@ page import="dev.ayoub.ActionService.service.ActionService" %>
<%@ page import="dev.ayoub.ActionService.service.ActionServiceImpl" %>
<%
    List<ActionType> actionTypes = (List<ActionType>) request.getAttribute("actionTypes");
    
    // Si actionTypes est null (accès direct au JSP), les charger directement
    if (actionTypes == null) {
        try {
            ActionServiceImpl actionService = new ActionServiceImpl();
            actionTypes = actionService.getAllActionTypes();
            System.out.println("Chargement direct depuis JSP: " + (actionTypes != null ? actionTypes.size() : "null"));
        } catch (Exception e) {
            System.err.println("Erreur chargement direct: " + e.getMessage());
            actionTypes = List.of(); // Liste vide en cas d'erreur
        }
    }
%>
<html>
<head>
    <title>Soumettre une Action</title>
</head>
<body>
    <h2>Soumettre une Action</h2>

    <form action="ActionController?action=submitAction" method="post" enctype="multipart/form-data">
        <label>Type :</label><br>
        <select name="type" required>
            <option value="">Choisissez un type d'action</option>
            <% if (actionTypes != null && !actionTypes.isEmpty()) { 
                for (ActionType actionType : actionTypes) { %>
                <option value="<%= actionType.getName() %>" data-points="<%= actionType.getDefaultPoints() %>">
                    <%= actionType.getName() %> (<%= actionType.getDefaultPoints() %> points)
                </option>
            <%   }
               } else { %>
                <!-- Options par défaut si la liste est vide -->
                <option value="Recyclage des déchets" data-points="50">Recyclage des déchets (50 points)</option>
                <option value="Utilisation des transports en commun" data-points="30">Utilisation des transports en commun (30 points)</option>
                <option value="Covoiturage" data-points="25">Covoiturage (25 points)</option>
            <% } %>
        </select><br><br>

        <label>Détail :</label><br>
        <textarea name="detail" required placeholder="Décrivez votre action écologique..."></textarea><br><br>

        <label>Points :</label><br>
        <input type="number" name="points" id="points" min="1" required readonly><br><br>

        <label>Preuve :</label><br>
        <input type="file" name="file" accept="image/*,video/*" required><br><br>

        <button type="submit">Envoyer</button>
    </form>

    <script>
        document.querySelector('select[name="type"]').addEventListener('change', function() {
            var selectedOption = this.options[this.selectedIndex];
            var points = selectedOption.getAttribute('data-points');
            document.getElementById('points').value = points || '';
        });

        window.addEventListener('load', function() {
            var select = document.querySelector('select[name="type"]');
            if (select.value) {
                var selectedOption = select.options[select.selectedIndex];
                var points = selectedOption.getAttribute('data-points');
                document.getElementById('points').value = points || '';
            }
        });
    </script>
</body>
</html>