package dev.ayoub.SupporterService;



import dev.ayoub.SupporterService.dao.SupporterDao;
import dev.ayoub.SupporterService.dao.SupporterDaoImpl;
import dev.ayoub.SupporterService.model.Supporter;

public class TestSupporterAuthToken {
    public static void main(String[] args) {
        SupporterDao dao = new SupporterDaoImpl();
        
        // Test 1: Email qui existe
        Supporter result1 = dao.findByEmail("ayoubniri2@gmail.com");
        System.out.println("Test 1 - Email existant: " + (result1 != null ? "ayoubniri2@gmail.com TROUVÉ" : "NON TROUVÉ"));
        
        // Test 2: Email qui n'existe pas  
        Supporter result2 = dao.findByEmail("inexistant@test.com");
        System.out.println("Test 2 - Email inexistant: " + (result2 != null ? "TROUVÉ" : "NON TROUVÉ"));
        
        // Test 3: Email null
        Supporter result3 = dao.findByEmail(null);
        System.out.println("Test 3 - Email null: " + (result3 != null ? "TROUVÉ" : "NON TROUVÉ"));
    }
}
