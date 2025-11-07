package dev.ayoub.ActionService.dao;

import dev.ayoub.ActionService.model.Action;
import java.util.List;

public interface ActionDao {
	void saveAction(Action action);
	Action findActionById(int id);
	List<Action> findPendingAction();
	void updateAction(Action action);
}
