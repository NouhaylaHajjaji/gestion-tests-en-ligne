# Diagrammes UML - Application de Gestion des Tests en Ligne

## 1. Diagramme de Classes (Backend)

```plantuml
@startuml
!theme plain

package "Entités JPA" {
    class Candidat {
        - Integer id
        - String nom
        - String prenom
        - String ecole
        - String filiere
        - String email
        - String gsm
        - String codeSession
        - Boolean estValide
        - LocalDateTime createdAt
        --
        + getters/setters
    }
    
    class Theme {
        - Integer id
        - String nom
        - String description
        - LocalDateTime createdAt
        --
        + getters/setters
    }
    
    class TypeQuestion {
        - Integer id
        - String nom
        - String description
        --
        + getters/setters
    }
    
    class Question {
        - Integer id
        - Theme theme
        - TypeQuestion typeQuestion
        - String libelle
        - String explication
        - LocalDateTime createdAt
        --
        + getters/setters
    }
    
    class ReponsePossible {
        - Integer id
        - Question question
        - String libelle
        - Boolean estCorrect
        --
        + getters/setters
    }
    
    class CreneauHoraire {
        - Integer id
        - LocalDate dateExam
        - LocalTime heureDebut
        - LocalTime heureFin
        - Integer dureeMinutes
        - Integer placesDisponibles
        - Boolean estComplet
        - LocalDateTime createdAt
        --
        + getters/setters
    }
    
    class Inscription {
        - Integer id
        - Candidat candidat
        - CreneauHoraire creneau
        - LocalDateTime dateInscription
        - Boolean estConfirme
        --
        + getters/setters
    }
    
    class SessionTest {
        - Integer id
        - Candidat candidat
        - CreneauHoraire creneau
        - String codeSession
        - LocalDateTime dateDebut
        - LocalDateTime dateFin
        - Boolean estTermine
        - Integer scoreTotal
        - Integer scoreMax
        - BigDecimal pourcentage
        --
        + getters/setters
        + calculerPourcentage()
    }
    
    class SessionQuestion {
        - Integer id
        - SessionTest sessionTest
        - Question question
        - Integer ordreAffichage
        - Integer tempsAlloue
        --
        + getters/setters
    }
    
    class ReponseCandidat {
        - Integer id
        - SessionQuestion sessionQuestion
        - ReponsePossible reponsePossible
        - String reponseText
        - Integer tempsReponse
        - LocalDateTime dateReponse
        - Boolean estCorrect
        --
        + getters/setters
    }
    
    class Administrateur {
        - Integer id
        - String username
        - String password
        - String email
        - String nom
        - String prenom
        - Boolean estActif
        - LocalDateTime createdAt
        --
        + getters/setters
    }
    
    class Parametre {
        - Integer id
        - String nomParam
        - String valeur
        - String description
        - LocalDateTime updatedAt
        --
        + getters/setters
    }
}

package "Repositories" {
    interface CandidatRepository {
        + findByEmail(String email)
        + findByCodeSession(String code)
        + findByEstValide(Boolean valide)
    }
    
    interface ThemeRepository {
        + findByNom(String nom)
    }
    
    interface QuestionRepository {
        + findByThemeId(Integer idTheme)
        + findRandomQuestions(Integer idTheme, Integer limit)
    }
    
    interface SessionTestRepository {
        + findByCandidatId(Integer idCandidat)
        + findByCodeSession(String code)
    }
}

package "Services" {
    class CandidatService {
        - CandidatRepository candidatRepository
        - EmailService emailService
        --
        + inscrire(Candidat candidat)
        + validerCandidat(Integer id)
        + rejeterCandidat(Integer id)
        + envoyerCodeSession(Integer id)
        + connecter(String email, String code)
    }
    
    class QuestionService {
        - QuestionRepository questionRepository
        --
        + getQuestionsByTheme(Integer idTheme)
        + generateTest(Integer idTheme, Integer nbQuestions)
    }
    
    class TestService {
        - SessionTestRepository sessionTestRepository
        - SessionQuestionRepository sessionQuestionRepository
        --
        + startSession(Candidat candidat, CreneauHoraire creneau)
        + submitAnswer(Integer idSessionQuestion, ReponseCandidat reponse)
        + finishSession(Integer idSession)
        + calculateScore(Integer idSession)
    }
    
    class EmailService {
        + sendInscriptionConfirmation(Candidat candidat)
        + sendCodeSession(Candidat candidat)
        + sendResultNotification(Candidat candidat)
    }
}

package "REST API" {
    class CandidatResource {
        - CandidatService candidatService
        --
        + POST /candidats/inscription
        + POST /candidats/connexion
        + GET /candidats/profile
    }
    
    class TestResource {
        - TestService testService
        --
        + POST /test/start
        + GET /test/questions/{sessionId}
        + POST /test/answer
        + POST /test/finish
    }
    
    class AdministrationResource {
        - CandidatService candidatService
        - QuestionService questionService
        --
        + GET /admin/candidats
        + POST /admin/candidats/{id}/valider
        + POST /admin/candidats/{id}/rejeter
        + GET /admin/statistics
    }
}

' Relations entre entités
Candidat "1" --> "0..*" Inscription : inscriptions
Candidat "1" --> "0..*" SessionTest : sessions

CreneauHoraire "1" --> "0..*" Inscription : inscriptions
CreneauHoraire "1" --> "0..*" SessionTest : sessions

Theme "1" --> "0..*" Question : questions
TypeQuestion "1" --> "0..*" Question : questions
Question "1" --> "0..*" ReponsePossible : reponsesPossibles

SessionTest "1" --> "0..*" SessionQuestion : sessionQuestions
SessionQuestion "1" --> "0..*" ReponseCandidat : reponsesCandidats
Question "1" --> "0..*" SessionQuestion : sessionQuestions
ReponsePossible "0..1" --> "0..*" ReponseCandidat : reponsesCandidats

' Relations avec les services
CandidatService --> CandidatRepository
CandidatService --> EmailService
QuestionService --> QuestionRepository
TestService --> SessionTestRepository
TestService --> SessionQuestionRepository

' Relations avec les REST controllers
CandidatResource --> CandidatService
TestResource --> TestService
AdministrationResource --> CandidatService
AdministrationResource --> QuestionService

@enduml
```

