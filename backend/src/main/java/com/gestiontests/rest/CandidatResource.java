package com.gestiontests.rest;

import com.gestiontests.entity.Candidat;
import com.gestiontests.entity.CreneauHoraire;
import com.gestiontests.service.CandidatService;
import com.gestiontests.service.CreneauHoraireService;
import com.gestiontests.service.EmailService;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Path("/candidats")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@ApplicationScoped
public class CandidatResource {
    
    @Inject
    private CandidatService candidatService;
    
    @Inject
    private CreneauHoraireService creneauHoraireService;
    
    @Inject
    private EmailService emailService;
    
    @POST
    @Path("/inscription")
    public Response inscrireCandidat(Map<String, Object> payload) {
        try {
            Candidat candidat = new Candidat();
            candidat.setNom((String) payload.get("nom"));
            candidat.setPrenom((String) payload.get("prenom"));
            candidat.setEcole((String) payload.get("ecole"));
            candidat.setFiliere((String) payload.get("filiere"));
            candidat.setEmail((String) payload.get("email"));
            candidat.setGsm((String) payload.get("gsm"));
            
            Integer creneauId = (Integer) payload.get("creneauId");
            if (creneauId == null) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("error", "Le creneauId est obligatoire"))
                    .build();
            }
            
            Candidat inscrit = candidatService.inscrireCandidat(candidat, creneauId);
            
