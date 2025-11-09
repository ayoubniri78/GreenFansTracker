package dev.ayoub.ActionService.dao;

import java.util.List;
import dev.ayoub.ActionService.model.ActionType;

public interface ActionTypeDao {
    List<ActionType> findAll();
    ActionType findByName(String name);
    ActionType findById(int id);
}