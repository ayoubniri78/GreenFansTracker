package dev.ayoub.ScoreService.controller;

import jakarta.servlet.http.HttpServlet;

import java.io.IOException;
import jakarta.servlet.Servlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/ScoreContoller")
public class ScoreContoller extends HttpServlet implements Servlet {
	private static final long serialVersionUID = 1L;
       
    
    public ScoreContoller() {
        super();
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		if("getScore".equalsIgnoreCase(action)) {
			getScore(request, response);
		}
		else if ("getRanking".equalsIgnoreCase(action)) {
            getRanking(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action non reconnue");
        }
	}
	
	protected void getScore(HttpServletRequest request, HttpServletResponse response) throws IOException{
		String supporterId = request.getParameter("supporterId");
//		int score = find
	}
	
	protected void getRanking(HttpServletRequest request, HttpServletResponse response) throws IOException{
		
	}
	

}
