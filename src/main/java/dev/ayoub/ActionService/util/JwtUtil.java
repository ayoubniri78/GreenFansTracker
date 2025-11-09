package dev.ayoub.ActionService.util;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import javax.crypto.SecretKey;

public class JwtUtil {
	static SecretKey cleSucre = Keys.hmacShaKeyFor(
            "maSuperCleSecrete1234567890123456789012".getBytes()
        );
	public static Claims validerJwtToken(String token) {
		try {
			Claims claim = Jwts.parserBuilder()
					.setSigningKey(cleSucre)
					.build()
                    .parseClaimsJws(token)
                    .getBody();
			int id = Integer.parseInt(claim.getSubject());
			String email=claim.get("email", String.class);
			String phone=claim.get("phone", String.class);
			return claim;
		} catch (ExpiredJwtException e) {
			System.out.println("Jwt Expirer");
			return null;
		}
		catch(JwtException e) {
			System.out.println("Token invalide " +e.getMessage());
			return null;
		}
	}
}
