-- Base de données pour l'application de gestion des tests en ligne (version MySQL 8)

-- Table des thèmes
CREATE TABLE themes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des types de questions
CREATE TABLE types_question (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- Table des questions
CREATE TABLE questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_theme INT NOT NULL,
    id_type_question INT NOT NULL,
    libelle TEXT NOT NULL,
    explication TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_theme) REFERENCES themes(id),
    FOREIGN KEY (id_type_question) REFERENCES types_question(id)
);

-- Table des réponses possibles
CREATE TABLE reponses_possibles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_question INT NOT NULL,
    libelle VARCHAR(255) NOT NULL,
    est_correct BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_question) REFERENCES questions(id) ON DELETE CASCADE
);

-- Table des candidats
CREATE TABLE candidats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    ecole VARCHAR(100) NOT NULL,
    filiere VARCHAR(100),
    email VARCHAR(150) NOT NULL UNIQUE,
    gsm VARCHAR(20) NOT NULL,
    code_session VARCHAR(10) UNIQUE,
    est_valide BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des créneaux horaires
CREATE TABLE creneaux_horaires (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date_exam DATE NOT NULL,
    heure_debut TIME NOT NULL,
    heure_fin TIME NOT NULL,
    duree_minutes INT NOT NULL,
    places_disponibles INT NOT NULL DEFAULT 1,
    est_complet BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des inscriptions aux créneaux
CREATE TABLE inscriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_candidat INT NOT NULL,
    id_creneau INT NOT NULL,
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    est_confirme BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_candidat) REFERENCES candidats(id),
    FOREIGN KEY (id_creneau) REFERENCES creneaux_horaires(id),
    UNIQUE KEY unique_inscription (id_candidat, id_creneau)
);

-- Table des sessions de test
CREATE TABLE sessions_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_candidat INT NOT NULL,
    id_creneau INT NOT NULL,
    code_session VARCHAR(10) NOT NULL UNIQUE,
    date_debut TIMESTAMP NULL,
    date_fin TIMESTAMP NULL,
    est_termine BOOLEAN DEFAULT FALSE,
    score_total INT DEFAULT 0,
    score_max INT DEFAULT 0,
    pourcentage DECIMAL(5,2) DEFAULT 0,
    FOREIGN KEY (id_candidat) REFERENCES candidats(id),
    FOREIGN KEY (id_creneau) REFERENCES creneaux_horaires(id)
);

-- Table des questions des sessions
CREATE TABLE session_questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_session INT NOT NULL,
    id_question INT NOT NULL,
    ordre_affichage INT NOT NULL,
    temps_alloue INT DEFAULT 120, -- en secondes
    FOREIGN KEY (id_session) REFERENCES sessions_test(id) ON DELETE CASCADE,
    FOREIGN KEY (id_question) REFERENCES questions(id)
);

-- Table des réponses des candidats
CREATE TABLE reponses_candidat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_session_question INT NOT NULL,
    id_reponse_possible INT,
    reponse_text VARCHAR(255),
    temps_reponse INT, -- en secondes
    date_reponse TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    est_correct BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_session_question) REFERENCES session_questions(id),
    FOREIGN KEY (id_reponse_possible) REFERENCES reponses_possibles(id)
);

-- Table des paramètres de l'application
CREATE TABLE parametres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_param VARCHAR(100) NOT NULL UNIQUE,
    valeur VARCHAR(255) NOT NULL,
    description TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table des administrateurs
CREATE TABLE administrateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    est_actif BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour optimisation
CREATE INDEX idx_questions_theme ON questions(id_theme);
CREATE INDEX idx_questions_type ON questions(id_type_question);
CREATE INDEX idx_reponses_question ON reponses_possibles(id_question);
CREATE INDEX idx_candidats_email ON candidats(email);
CREATE INDEX idx_candidats_code ON candidats(code_session);
CREATE INDEX idx_sessions_candidat ON sessions_test(id_candidat);
CREATE INDEX idx_sessions_code ON sessions_test(code_session);
CREATE INDEX idx_session_questions_session ON session_questions(id_session);
CREATE INDEX idx_reponses_session_question ON reponses_candidat(id_session_question);
CREATE INDEX idx_inscriptions_candidat ON inscriptions(id_candidat);
CREATE INDEX idx_inscriptions_creneau ON inscriptions(id_creneau);
CREATE INDEX idx_creneaux_date ON creneaux_horaires(date_exam);
