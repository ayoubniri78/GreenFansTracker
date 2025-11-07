package dev.ayoub.SupporterService.model;
import lombok.ToString;
import lombok.Data;
import lombok.NonNull;
import lombok.Setter;

import java.sql.Date;
import jakarta.persistence.*;
	@ToString(exclude = "password")
	@Entity
	@Table(name="Supporter")
	@Data
public class Supporter {
		
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@NonNull
	@Column(unique = true, nullable = false)
	private String email;
	
	@NonNull
	private String phoneNumber;
	
	@NonNull
	private String password;
	
	private String teamFavorite;
	
	@Setter
	private Date creationDate;
	
	@OneToOne(mappedBy = "supporter")
	private AuthToken authToken;
	
	public Supporter() {}
	
	public Supporter(String email2, String phone, String hashedPassword) {
		this.email=email2;
		this.phoneNumber=phone;
		this.password=hashedPassword;
	}
}
