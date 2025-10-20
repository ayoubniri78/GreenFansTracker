package dev.ayoub.SupporterService.model;

import java.util.Date;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

@Entity
@Table(name="AuthToken")
@RequiredArgsConstructor

public class AuthToken {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	@Getter
	private String token;
	@Getter
	private Date expiryDate;
	@OneToOne
	@JoinColumn(name = "supporter_id", referencedColumnName = "id")
	@NonNull
	private Supporter supporter;
	public AuthToken(String token, Date expiryDate, Supporter supporter) {
        this.token = token;
        this.expiryDate = expiryDate;
        this.supporter = supporter;
    }
    public AuthToken() {
    }
}
