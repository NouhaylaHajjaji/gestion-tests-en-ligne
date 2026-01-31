package com.gestiontests.service;

import com.gestiontests.entity.*;
import com.gestiontests.repository.*;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

@ApplicationScoped
public class TestService {
    
    @Inject
    private SessionTestRepository sessionTestRepository;
    
    @Inject
    private SessionQuestionRepository sessionQuestionRepository;
    
    @Inject
    private ReponseCandidatRepository reponseCandidatRepository;
    
    @Inject
    private ReponsePossibleRepository reponsePossibleRepository;
    
    @Inject
    private QuestionRepository questionRepository;
    
    @Inject
    private ThemeRepository themeRepository;
    
    @Inject
    private CandidatService candidatService;
    
    @Inject
    private ParametreRepository parametreRepository;
    
    @Inject
    private InscriptionRepository inscriptionRepository;
    
    @PersistenceContext
    private EntityManager entityManager;
    
    @Inject
    private EmailService emailService;
    
    @Transactional
    public SessionTest demarrerTest(String codeSession) throws Exception {
        // Vérifier si le candidat existe et peut passer le test
        Optional<Candidat> candidatOpt = candidatService.findByCodeSession(codeSession);
        if (candidatOpt.isEmpty()) {
            throw new Exception("Code session invalide");
        }
        
        Candidat candidat = candidatOpt.get();
        
        if (!candidatService.peutPasserTest(codeSession)) {
            throw new Exception("Vous ne pouvez pas passer le test maintenant");
        }
        
        // Vérifier si une session existe déjà pour ce codeSession
        Optional<SessionTest> sessionExistante = sessionTestRepository.findByCodeSession(codeSession);
        if (sessionExistante.isPresent() && !sessionExistante.get().getEstTermine()) {
            SessionTest session = sessionExistante.get();
            List<SessionQuestion> questions = sessionQuestionRepository.findBySession(session.getId());
            
            System.out.println("Returning existing active session: " + session.getId() + " with " + questions.size() + " questions");
            return session;
        }
        
        // Si une session terminée existe, on la réinitialise
        if (sessionExistante.isPresent() && sessionExistante.get().getEstTermine()) {
            System.out.println("Resetting terminated session: " + sessionExistante.get().getId());
            SessionTest session = sessionExistante.get();
            session.setEstTermine(false);
            session.setScoreTotal(0);
            session.setDateDebut(LocalDateTime.now());
            session.setDateFin(null);
            session.setPourcentage(BigDecimal.ZERO);
            
            // Supprimer anciennes réponses seulement (garder les questions existantes)
            List<SessionQuestion> questions = sessionQuestionRepository.findBySession(session.getId());
            System.out.println("Found " + questions.size() + " existing questions for terminated session");
            
            for (SessionQuestion q : questions) {
                List<ReponseCandidat> reponses = reponseCandidatRepository.findBySession(q.getId());
                for (ReponseCandidat r : reponses) {
                    reponseCandidatRepository.delete(r);
                }
            }
            
            session.setScoreMax(questions.size());
            SessionTest updatedSession = sessionTestRepository.update(session);
            System.out.println("Returning reset session with " + questions.size() + " existing questions");
            return updatedSession;
        }
        
        // Générer les questions pour le test
        List<SessionQuestion> questions = genererQuestionsPourTest();
        if (questions.isEmpty()) {
            throw new Exception("Aucune question disponible pour le test");
        }
        
        // Créer la session de test
        SessionTest sessionTest = new SessionTest();
        sessionTest.setCandidat(candidat);
        sessionTest.setCodeSession(codeSession);
        sessionTest.setScoreMax(questions.size());
        
        // Récupérer le créneau horaire depuis l'inscription du candidat
        List<Inscription> inscriptions = inscriptionRepository.findByCandidat(candidat.getId());
        if (!inscriptions.isEmpty()) {
            sessionTest.setCreneau(inscriptions.get(0).getCreneau());
            System.out.println("🎬 [DEMO] Créneau associé: " + inscriptions.get(0).getCreneau().getId());
        } else {
            System.out.println("🎬 [DEMO] Aucun créneau trouvé - utilisation d'un créneau par défaut");
            // En mode démo, créer un créneau par défaut
            CreneauHoraire creneauParDefaut = new CreneauHoraire();
            creneauParDefaut.setId(1); // ID par défaut
            sessionTest.setCreneau(creneauParDefaut);
        }
        
        sessionTest.demarrerSession();
        
        SessionTest savedSession = sessionTestRepository.create(sessionTest);
        
        System.out.println("Created new session with ID: " + savedSession.getId());
        
        // Sauvegarder les questions de la session avec SQL natif
        for (int i = 0; i < questions.size(); i++) {
            SessionQuestion sessionQuestion = questions.get(i);
            
            // Utiliser SQL natif pour insérer avec les bons champs
            String sql = "INSERT INTO session_questions (ordre_affichage, id_question, id_session_test, temps_alloue) VALUES (?, ?, ?, ?)";
            entityManager.createNativeQuery(sql)
                .setParameter(1, i + 1)
                .setParameter(2, sessionQuestion.getQuestion().getId())
                .setParameter(3, savedSession.getId())
                .setParameter(4, sessionQuestion.getTempsAlloue())
                .executeUpdate();
        }
        
        System.out.println("Created " + questions.size() + " session questions");
        
        return savedSession;
    }
    