## 2. Diagramme de Cas d'Utilisation

```plantuml
@startuml
!theme plain

left to right direction
actor "Candidat" as Candidat
actor "Administrateur" as Admin
rectangle "Système de Gestion des Tests" as System

Candidat -- (S'inscrire)
Candidat -- (Se connecter)
Candidat -- (Choisir un créneau)
Candidat -- (Passer un test)
Candidat -- (Voir ses résultats)
Candidat -- (Recevoir code session)

Admin -- (Gérer les candidats)
Admin -- (Valider les inscriptions)
Admin -- (Gérer les questions)
Admin -- (Créer des thèmes)
Admin -- (Définir les créneaux)
Admin -- (Voir les statistiques)
Admin -- (Gérer les résultats)

(Se connecter) .> (S'inscrire) : extends
(Choisir un créneau) .> (S'inscrire) : extends
(Passer un test) .> (Se connecter) : extends
(Voir ses résultats) .> (Passer un test) : extends

@enduml
```

## 3. Diagramme de Séquence - Processus d'Inscription

```plantuml
@startuml
!theme plain

actor Candidat
participant "Frontend React" as Frontend
participant "CandidatResource" as API
participant "CandidatService" as Service
participant "CandidatRepository" as Repository
participant "EmailService" as Email
participant "Base de données" as DB

Candidat -> Frontend: Remplit formulaire d'inscription
Frontend -> API: POST /candidats/inscription
activate API

API -> Service: inscrire(candidat)
activate Service

Service -> Repository: findByEmail(email)
activate Repository
Repository -> DB: SELECT * FROM candidats WHERE email = ?
DB --> Repository: Résultat
Repository --> Service: Candidat ou null
deactivate Repository

alt Email existe déjà
    Service --> API: Erreur "Email déjà utilisé"
    API --> Frontend: 400 Bad Request
    Frontend --> Candidat: Message d'erreur
else Email disponible
    Service -> Repository: save(candidat)
    activate Repository
    Repository -> DB: INSERT INTO candidats...
    DB --> Repository: Candidat sauvegardé
    Repository --> Service: Candidat avec ID
    deactivate Repository
    
    Service -> Email: sendInscriptionConfirmation(candidat)
    activate Email
    Email --> Service: Email envoyé
    deactivate Email
    
    Service --> API: Candidat créé
    deactivate Service
    
    API --> Frontend: 201 Created + candidat
    deactivate API
    
    Frontend --> Candidat: "Inscription réussie"
end

@enduml
```

## 4. Diagramme de Séquence - Processus de Test

```plantuml
@startuml
!theme plain

actor Candidat
participant "Frontend React" as Frontend
participant "TestResource" as API
participant "TestService" as Service
participant "QuestionService" as QService
participant "SessionTestRepository" as STRepo
participant "Timer" as Timer

Candidat -> Frontend: Demande à commencer le test
Frontend -> API: POST /test/start
activate API

API -> Service: startSession(candidat, creneau)
activate Service

Service -> STRepo: save(sessionTest)
activate STRepo
STRepo --> Service: SessionTest avec ID
deactivate STRepo

Service -> QService: generateTest(themeId, nbQuestions)
activate QService
QService --> Service: Liste de questions
deactivate QService

Service -> STRepo: saveSessionQuestions()
activate STRepo
STRepo --> Service: Questions sauvegardées
deactivate STRepo

Service --> API: Session démarrée
deactivate Service

API --> Frontend: 200 OK + sessionId + première question
deactivate API

Frontend -> Candidat: Affiche première question + démarre timer

loop Pour chaque question
    Candidat -> Frontend: Sélectionne réponse
    Frontend -> Timer: Arrête timer
    Frontend -> API: POST /test/answer
    activate API
    API -> Service: submitAnswer(sessionQuestionId, reponse)
    activate Service
    Service --> API: Réponse enregistrée
    deactivate Service
    API --> Frontend: 200 OK
    deactivate API
    
    alt Dernière question
        Frontend -> API: POST /test/finish
        activate API
        API -> Service: finishSession(sessionId)
        activate Service
        Service --> API: Score calculé
        deactivate Service
        API --> Frontend: 200 OK + résultats
        deactivate API
        Frontend -> Candidat: Affiche résultats finaux
    else Pas la dernière
        Frontend -> API: GET /test/questions/{sessionId}
        activate API
        API --> Frontend: 200 OK + question suivante
        deactivate API
        Frontend -> Timer: Redémarre timer
        Frontend -> Candidat: Affiche question suivante
    end
end

@enduml
```

