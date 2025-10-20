package dev.ayoub.SupporterService.service;

import java.io.IOException;
import java.util.Date;

import dev.ayoub.SupporterService.dao.SupporterDao;
import dev.ayoub.SupporterService.dao.SupporterDaoImpl;
import dev.ayoub.SupporterService.factory.JwtTokenFactory;
import dev.ayoub.SupporterService.factory.TokenFactory;
import dev.ayoub.SupporterService.model.AuthToken;
import dev.ayoub.SupporterService.model.Credentials;
import dev.ayoub.SupporterService.model.Supporter;
import dev.ayoub.util.PasswordPolitic;
import dev.ayoub.util.VerifyEmail;
import dev.ayoub.util.VerifyPassword;

public class AuthServiceImpl implements AuthService{

	@Override
	public AuthToken authenticate(Credentials c) {
		
		try {
			SupporterDao dao = new SupporterDaoImpl();
			Supporter s = dao.findByEmail(c.getEmail());
			if(s == null)
				throw new SecurityException("Utilisateur introuvable");
			if(!VerifyPassword.verifyPassword(c))
				throw new SecurityException("Login ou mot de pass incorrect");
			return generateToken(s);
		}
		catch(Exception e){
			throw new SecurityException("Echec de l'authentification"+e.getMessage());
		}			
	}
	
	@Override
	public AuthToken register(Credentials c) {
		try {
			SupporterDao dao = new SupporterDaoImpl();
			String email = c.getEmail();
			Supporter test = dao.findByEmail(email);
			if(test!= null)
				throw new IllegalArgumentException("Email deja exist");
			if(!VerifyEmail.isValidEmail(email))
				throw new IOException("Email invalid");
			String password = c.getPassword();
			if(!PasswordPolitic.isValidPassword(password))
				throw new IOException("Password ne respect pas les politiques de security , au moins 8 caractere , une lettre majuscile , autre maniscule , au moine une chiffre 0-9");
			
			String hashedPassword=VerifyPassword.hashPassword(password);
			
			String phone = c.getPhone();
			Supporter s = new Supporter(email, phone, hashedPassword);
			s.setCreationDate(new java.sql.Date(System.currentTimeMillis()));
			dao.save(s);
			return generateToken(s);
			}catch(Exception e) {
			throw new SecurityException("Echec de l'authentification"+e.getMessage());
		}
	}

	@Override
	public AuthToken generateToken(Supporter s) {
		TokenFactory t = new JwtTokenFactory();
		return t.createToken(s);
	}

	
	

}