    @Transactional
    public ReponseCandidat enregistrerReponse(Integer sessionId, Integer questionId, Map<String, Object> reponseData) throws Exception {
        Optional<SessionTest> sessionOpt = sessionTestRepository.findById(sessionId);
        if (sessionOpt.isEmpty()) {
            throw new Exception("Session de test non trouvée");
        }
        
        SessionTest session = sessionOpt.get();
        if (session.getEstTermine()) {
            throw new Exception("Le test est déjà terminé");
        }
        
        // Vérifier si le temps n'est pas écoulé
        if (session.getDateDebut() != null) {
            LocalDateTime finEstimee = session.getDateDebut().plusMinutes(120); // 2 heures de test
            if (LocalDateTime.now().isAfter(finEstimee)) {
                terminerTest(sessionId);
                throw new Exception("Le temps du test est écoulé");
            }
        }
        
        Optional<SessionQuestion> sessionQuestionOpt = sessionQuestionRepository.findBySessionAndQuestion(sessionId, questionId);
        if (sessionQuestionOpt.isEmpty()) {
            throw new Exception("Question non trouvée dans cette session");
        }
        
        SessionQuestion sessionQuestion = sessionQuestionOpt.get();
        
        // Vérifier si une réponse existe déjà
        Optional<ReponseCandidat> reponseExistanteOpt = reponseCandidatRepository.findBySessionQuestion(sessionQuestion.getId());
        if (reponseExistanteOpt.isPresent()) {
            // Mettre à jour la réponse existante
            ReponseCandidat reponse = reponseExistanteOpt.get();
            mettreAJourReponse(reponse, reponseData);
            return reponseCandidatRepository.update(reponse);
        } else {
            // Créer une nouvelle réponse
            ReponseCandidat reponse = creerReponse(sessionQuestion, reponseData);
            return reponseCandidatRepository.create(reponse);
        }
    }
    
    @Transactional
    public SessionTest terminerTest(Integer sessionId) throws Exception {
        Optional<SessionTest> sessionOpt = sessionTestRepository.findById(sessionId);
        if (sessionOpt.isEmpty()) {
            throw new Exception("Session de test non trouvée");
        }
        
        SessionTest session = sessionOpt.get();
        if (session.getEstTermine()) {
            return session;
        }
        
        // Calculer le score
        calculerScore(session);
        
        // Marquer comme terminé
        session.terminerSession();
        SessionTest updatedSession = sessionTestRepository.update(session);
        
        // Envoyer les résultats par email
        try {
            emailService.envoyerEmailResultats(
                session.getCandidat(),
                session.getScoreTotal().toString(),
                session.getPourcentage().toString()
            );
        } catch (Exception e) {
            System.err.println("Erreur lors de l'envoi des résultats par email: " + e.getMessage());
        }
        
        return updatedSession;
    }
    
