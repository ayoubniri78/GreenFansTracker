package dev.ayoub.SupporterService.service;

import dev.ayoub.SupporterService.model.AuthToken;
import dev.ayoub.SupporterService.model.Credentials;
import dev.ayoub.SupporterService.model.Supporter;

public interface AuthService {
	public AuthToken authenticate (Credentials c) ;
	public AuthToken register (Credentials c) ;
	public AuthToken generateToken(Supporter s) ;
	
}
