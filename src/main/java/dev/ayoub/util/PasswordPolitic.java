package dev.ayoub.util;

import java.util.regex.Pattern;

public class PasswordPolitic {
    
    // Patterns de validation
    private static final String MIN_LENGTH_PATTERN = ".{8,}";
    private static final String UPPERCASE_PATTERN = ".*[A-Z].*";
    private static final String LOWERCASE_PATTERN = ".*[a-z].*";
    private static final String DIGIT_PATTERN = ".*\\d.*";
    private static final String SPECIAL_CHAR_PATTERN = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*";
    private static final String NO_WHITESPACE_PATTERN = "\\S+";
    
    // Compilation des patterns
    private static final Pattern minLengthPattern = Pattern.compile(MIN_LENGTH_PATTERN);
    private static final Pattern uppercasePattern = Pattern.compile(UPPERCASE_PATTERN);
    private static final Pattern lowercasePattern = Pattern.compile(LOWERCASE_PATTERN);
    private static final Pattern digitPattern = Pattern.compile(DIGIT_PATTERN);
    private static final Pattern specialCharPattern = Pattern.compile(SPECIAL_CHAR_PATTERN);
    private static final Pattern noWhitespacePattern = Pattern.compile(NO_WHITESPACE_PATTERN);
    
    /**
     * Valide un mot de passe selon une politique de base
     * - Au moins 8 caractères
     * - Au moins une majuscule
     * - Au moins une minuscule
     * - Au moins un chiffre
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return false;
        }
        
        return minLengthPattern.matcher(password).matches() &&
               uppercasePattern.matcher(password).matches() &&
               lowercasePattern.matcher(password).matches() &&
               digitPattern.matcher(password).matches() &&
               noWhitespacePattern.matcher(password).matches();
    }
    
    /**
     * Valide un mot de passe fort
     * - Au moins 12 caractères
     * - Au moins une majuscule
     * - Au moins une minuscule
     * - Au moins un chiffre
     * - Au moins un caractère spécial
     */
    public static boolean isStrongPassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return false;
        }
        
        return password.length() >= 12 &&
               uppercasePattern.matcher(password).matches() &&
               lowercasePattern.matcher(password).matches() &&
               digitPattern.matcher(password).matches() &&
               specialCharPattern.matcher(password).matches() &&
               noWhitespacePattern.matcher(password).matches();
    }
    
    /**
     * Valide avec des critères personnalisés
     */
    public static boolean isValidPassword(String password, int minLength, boolean requireUppercase, 
                                        boolean requireLowercase, boolean requireDigit, 
                                        boolean requireSpecialChar) {
        if (password == null || password.trim().isEmpty()) {
            return false;
        }
        
        boolean isValid = password.length() >= minLength &&
                         noWhitespacePattern.matcher(password).matches();
        
        if (requireUppercase) {
            isValid = isValid && uppercasePattern.matcher(password).matches();
        }
        if (requireLowercase) {
            isValid = isValid && lowercasePattern.matcher(password).matches();
        }
        if (requireDigit) {
            isValid = isValid && digitPattern.matcher(password).matches();
        }
        if (requireSpecialChar) {
            isValid = isValid && specialCharPattern.matcher(password).matches();
        }
        
        return isValid;
    }
    
    /**
     * Vérifie la force du mot de passe et retourne un score
     * 0-2 : Faible, 3-4 : Moyen, 5 : Fort
     */
    public static int getPasswordStrength(String password) {
        if (password == null || password.trim().isEmpty()) {
            return 0;
        }
        
        int score = 0;
        
        // Longueur
        if (password.length() >= 8) score++;
        if (password.length() >= 12) score++;
        
        // Complexité
        if (uppercasePattern.matcher(password).matches()) score++;
        if (lowercasePattern.matcher(password).matches()) score++;
        if (digitPattern.matcher(password).matches()) score++;
        if (specialCharPattern.matcher(password).matches()) score++;
        
        return score;
    }
    
    /**
     * Retourne un message décrivant la force du mot de passe
     */
    public static String getPasswordStrengthMessage(String password) {
        int strength = getPasswordStrength(password);
        
        switch (strength) {
            case 0:
            case 1:
            case 2:
                return "Mot de passe faible";
            case 3:
            case 4:
                return "Mot de passe moyen";
            case 5:
            case 6:
                return "Mot de passe fort";
            default:
                return "Mot de passe très fort";
        }
    }
    
    /**
     * Vérifie si le mot de passe contient des séquences communes à éviter
     */
    public static boolean hasCommonPatterns(String password) {
        if (password == null) return false;
        
        String[] commonPatterns = {
            "123", "abc", "qwerty", "password", "admin", "0000", "1111"
        };
        
        String lowerPassword = password.toLowerCase();
        for (String pattern : commonPatterns) {
            if (lowerPassword.contains(pattern)) {
                return true;
            }
        }
        return false;
    }
}