    public Optional<SessionTest> getSessionById(Integer sessionId) {
        return sessionTestRepository.findById(sessionId);
    }
    
    public Optional<SessionTest> getSessionByCodeSession(String codeSession) {
        return sessionTestRepository.findByCodeSession(codeSession);
    }
    
    public List<SessionQuestion> getQuestionsBySession(Integer sessionId) {
        return sessionQuestionRepository.findBySession(sessionId);
    }
    
    public Optional<SessionQuestion> getNextQuestion(Integer sessionId, Integer currentQuestionId) {
        return sessionQuestionRepository.findNextQuestion(sessionId, currentQuestionId);
    }
    
    public Optional<SessionQuestion> getPreviousQuestion(Integer sessionId, Integer currentQuestionId) {
        return sessionQuestionRepository.findPreviousQuestion(sessionId, currentQuestionId);
    }
    
    public Optional<ReponseCandidat> getReponseBySessionQuestion(Integer sessionQuestionId) {
        return reponseCandidatRepository.findBySessionQuestion(sessionQuestionId);
    }
    
    public List<SessionTest> getSessionsByCandidat(Integer candidatId) {
        return sessionTestRepository.findByCandidat(candidatId);
    }
    
    public List<SessionTest> getAllSessions() {
        return sessionTestRepository.findAll();
    }
    
    public List<SessionTest> getRecentSessions(int limit) {
        return sessionTestRepository.findRecentSessions(limit);
    }
    
    private List<SessionQuestion> genererQuestionsPourTest() {
        // Récupérer les paramètres
        Integer nombreQuestionsParTheme = parametreRepository.getValeurParametreAsInteger("NOMBRE_QUESTIONS_PAR_THEME", 5);
        Integer tempsParQuestion = parametreRepository.getValeurParametreAsInteger("TEMPS_QUESTION_PAR_DEFAUT", 120);
        
        // Récupérer tous les thèmes
        List<Theme> themes = themeRepository.findAll();
        List<SessionQuestion> sessionQuestions = new ArrayList<>();
        
        Random random = new Random();
        
        for (Theme theme : themes) {
            // Récupérer les questions pour ce thème
            List<Question> questionsTheme = questionRepository.findByTheme(theme.getId());
            
            // Mélanger les questions
            Collections.shuffle(questionsTheme, random);
            
            // Prendre le nombre requis de questions
            int nombreAPrendre = Math.min(nombreQuestionsParTheme, questionsTheme.size());
            
            for (int i = 0; i < nombreAPrendre; i++) {
                Question question = questionsTheme.get(i);
                SessionQuestion sessionQuestion = new SessionQuestion();
                sessionQuestion.setQuestion(question);
                sessionQuestion.setTempsAlloue(tempsParQuestion);
                sessionQuestions.add(sessionQuestion);
            }
        }
        
        // Mélanger toutes les questions pour l'ordre aléatoire final
        Collections.shuffle(sessionQuestions, random);
        
        return sessionQuestions;
    }
    
    private void calculerScore(SessionTest session) {
        List<SessionQuestion> questions = sessionQuestionRepository.findBySession(session.getId());
        System.out.println("DEBUG: Calculating score for session " + session.getId() + " with " + questions.size() + " questions");
        
        int score = 0;
        int totalReponses = 0;
        
        for (SessionQuestion sessionQuestion : questions) {
            Optional<ReponseCandidat> reponseOpt = reponseCandidatRepository.findBySessionQuestion(sessionQuestion.getId());
            if (reponseOpt.isPresent()) {
                totalReponses++;
                ReponseCandidat reponse = reponseOpt.get();
                System.out.println("DEBUG: Question " + sessionQuestion.getQuestion().getId() + " - estCorrect: " + reponse.getEstCorrect());
                if (Boolean.TRUE.equals(reponse.getEstCorrect())) {
                    score++;
                }
            } else {
                System.out.println("DEBUG: Question " + sessionQuestion.getQuestion().getId() + " - No response found");
            }
        }
        
        System.out.println("DEBUG: Final score - Correct: " + score + ", Total responses: " + totalReponses + ", Total questions: " + questions.size());
        
        session.setScoreTotal(score);
        session.setScoreMax(questions.size());
    }
    
