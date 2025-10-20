package dev.ayoub.SupporterService.model;
import lombok.*;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Pattern;
@Data
public class Credentials {
	@NonNull
	private String email;
	@NonNull
	private String phone;
	@NonNull
	private String password;
	
	public Credentials(String email,String password) {
		this.email=email;
		this.password=password;
	}
	public Credentials(String email,String phone,String password) {
		this.email=email;
		this.phone=phone;
		this.password=password;
	}
	
	
}
