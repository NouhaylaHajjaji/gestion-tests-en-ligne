package com.gestiontests.rest;

import com.gestiontests.entity.SessionTest;
import com.gestiontests.entity.ReponseCandidat;
import com.gestiontests.service.TestService;
import com.gestiontests.service.ResultatService;
import com.gestiontests.repository.ReponseCandidatRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Path("/resultats")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@ApplicationScoped
public class ResultatResource {
    
    // DTO pour éviter les problèmes de lazy loading
    public static class SessionTestDTO {
        private Integer id;
        private String codeSession;
        private LocalDateTime dateDebut;
        private LocalDateTime dateFin;
        private Boolean estTermine;
        private Integer scoreTotal;
        private Integer scoreMax;
        private String pourcentage;
        private Integer questionsCorrectes;
        private Integer questionsIncorrectes;
        private String dureeTotale;
        
        public SessionTestDTO(SessionTest session) {
            this.id = session.getId();
            this.codeSession = session.getCodeSession();
            this.dateDebut = session.getDateDebut();
            this.dateFin = session.getDateFin();
            this.estTermine = session.getEstTermine();
            this.scoreTotal = session.getScoreTotal();
            this.scoreMax = session.getScoreMax();
            this.pourcentage = session.getPourcentage() != null ? session.getPourcentage().toString() : "0.00";
            
            // Calculer les réponses correctes/incorrectes
            this.questionsCorrectes = session.getScoreTotal() != null ? session.getScoreTotal() : 0;
            this.questionsIncorrectes = session.getScoreMax() != null && session.getScoreTotal() != null ? 
                session.getScoreMax() - session.getScoreTotal() : 0;
            
            // Calculer la durée
            this.dureeTotale = calculateDuree(session);
        }
        
        private String calculateDuree(SessionTest session) {
            if (session.getDateDebut() == null) return "N/A";
            
            LocalDateTime fin = session.getDateFin() != null ? session.getDateFin() : LocalDateTime.now();
            long minutes = java.time.Duration.between(session.getDateDebut(), fin).toMinutes();
            
            if (minutes < 60) {
                return minutes + " min";
            } else {
                long hours = minutes / 60;
                long remainingMinutes = minutes % 60;
                return hours + "h " + remainingMinutes + "min";
            }
        }
        
        // Getters
        public Integer getId() { return id; }
        public String getCodeSession() { return codeSession; }
        public LocalDateTime getDateDebut() { return dateDebut; }
        public LocalDateTime getDateFin() { return dateFin; }
        public Boolean getEstTermine() { return estTermine; }
        public Integer getScoreTotal() { return scoreTotal; }
        public Integer getScoreMax() { return scoreMax; }
        public String getPourcentage() { return pourcentage; }
        public Integer getQuestionsCorrectes() { return questionsCorrectes; }
        public Integer getQuestionsIncorrectes() { return questionsIncorrectes; }
        public String getDureeTotale() { return dureeTotale; }
    }
    
    @Inject
    private ReponseCandidatRepository reponseCandidatRepository;
    
    @Inject
    private TestService testService;
    
    @Inject
    private ResultatService resultatService;
    