## 5. Diagramme d'Architecture Système

```plantuml
@startuml
!theme plain

package "Frontend" {
    [React.js Application] as Frontend
    [AuthContext] as Auth
    [Components] as Components
}

package "Backend" {
    [WildFly Server] as Server
    [Jakarta EE] as JEE
    [JAX-RS API] as REST
    [JPA/Hibernate] as JPA
}

package "Base de données" {
    [MySQL Server] as MySQL
    [gestion_tests DB] as DB
}

package "Services externes" {
    [Service Email] as Email
}

Frontend --> REST : HTTP/REST API
REST --> JEE : Business Logic
JEE --> JPA : Data Access
JPA --> MySQL : JDBC
MySQL --> DB : Tables

JEE --> Email : SMTP

note right of Frontend
  - React.js
  - React Router
  - Tailwind CSS
  - Axios
end note

note right of Server
  - WildFly 27
  - Jakarta EE 10
  - JAX-RS
  - CDI
end note

note right of MySQL
  - MySQL 8.0
  - 15 tables
  - Relations étrangères
end note

@enduml
```

## 6. Diagramme d'États - Session de Test

```plantuml
@startuml
!theme plain

state "Session de Test" as SessionTest {
    state "Non démarrée" as NotStarted
    state "En cours" as InProgress
    state "En pause" as Paused
    state "Terminée" as Finished
    state "Échouée" as Failed
    
    NotStarted --> InProgress : Démarrer test
    InProgress --> Paused : Mettre en pause
    Paused --> InProgress : Reprendre
    InProgress --> Finished : Terminer test
    InProgress --> Failed : Timeout / Erreur
    Failed --> InProgress : Recommencer
}

[*] --> NotStarted
Finished --> [*]

@enduml
```

## 7. Diagramme de Packages Frontend

```plantuml
@startuml
!theme plain

package "src" {
    package "components" {
        [Navbar.js]
        [ProtectedRoute.js]
    }
    
    package "contexts" {
        [AuthContext.js]
    }
    
    package "pages" {
        package "admin" {
            [AdminDashboard.js]
            [AdminLogin.js]
            [CandidatesManagement.js]
            [DashboardOverview.js]
            [ResultsManagement.js]
            [ScheduleManagement.js]
            [TestsManagement.js]
        }
        
        [Home.js]
        [Inscription.js]
        [Connexion.js]
        [Test.js]
        [Resultats.js]
        [CodeSession.js]
    }
    
    package "services" {
        [api.js]
        [auth.js]
    }
    
    package "utils" {
        [helpers.js]
        [constants.js]
    }
}

[App.js] --> [components]
[App.js] --> [pages]
[App.js] --> [contexts]

[ProtectedRoute.js] --> [AuthContext.js]
[pages] --> [services]
[pages] --> [components]

@enduml
```

## 8. Diagramme de Flux de Données - Inscription

```plantuml
@startuml
!theme plain

node "Navigateur" as Browser
node "Serveur Frontend" as Frontend
node "Serveur Backend" as Backend
node "Base de données" as DB
node "Service Email" as Email

Browser --> Frontend: Formulaire HTML
Frontend --> Browser: Validation JavaScript
Browser --> Backend: POST /api/candidats/inscription
Backend --> DB: Vérification email
DB --> Backend: Email unique?
Backend --> DB: INSERT candidat
DB --> Backend: ID généré
Backend --> Email: Envoi confirmation
Email --> Browser: Email reçu
Backend --> Frontend: Réponse 201
Frontend --> Browser: Message succès

@enduml
```

## Résumé des Diagrammes

Ces diagrammes UML couvrent tous les aspects de votre application :

1. **Diagramme de Classes** : Structure complète du backend avec entités, services, repositories et API REST
2. **Cas d'Utilisation** : Fonctionnalités principales pour les candidats et administrateurs
3. **Séquence - Inscription** : Flux complet d'inscription d'un candidat
4. **Séquence - Test** : Processus complet de passage d'un test avec timer
5. **Architecture Système** : Vue d'ensemble de l'architecture technique
6. **États - Session Test** : Différents états d'une session de test
7. **Packages Frontend** : Organisation du code React.js
8. **Flux de Données** : Circulation des informations lors de l'inscription

Ces diagrammes peuvent être utilisés pour :
- Documenter le projet pour l'équipe de développement
- Former de nouveaux développeurs
- Planifier des évolutions futures
- Auditer et maintenir l'application
