package dev.ayoub.SupporterService.dao;

import dev.ayoub.SupporterService.model.Supporter;

public interface SupporterDao {
	Supporter findByEmail(String email);
	Supporter findByPhone(String phone);
	void save(Supporter s);
}
