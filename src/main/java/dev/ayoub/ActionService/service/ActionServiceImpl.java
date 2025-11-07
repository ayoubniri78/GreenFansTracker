package dev.ayoub.ActionService.service;

import java.io.InputStream;
import java.util.List;

import dev.ayoub.ActionService.dao.ActionDao;
import dev.ayoub.ActionService.dao.ActionDaoImpl;
import dev.ayoub.ActionService.model.Action;

public class ActionServiceImpl implements ActionService{
	
	ActionDao dao =new ActionDaoImpl(); 

	@Override
	public Action submitAction(int suppId, String type, String detail, int points, InputStream fileStream,
			String fileName, String fileType) {
		Action a = new Action()
		
		return null;
	}

	@Override
	public boolean voteOnAction(int actionId, int suppId, String voteType) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean checkValidation(int actionId) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public List<Action> getPendingAction() {
		// TODO Auto-generated method stub
		return null;
	}

}
