package dev.ayoub.util;

import dev.ayoub.SupporterService.dao.SupporterDao;

import dev.ayoub.SupporterService.dao.SupporterDaoImpl;
import dev.ayoub.SupporterService.model.Credentials;
import dev.ayoub.SupporterService.model.Supporter;
import org.mindrot.jbcrypt.BCrypt;

public class VerifyPassword {
	public static boolean verifyPassword(Credentials c) {
		SupporterDao dao= new SupporterDaoImpl();
		Supporter s1 = dao.findByEmail(c.getEmail());
		if (s1 == null) return false;
		return BCrypt.checkpw(c.getPassword(), s1.getPassword());	
	}
	public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }
}