    private ReponseCandidat creerReponse(SessionQuestion sessionQuestion, Map<String, Object> reponseData) {
        ReponseCandidat reponse = new ReponseCandidat();
        reponse.setSessionQuestion(sessionQuestion);
        
        if (reponseData.containsKey("reponsePossibleId")) {
            // Réponse à choix
            Integer reponsePossibleId = (Integer) reponseData.get("reponsePossibleId");
            Optional<ReponsePossible> reponsePossibleOpt = reponsePossibleRepository.findById(reponsePossibleId);
            if (reponsePossibleOpt.isPresent()) {
                reponse.setReponsePossible(reponsePossibleOpt.get());
                reponse.setEstCorrect(reponsePossibleOpt.get().getEstCorrect());
            }
        } else if (reponseData.containsKey("reponseText")) {
            // Réponse textuelle
            String reponseText = (String) reponseData.get("reponseText");
            reponse.setReponseText(reponseText);
            
            // Évaluer automatiquement la réponse textuelle
            boolean estCorrect = evaluerReponseTextuelle(sessionQuestion.getQuestion(), reponseText);
            reponse.setEstCorrect(estCorrect);
            
            System.out.println("🎬 [DEMO] Réponse textuelle évaluée: '" + reponseText + "' -> " + (estCorrect ? "CORRECT" : "INCORRECT"));
        }
        
        if (reponseData.containsKey("tempsReponse")) {
            reponse.setTempsReponse((Integer) reponseData.get("tempsReponse"));
        }
        
        return reponse;
    }
    
    private void mettreAJourReponse(ReponseCandidat reponse, Map<String, Object> reponseData) {
        if (reponseData.containsKey("reponsePossibleId")) {
            // Réponse à choix
            Integer reponsePossibleId = (Integer) reponseData.get("reponsePossibleId");
            Optional<ReponsePossible> reponsePossibleOpt = reponsePossibleRepository.findById(reponsePossibleId);
            if (reponsePossibleOpt.isPresent()) {
                reponse.setReponsePossible(reponsePossibleOpt.get());
                reponse.setEstCorrect(reponsePossibleOpt.get().getEstCorrect());
                reponse.setReponseText(null);
            }
        } else if (reponseData.containsKey("reponseText")) {
            String reponseText = (String) reponseData.get("reponseText");
            reponse.setReponseText(reponseText);
            reponse.setReponsePossible(null);
            
            // Évaluer automatiquement la réponse textuelle
            boolean estCorrect = evaluerReponseTextuelle(reponse.getSessionQuestion().getQuestion(), reponseText);
            reponse.setEstCorrect(estCorrect);
            
            System.out.println("🎬 [DEMO] Réponse textuelle mise à jour: '" + reponseText + "' -> " + (estCorrect ? "CORRECT" : "INCORRECT"));
        }
        
        if (reponseData.containsKey("tempsReponse")) {
            reponse.setTempsReponse((Integer) reponseData.get("tempsReponse"));
        }
    }
    
    public boolean peutNaviguerVersQuestion(Integer sessionId, Integer questionId) throws Exception {
        Optional<SessionTest> sessionOpt = sessionTestRepository.findById(sessionId);
        if (sessionOpt.isEmpty()) {
            return false;
        }
        
        SessionTest session = sessionOpt.get();
        if (session.getEstTermine()) {
            return false;
        }
        
        // Vérifier si la question appartient à cette session
        Optional<SessionQuestion> sessionQuestionOpt = sessionQuestionRepository.findBySessionAndQuestion(sessionId, questionId);
        return sessionQuestionOpt.isPresent();
    }
    