            return Response.status(Response.Status.CREATED)
                .entity(Map.of(
                    "message", "Inscription réussie",
                    "candidat", inscrit,
                    "validationRequise", !inscrit.getEstValide()
                ))
                .build();
                
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(Map.of("error", e.getMessage()))
                .build();
        }
    }
    
    @POST
    @Path("/validation/{candidatId}")
    public Response validerInscription(@PathParam("candidatId") Integer candidatId) {
        try {
            Candidat candidat = candidatService.validerInscription(candidatId);
            return Response.ok(Map.of(
                "message", "Inscription validée avec succès",
                "candidat", candidat
            )).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(Map.of("error", e.getMessage()))
                .build();
        }
    }

    @POST
    @Path("/connexion")
    public Response connecterCandidat(Map<String, Object> payload) {
        Object codeSessionObj = payload.get("codeSession");
        if (codeSessionObj == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(Map.of("error", "Le codeSession est obligatoire"))
                .build();
        }

        String codeSession = String.valueOf(codeSessionObj);
        if (codeSession.trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(Map.of("error", "Le codeSession est obligatoire"))
                .build();
        }

        Optional<Candidat> candidatOpt = candidatService.findByCodeSession(codeSession);
        if (candidatOpt.isEmpty()) {
            return Response.status(Response.Status.NOT_FOUND)
                .entity(Map.of("error", "Code session non trouvé"))
                .build();
        }

        Candidat candidat = candidatOpt.get();
        return Response.ok(Map.of(
            "candidat", candidat,
            "peutPasserTest", candidatService.peutPasserTest(codeSession),
            "creneauEstPasse", candidatService.creneauEstPasse(codeSession),
            "creneauEstAtteint", candidatService.creneauEstAtteint(codeSession)
        )).build();
    }
    
    @GET
    @Path("/code/{codeSession}")
    public Response getCandidatByCodeSession(@PathParam("codeSession") String codeSession) {
        Optional<Candidat> candidatOpt = candidatService.findByCodeSession(codeSession);
        if (candidatOpt.isEmpty()) {
            return Response.status(Response.Status.NOT_FOUND)
                .entity(Map.of("error", "Code session non trouvé"))
                .build();
        }
        
        Candidat candidat = candidatOpt.get();
        return Response.ok(Map.of(
            "candidat", candidat,
            "peutPasserTest", candidatService.peutPasserTest(codeSession),
            "creneauEstPasse", candidatService.creneauEstPasse(codeSession),
            "creneauEstAtteint", candidatService.creneauEstAtteint(codeSession)
        )).build();
    }
    
    @GET
    @Path("/search")
    public Response searchCandidats(@QueryParam("term") String searchTerm) {
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(Map.of("error", "Le terme de recherche est obligatoire"))
                .build();
        }
        
        List<Candidat> candidats = candidatService.findByNomOrPrenomOrEcole(searchTerm);
        return Response.ok(Map.of("candidats", candidats)).build();
    }
    
    @GET
    @Path("/valide/{estValide}")
    public Response getCandidatsByValidation(@PathParam("estValide") Boolean estValide) {
        List<Candidat> candidats = candidatService.findByEstValide(estValide);
        return Response.ok(Map.of("candidats", candidats)).build();
    }
    
    @GET
    @Path("/recent/{limit}")
    public Response getRecentCandidats(@PathParam("limit") Integer limit) {
        List<Candidat> candidats = candidatService.findRecentCandidates(limit);
        return Response.ok(Map.of("candidats", candidats)).build();
    }
    
    @GET
    @Path("/{id}")
    public Response getCandidatById(@PathParam("id") Integer id) {
        Optional<Candidat> candidatOpt = candidatService.findById(id);
        if (candidatOpt.isEmpty()) {
            return Response.status(Response.Status.NOT_FOUND)
                .entity(Map.of("error", "Candidat non trouvé"))
                .build();
        }
        
        return Response.ok(Map.of("candidat", candidatOpt.get())).build();
    }
    
    @GET
    public Response getAllCandidats() {
        List<Candidat> candidats = candidatService.findAll();
        return Response.ok(Map.of(
            "candidats", candidats,
            "total", candidats.size()
        )).build();
    }
    
    @PUT
    @Path("/{id}")
    public Response updateCandidat(@PathParam("id") Integer id, Candidat candidat) {
        try {
            candidat.setId(id);
            Candidat updated = candidatService.updateCandidat(candidat);
            return Response.ok(Map.of(
                "message", "Candidat mis à jour avec succès",
                "candidat", updated
            )).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(Map.of("error", e.getMessage()))
                .build();
        }
    }
    
    @DELETE
    @Path("/{id}")
    public Response deleteCandidat(@PathParam("id") Integer id) {
        try {
            candidatService.deleteCandidat(id);
            return Response.ok(Map.of("message", "Candidat supprimé avec succès")).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(Map.of("error", e.getMessage()))
                .build();
        }
    }
    
    @GET
    @Path("/stats")
    public Response getStats() {
        long total = candidatService.count();
        long valides = candidatService.findByEstValide(true).size();
        long enAttente = candidatService.findByEstValide(false).size();
        
        return Response.ok(Map.of(
            "total", total,
            "valides", valides,
            "enAttente", enAttente
        )).build();
    }
    
    @GET
    @Path("/creneaux-disponibles")
    public Response getCreneauxDisponibles() {
        List<CreneauHoraire> creneaux = creneauHoraireService.findAvailableCreneaux();
        return Response.ok(Map.of("creneaux", creneaux)).build();
    }
    
    @POST
    @Path("/envoyer-code-session")
    public Response envoyerCodeSession(Map<String, Object> payload) {
        try {
            String email = (String) payload.get("email");
            if (email == null || email.trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("error", "L'adresse email est obligatoire"))
                    .build();
            }
            
            // Trouver le candidat par email
            Optional<Candidat> candidatOpt = candidatService.findByEmail(email);
            if (candidatOpt.isEmpty()) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity(Map.of("error", "Aucun candidat trouvé avec cette adresse email"))
                    .build();
            }
            
            Candidat candidat = candidatOpt.get();
            if (candidat.getCodeSession() == null || candidat.getCodeSession().trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("error", "Aucun code de session disponible pour ce candidat"))
                    .build();
            }
            
            // Envoyer l'email avec le code de session
            String sujet = "Votre code de session pour le test en ligne";
            String contenu = String.format(
                "Bonjour %s %s,\n\n" +
                "Voici votre code de session pour passer le test :\n\n" +
                "🔑 Code de session : %s\n\n" +
                "Utilisez ce code sur la plateforme de test pour commencer votre évaluation.\n\n" +
                "Cordialement,\n" +
                "L'équipe de gestion des tests",
                candidat.getPrenom(),
                candidat.getNom(),
                candidat.getCodeSession()
            );
            
            emailService.envoyerEmailGeneric(email, sujet, contenu);
            
            return Response.ok(Map.of(
                "message", "Code de session envoyé avec succès à " + email,
                "codeSession", candidat.getCodeSession()
            )).build();
            
        } catch (Exception e) {
            System.err.println("Erreur lors de l'envoi du code de session: " + e.getMessage());
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Erreur lors de l'envoi de l'email: " + e.getMessage()))
                .build();
        }
    }
}
