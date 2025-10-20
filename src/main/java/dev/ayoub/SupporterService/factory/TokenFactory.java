package dev.ayoub.SupporterService.factory;

import dev.ayoub.SupporterService.model.AuthToken;
import dev.ayoub.SupporterService.model.Supporter;

public interface TokenFactory {
	AuthToken createToken(Supporter c);
}