    public long getTempsRestant(Integer sessionId) {
        Optional<SessionTest> sessionOpt = sessionTestRepository.findById(sessionId);
        if (sessionOpt.isEmpty() || sessionOpt.get().getDateDebut() == null) {
            return 0;
        }
        
        SessionTest session = sessionOpt.get();
        LocalDateTime finEstimee = session.getDateDebut().plusMinutes(120); // 2 heures de test
        LocalDateTime maintenant = LocalDateTime.now();
        
        if (maintenant.isAfter(finEstimee)) {
            return 0;
        }
        
        return java.time.Duration.between(maintenant, finEstimee).getSeconds();
    }
    
    /**
     * Évalue une réponse textuelle en la comparant avec les réponses correctes
     */
    private boolean evaluerReponseTextuelle(Question question, String reponseText) {
        if (reponseText == null || reponseText.trim().isEmpty()) {
            return false;
        }
        
        // Normaliser la réponse du candidat
        String reponseNormalisee = reponseText.trim().toLowerCase();
        
        // Récupérer toutes les réponses possibles pour cette question
        List<ReponsePossible> reponsesPossibles = reponsePossibleRepository.findByQuestion(question.getId());
        
        for (ReponsePossible reponsePossible : reponsesPossibles) {
            if (reponsePossible.getEstCorrect() != null && reponsePossible.getEstCorrect()) {
                // Normaliser la réponse correcte
                String reponseCorrecteNormalisee = reponsePossible.getLibelle().trim().toLowerCase();
                
                // Comparaison exacte
                if (reponseNormalisee.equals(reponseCorrecteNormalisee)) {
                    System.out.println("🎬 [DEMO] Correspondance exacte trouvée: '" + reponseText + "' == '" + reponsePossible.getLibelle() + "'");
                    return true;
                }
                
                // Comparaison partielle (contient)
                if (reponseNormalisee.contains(reponseCorrecteNormalisee) || reponseCorrecteNormalisee.contains(reponseNormalisee)) {
                    System.out.println("🎬 [DEMO] Correspondance partielle trouvée: '" + reponseText + "' ~ '" + reponsePossible.getLibelle() + "'");
                    return true;
                }
                
                // Comparaison par mots-clés (sépare en mots et vérifie si les mots-clés importants sont présents)
                if (comparerParMotsCles(reponseNormalisee, reponseCorrecteNormalisee)) {
                    System.out.println("🎬 [DEMO] Correspondance par mots-clés trouvée: '" + reponseText + "' ≈ '" + reponsePossible.getLibelle() + "'");
                    return true;
                }
            }
        }
        
        System.out.println("🎬 [DEMO] Aucune correspondance trouvée pour: '" + reponseText + "'");
        return false;
    }
    
    /**
     * Compare deux réponses en se basant sur les mots-clés importants
     */
    private boolean comparerParMotsCles(String reponse1, String reponse2) {
        // Extraire les mots-clés (mots de plus de 3 caractères)
        String[] mots1 = reponse1.split("\\s+");
        String[] mots2 = reponse2.split("\\s+");
        
        int motsCommuns = 0;
        int totalMotsImportants = 0;
        
        // Compter les mots importants dans la réponse correcte
        for (String mot2 : mots2) {
            if (mot2.length() > 3) { // Ignorer les mots courts
                totalMotsImportants++;
                for (String mot1 : mots1) {
                    if (mot1.length() > 3 && mot1.equals(mot2)) {
                        motsCommuns++;
                        break;
                    }
                }
            }
        }
        
        // Si au moins 60% des mots importants correspondent
        if (totalMotsImportants > 0) {
            double pourcentage = (double) motsCommuns / totalMotsImportants;
            return pourcentage >= 0.6;
        }
        
        return false;
    }
}
