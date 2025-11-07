package dev.ayoub.ActionService.util;

import dev.ayoub.ActionService.model.Action;
import dev.ayoub.ActionService.model.STATUS;

public class ValideAction {
    
    public static boolean estActionValide(Action action) {
        return action != null && 
               action.getSupporterId() > 0 && 
               action.getType() != null &&
               !estChaineVide(action.getType()) && 
               action.getSubmissionDate() != null;
    }
    
    /**
     * Méthode qui remplace String.isEmpty()
     */
    private static boolean estChaineVide(String chaine) {
        return chaine.length() == 0;
    }
    
    /**
     * Méthode qui remplace String.trim()
     */
    private static String supprimerEspaces(String chaine) {
        if (chaine == null) {
            return null;
        }
        
        int debut = 0;
        int fin = chaine.length() - 1;
        
        // Trouver le premier caractère non-espace
        while (debut <= fin && chaine.charAt(debut) == ' ') {
            debut++;
        }
        
        // Trouver le dernier caractère non-espace
        while (fin >= debut && chaine.charAt(fin) == ' ') {
            fin--;
        }
        
        // Retourner la sous-chaîne sans les espaces
        return chaine.substring(debut, fin + 1);
    }
    
    /**
     * Version alternative avec vérification manuelle des espaces
     */
    public static boolean estActionValideV2(Action action) {
        if (action == null) return false;
        if (action.getSupporterId() <= 0) return false;
        if (action.getType() == null) return false;
        if (action.getSubmissionDate() == null) return false;
        
        // Vérifier manuellement si la chaîne est vide ou ne contient que des espaces
        String type = action.getType();
        boolean contientCaractereNonEspace = false;
        
        for (int i = 0; i < type.length(); i++) {
            if (type.charAt(i) != ' ') {
                contientCaractereNonEspace = true;
                break;
            }
        }
        
        return contientCaractereNonEspace;
    }
}