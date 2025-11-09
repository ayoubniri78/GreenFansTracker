package dev.ayoub.ActionService;

import dev.ayoub.ActionService.model.Action;
import dev.ayoub.ActionService.model.STATUS;
import dev.ayoub.ActionService.service.ActionService;
import dev.ayoub.ActionService.service.ActionServiceImpl;
import dev.ayoub.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.SessionFactory;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

public class TestActionService {

    public static void main(String[] args) {
        ActionService actionService = new ActionServiceImpl();
        SessionFactory sessionFactory = HibernateUtil.getSessionFactory();

        // Test 1: Enregistrer une action avec fichier
        System.out.println("=== Test 1: Enregistrer une action ===");
        InputStream fileStream = new ByteArrayInputStream("image de test".getBytes());
        Action action = actionService.submitAction(
                999,                        // suppId
                "plant",                    // type
                "J'ai planté un arbre",     // detail
                10,                         // points
                fileStream,                 // fileStream
                "arbre.jpg",                // fileName
                "image/jpeg"                // fileType
        );

        if (action != null ) {
            System.out.println("ACTION ENREGISTRÉE : ID = " + action.getId());
            System.out.println("  Type: " + action.getType());
            System.out.println("  Détail: " + action.getDetails());
            System.out.println("  Points: " + action.getPoints());
            System.out.println("  Statut: " + action.getStatus());
            System.out.println("  Fichier: " + action.getMediaFilePath());
        } else {
            System.out.println("ÉCHEC : action non enregistrée");
            return;
        }

        

       actionService.submitAction(9909,                        // suppId
                "plant",                    // type
                "J'ai planté un arbre",     // detail
                10,                         // points
                fileStream,                 // fileStream
                "arbre.jpg",                // fileName
                "image/jpeg");
       
        System.out.println("\nTest terminé.");
    }
}