    @GET
    @Path("/session/{sessionId}")
    public Response getResultatsBySession(@PathParam("sessionId") Integer sessionId) {
        try {
            Optional<SessionTest> sessionOpt = testService.getSessionById(sessionId);
            if (sessionOpt.isEmpty()) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity(Map.of("error", "Session de test non trouvée"))
                    .build();
            }
            
            SessionTest session = sessionOpt.get();
            SessionTestDTO sessionDTO = new SessionTestDTO(session);
            
            // Récupérer les résultats par thème (temporairement vide)
            List<Map<String, Object>> resultatsParTheme = new java.util.ArrayList<>();
            
            Map<String, Object> response = new HashMap<>();
            response.put("id", sessionDTO.getId());
            response.put("codeSession", sessionDTO.getCodeSession());
            response.put("dateDebut", sessionDTO.getDateDebut());
            response.put("dateFin", sessionDTO.getDateFin());
            response.put("estTermine", sessionDTO.getEstTermine());
            response.put("scoreTotal", sessionDTO.getScoreTotal());
            response.put("scoreMax", sessionDTO.getScoreMax());
            response.put("pourcentage", sessionDTO.getPourcentage());
            response.put("questionsCorrectes", sessionDTO.getQuestionsCorrectes());
            response.put("questionsIncorrectes", sessionDTO.getQuestionsIncorrectes());
            response.put("dureeTotale", sessionDTO.getDureeTotale());
            response.put("resultatsParTheme", resultatsParTheme);
            
            return Response.ok(response).build();
            
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération des résultats: " + e.getMessage());
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Erreur lors de la récupération des résultats: " + e.getMessage()))
                .build();
        }
    }
    
    @GET
    @Path("/candidat/{candidatId}")
    public Response getResultatsByCandidat(@PathParam("candidatId") Integer candidatId) {
        try {
            List<SessionTest> sessions = testService.getSessionsByCandidat(candidatId);
            List<SessionTestDTO> sessionDTOs = sessions.stream()
                .map(SessionTestDTO::new)
                .collect(Collectors.toList());
            
            return Response.ok(Map.of(
                "candidatId", candidatId,
                "sessions", sessionDTOs,
                "totalSessions", sessionDTOs.size(),
                "sessionsTerminees", sessionDTOs.stream().mapToLong(s -> s.getEstTermine() ? 1 : 0).sum()
            )).build();
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération des résultats du candidat: " + e.getMessage());
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Erreur lors de la récupération des résultats: " + e.getMessage()))
                .build();
        }
    }
    
    @GET
    @Path("/candidat/{candidatId}/terminees")
    public Response getResultatsTermineesByCandidat(@PathParam("candidatId") Integer candidatId) {
        List<SessionTest> sessions = testService.getSessionsByCandidat(candidatId);
        List<SessionTest> sessionsTerminees = sessions.stream()
            .filter(SessionTest::getEstTermine).toList();
        
        return Response.ok(Map.of(
            "candidatId", candidatId,
            "sessions", sessionsTerminees,
            "total", sessionsTerminees.size()
        )).build();
    }
    
    @GET
    @Path("/recherche")
    public Response rechercherResultats(@QueryParam("terme") String terme) {
        if (terme == null || terme.trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(Map.of("error", "Le terme de recherche est obligatoire"))
                .build();
        }
        
        List<SessionTest> sessions = resultatService.rechercherSessionsParCandidat(terme);
        
        return Response.ok(Map.of(
            "terme", terme,
            "sessions", sessions,
            "total", sessions.size()
        )).build();
    }
    
    @GET
    @Path("/recherche/avancee")
    public Response rechercheAvancee(@QueryParam("nom") String nom,
                                   @QueryParam("prenom") String prenom,
                                   @QueryParam("ecole") String ecole,
                                   @QueryParam("codeExam") String codeExam) {
        List<SessionTest> sessions = resultatService.rechercheAvanceeSessions(nom, prenom, ecole, codeExam);
        
        return Response.ok(Map.of(
            "critères", Map.of(
                "nom", nom,
                "prenom", prenom,
                "ecole", ecole,
                "codeExam", codeExam
            ),
            "sessions", sessions,
            "total", sessions.size()
        )).build();
    }
    
    @GET
    @Path("/stats/globales")
    public Response getStatsGlobales() {
        List<SessionTest> recentSessions = testService.getRecentSessions(1000);
        
        long totalSessions = recentSessions.size();
        long sessionsTerminees = recentSessions.stream().mapToLong(s -> s.getEstTermine() ? 1 : 0).sum();
        double scoreMoyen = recentSessions.stream()
            .filter(SessionTest::getEstTermine)
            .mapToDouble(s -> s.getPourcentage().doubleValue())
            .average()
            .orElse(0.0);
        
        double scoreMax = recentSessions.stream()
            .filter(SessionTest::getEstTermine)
            .mapToDouble(s -> s.getPourcentage().doubleValue())
            .max()
            .orElse(0.0);
        
        double scoreMin = recentSessions.stream()
            .filter(SessionTest::getEstTermine)
            .mapToDouble(s -> s.getPourcentage().doubleValue())
            .min()
            .orElse(0.0);
        
        return Response.ok(Map.of(
            "totalSessions", totalSessions,
            "sessionsTerminees", sessionsTerminees,
            "tauxCompletion", totalSessions > 0 ? (double) sessionsTerminees / totalSessions * 100 : 0,
            "scoreMoyen", Math.round(scoreMoyen * 100.0) / 100.0,
            "scoreMax", Math.round(scoreMax * 100.0) / 100.0,
            "scoreMin", Math.round(scoreMin * 100.0) / 100.0
        )).build();
    }
    
    @GET
    @Path("/stats/par-ecole")
    public Response getStatsParEcole() {
        List<Map<String, Object>> statsEcole = resultatService.getStatsParEcole();
        
        return Response.ok(Map.of("statsEcole", statsEcole)).build();
    }
    
    @GET
    @Path("/stats/par-date")
    public Response getStatsParDate(@QueryParam("jours") Integer jours) {
        if (jours == null) {
            jours = 30; // Par défaut 30 jours
        }
        
        List<Map<String, Object>> statsDate = resultatService.getStatsParDate(jours);
        
        return Response.ok(Map.of(
            "periode", jours + " jours",
            "statsDate", statsDate
        )).build();
    }
    
    @GET
    @Path("/top-scores/{limit}")
    public Response getTopScores(@PathParam("limit") Integer limit) {
        List<SessionTest> topScores = resultatService.getTopScores(limit);
        
        return Response.ok(Map.of(
            "topScores", topScores,
            "limit", limit
        )).build();
    }
    
    @GET
    @Path("/recent/{limit}")
    public Response getResultatsRecents(@PathParam("limit") Integer limit) {
        List<SessionTest> sessions = testService.getRecentSessions(limit);
        
        return Response.ok(Map.of(
            "sessions", sessions,
            "limit", limit
        )).build();
    }
    
    @GET
    @Path("/export/csv")
    @Produces("text/csv")
    public Response exportResultatsCSV(@QueryParam("dateDebut") String dateDebut,
                                      @QueryParam("dateFin") String dateFin) {
        try {
            String csv = resultatService.exporterResultatsCSV(dateDebut, dateFin);
            
            return Response.ok(csv)
                .header("Content-Disposition", "attachment; filename=\"resultats.csv\"")
                .build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(Map.of("error", e.getMessage()))
                .build();
        }
    }
    
    @GET
    @Path("/session/{sessionId}/details")
    public Response getDetailsSession(@PathParam("sessionId") Integer sessionId) {
        Optional<SessionTest> sessionOpt = testService.getSessionById(sessionId);
        if (sessionOpt.isEmpty()) {
            return Response.status(Response.Status.NOT_FOUND)
                .entity(Map.of("error", "Session de test non trouvée"))
                .build();
        }
        
        SessionTest session = sessionOpt.get();
        Map<String, Object> details = resultatService.getDetailsSession(sessionId);
        
        return Response.ok(Map.of(
            "session", session,
            "details", details
        )).build();
    }
    
    @GET
    @Path("/candidat/{candidatId}/progression")
    public Response getProgressionCandidat(@PathParam("candidatId") Integer candidatId) {
        List<SessionTest> sessions = testService.getSessionsByCandidat(candidatId);
        List<SessionTest> sessionsTerminees = sessions.stream()
            .filter(SessionTest::getEstTermine)
            .sorted((s1, s2) -> s1.getDateDebut().compareTo(s2.getDateDebut())).toList();
        
        return Response.ok(Map.of(
            "candidatId", candidatId,
            "progression", sessionsTerminees,
            "total", sessionsTerminees.size(),
            "amelioration", calculerAmelioration(sessionsTerminees)
        )).build();
    }
    
    private Map<String, Object> calculerAmelioration(List<SessionTest> sessions) {
        if (sessions.size() < 2) {
            return Map.of("amelioration", 0.0, "tendance", "insuffisant_de_donnees");
        }
        
        double premierScore = sessions.get(0).getPourcentage().doubleValue();
        double dernierScore = sessions.get(sessions.size() - 1).getPourcentage().doubleValue();
        double amelioration = dernierScore - premierScore;
        
        String tendance;
        if (amelioration > 5) {
            tendance = "amelioration";
        } else if (amelioration < -5) {
            tendance = "regression";
        } else {
            tendance = "stable";
        }
        
        return Map.of(
            "amelioration", Math.round(amelioration * 100.0) / 100.0,
            "tendance", tendance,
            "premierScore", premierScore,
            "dernierScore", dernierScore
        );
    }
    
    @GET
    @Path("/rapport/{sessionId}")
    @Produces("application/pdf")
    public Response telechargerRapport(@PathParam("sessionId") Integer sessionId) {
        try {
            Optional<SessionTest> sessionOpt = testService.getSessionById(sessionId);
            if (sessionOpt.isEmpty()) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity(Map.of("error", "Session de test non trouvée"))
                    .build();
            }
            
            SessionTest session = sessionOpt.get();
            
            // Générer le contenu PDF (simplifié pour le moment)
            String pdfContent = genererRapportPDF(session);
            
            return Response.ok(pdfContent)
                .type("application/pdf")
                .header("Content-Disposition", "attachment; filename=\"rapport-test-" + session.getCodeSession() + ".pdf\"")
                .build();
                
        } catch (Exception e) {
            System.err.println("Erreur lors de la génération du rapport PDF: " + e.getMessage());
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Erreur lors de la génération du rapport: " + e.getMessage()))
                .build();
        }
    }
    
    private String genererRapportPDF(SessionTest session) {
        StringBuilder rapport = new StringBuilder();
        
        // En-tête du rapport
        rapport.append("RAPPORT DE TEST\n");
        rapport.append("================\n\n");
        
        // Informations générales
        rapport.append("Code Session: ").append(session.getCodeSession()).append("\n");
        rapport.append("Date du test: ").append(session.getDateDebut().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))).append("\n");
        rapport.append("Durée: ").append(calculateDuree(session)).append("\n\n");
        
        // Résultats
        rapport.append("RÉSULTATS\n");
        rapport.append("----------\n");
        rapport.append("Score: ").append(session.getScoreTotal()).append("/").append(session.getScoreMax()).append("\n");
        rapport.append("Pourcentage: ").append(session.getPourcentage()).append("%\n");
        rapport.append("Statut: ").append(session.getEstTermine() ? "Terminé" : "En cours").append("\n\n");
        
        // Performance
        rapport.append("PERFORMANCE\n");
        rapport.append("-----------\n");
        if (session.getPourcentage().doubleValue() >= 80) {
            rapport.append("Niveau: EXCELLENT 🏆\n");
        } else if (session.getPourcentage().doubleValue() >= 60) {
            rapport.append("Niveau: BON 👍\n");
        } else {
            rapport.append("Niveau: À AMÉLIORER 📈\n");
        }
        
        // Pied de page
        rapport.append("\n----------------\n");
        rapport.append("Généré le: ").append(LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"))).append("\n");
        rapport.append("Système de Gestion des Tests en Ligne\n");
        
        return rapport.toString();
    }
    
    private String calculateDuree(SessionTest session) {
        if (session.getDateDebut() == null) return "N/A";
        
        LocalDateTime fin = session.getDateFin() != null ? session.getDateFin() : LocalDateTime.now();
        long minutes = java.time.Duration.between(session.getDateDebut(), fin).toMinutes();
        
        if (minutes < 60) {
            return minutes + " minutes";
        } else {
            long hours = minutes / 60;
            long remainingMinutes = minutes % 60;
            return hours + "h " + remainingMinutes + "min";
        }
    }
}
