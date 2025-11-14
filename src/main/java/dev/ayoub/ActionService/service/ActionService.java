package dev.ayoub.ActionService.service;

import java.io.InputStream;

import java.util.List;
import java.util.Map;

import dev.ayoub.ActionService.model.Action;

public interface ActionService {
	Action submitAction(int suppId,String type,String detail,int points,InputStream fileStream,String fileName,String fileType);
	boolean voteOnAction(int actionId,int suppId,String voteType);
	boolean checkValidation(int actionId);//pour voir si l'action valider ou pas encore
	List<Action> getPendingAction();
	String getMediaPathByActionId(int actionId);
	List<Action> getAllActionsWithMedia();
	Action getActionById(int actionId);	
	Map<String, Integer> getActionVotes(int actionId);
	List<Action> getUserActions1(int supporterId) ;
}
