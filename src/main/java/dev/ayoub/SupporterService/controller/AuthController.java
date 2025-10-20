package dev.ayoub.SupporterService.controller;

import java.io.IOException;




import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dev.ayoub.SupporterService.model.AuthToken;
import dev.ayoub.SupporterService.model.Credentials;
import dev.ayoub.SupporterService.service.AuthService;
import dev.ayoub.SupporterService.service.AuthServiceImpl;
import dev.ayoub.SupporterService.model.AuthToken;
import dev.ayoub.SupporterService.model.Credentials;
import dev.ayoub.SupporterService.service.AuthService;
import dev.ayoub.SupporterService.service.AuthServiceImpl;


public class AuthController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AuthController() {}
    

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action=request.getParameter("action");
        if ("login".equalsIgnoreCase(action)) {
            login(request, response);
        } else if ("register".equalsIgnoreCase(action)) {
            register(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action non reconnue");
        }
    }
    public void login(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	String email=request.getParameter("email");
    	String password=request.getParameter("password");
    	Credentials c=new Credentials(email, password);
    	AuthService a1 = new AuthServiceImpl();
    	try {
    		a1.authenticate(c);
    		response.getWriter().write("{\"success\":true,\"message\":\"Connexion réussie!\",\"redirect\":\"Test\"}");
		} catch (Exception e) {
			response.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
		}
    }
    public void register(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	String email=request.getParameter("email");
    	String password=request.getParameter("password");
    	String phone=request.getParameter("phone");
    	Credentials c=new Credentials(email,phone,password);
    	AuthService a1 = new AuthServiceImpl();
    	try {
            a1.register(c);
            response.getWriter().write("{\"success\":true,\"message\":\"Inscription réussie!\",\"redirect\":\"Test\"}");
        } catch (Exception e) {
        	response.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
