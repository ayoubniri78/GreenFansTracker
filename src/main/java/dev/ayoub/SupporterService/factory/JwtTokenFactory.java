package dev.ayoub.SupporterService.factory;

import dev.ayoub.SupporterService.model.AuthToken;

import dev.ayoub.SupporterService.model.Supporter;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import javax.crypto.SecretKey;
import java.util.Date;

public class JwtTokenFactory implements TokenFactory {

    private final SecretKey secretKey = Keys.hmacShaKeyFor(
        "maSuperCleSecrete1234567890123456789012".getBytes()
    );
    private final long expirationMs = 86400000; 

    @Override
    public AuthToken createToken(Supporter s) {
        System.out.println(" Factory - Création token pour: " + s.getEmail());
        
        String token = Jwts.builder()
                .setSubject(s.getEmail())
                .claim("id", s.getId())
                .claim("phone", s.getPhoneNumber())
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationMs))
                .signWith(secretKey)
                .compact();

        System.out.println("✅ JWT généré: " + token);
        
        Date expiryDate = new Date(System.currentTimeMillis() + expirationMs);
        return new AuthToken(token, expiryDate, s);
    }
}