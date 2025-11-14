package dev.ayoub.ScoreService.controller;

import java.io.IOException;
import java.util.List;

import org.hibernate.Session;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dev.ayoub.ActionService.model.STATUS;
import dev.ayoub.ScoreService.model.Ranking;
import dev.ayoub.ScoreService.model.Score;
import dev.ayoub.ScoreService.service.ScoreService;
import dev.ayoub.ScoreService.service.ScoreServiceImpl;
import dev.ayoub.util.HibernateUtil;

@WebServlet("/ranking")
public class ScoreController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ScoreService scoreService;

    public ScoreController() {
        this.scoreService = new ScoreServiceImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        System.out.println("🎯 Action demandée: " + action);
        
        if ("getRanking".equalsIgnoreCase(action)) {
            getRanking(request, response);
        } else if ("getUserScore".equalsIgnoreCase(action)) {
            getUserScore(request, response);
        } else if ("getUserRank".equalsIgnoreCase(action)) {
            getUserRank(request, response);
        } else if ("generateScores".equalsIgnoreCase(action)) {
            generateScores(request, response);   
        }
        else if ("checkActions".equalsIgnoreCase(action)) {
            checkValidatedActions(request, response);
        }else {
            showRankingPage(request, response);
        }
    }

    private void getRanking(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            List<Ranking> ranking = scoreService.getRanking();
            
            StringBuilder json = new StringBuilder();
            json.append("{\"success\":true,\"ranking\":[");
            
            for (int i = 0; i < ranking.size(); i++) {
                Ranking r = ranking.get(i);
                json.append(String.format(
                    "{\"position\":%d,\"username\":\"%s\",\"score\":%d,\"supporterId\":%d}",
                    r.getPosition(), r.getUsername(), r.getScore(), r.getSupporterId()
                ));
                if (i < ranking.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]}");
            
            response.setContentType("application/json");
            response.getWriter().write(json.toString());
            
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private void getUserScore(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String supporterIdParam = request.getParameter("supporterId");
            if (supporterIdParam == null) {
                response.getWriter().write("{\"success\":false,\"error\":\"supporterId manquant\"}");
                return;
            }
            
            int supporterId = Integer.parseInt(supporterIdParam);
            Score score = scoreService.calculateScore(supporterId);
            
            String json = String.format(
                "{\"success\":true,\"supporterId\":%d,\"totalScore\":%d,\"lastUpdate\":\"%s\"}",
                score.getSupporterId(), score.getTotalScore(), score.getLastUpdate()
            );
            
            response.setContentType("application/json");
            response.getWriter().write(json);
            
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private void getUserRank(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String supporterIdParam = request.getParameter("supporterId");
            if (supporterIdParam == null) {
                response.getWriter().write("{\"success\":false,\"error\":\"supporterId manquant\"}");
                return;
            }
            
            int supporterId = Integer.parseInt(supporterIdParam);
            int rank = scoreService.getSupporterRank(supporterId);
            
            String json = String.format(
                "{\"success\":true,\"supporterId\":%d,\"rank\":%d}",
                supporterId, rank
            );
            
            response.setContentType("application/json");
            response.getWriter().write(json);
            
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private void generateScores(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            scoreService.generateScoresFromValidatedActions();
            response.getWriter().write("{\"success\":true,\"message\":\"Scores générés depuis les actions validées\"}");
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private void showRankingPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/ranking.jsp").forward(request, response);
    }
    private void checkValidatedActions(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            try (Session session = HibernateUtil.getSessionFactory().openSession()) {
                String hql = "SELECT COUNT(*) FROM Action WHERE status = :status";
                Long count = session.createQuery(hql, Long.class)
                        .setParameter("status", STATUS.VALIDATED)
                        .uniqueResult();
                
                String json = String.format(
                    "{\"success\":true,\"validatedActionsCount\":%d,\"message\":\"%d actions validées trouvées\"}",
                    count, count
                );
                response.getWriter().write(json);
            }
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}