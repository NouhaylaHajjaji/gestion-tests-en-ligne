-- Données initiales pour l'application de gestion des tests en ligne

USE gestion_tests;

-- Insertion des thèmes
INSERT INTO themes (nom, description) VALUES
('Mathématiques', 'Questions sur les mathématiques fondamentales et appliquées'),
('Informatique', 'Questions sur la programmation et les technologies de l''information'),
('Physique', 'Questions sur les principes physiques et applications'),
('Chimie', 'Questions sur la chimie organique et inorganique'),
('Français', 'Questions sur la langue et la littérature française'),
('Anglais', 'Questions sur la langue et la culture anglaise');

-- Insertion des types de questions
INSERT INTO types_question (nom, description) VALUES
('UNIQUE', 'Question à réponse unique - une seule réponse possible'),
('MULTIPLE', 'Question à réponses multiples - plusieurs réponses possibles'),
('TEXTE', 'Question à réponse textuelle libre');

-- Insertion des administrateurs (mot de passe: admin123)
INSERT INTO administrateurs (username, password, email, nom, prenom) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'admin@gestiontests.com', 'Administrateur', 'Système');

-- Insertion des paramètres par défaut
INSERT INTO parametres (nom_param, valeur, description) VALUES
('NOMBRE_QUESTIONS_PAR_THEME', '5', 'Nombre de questions à tirer par thème pour chaque test'),
('TEMPS_QUESTION_PAR_DEFAUT', '120', 'Temps par défaut par question en secondes'),
('TEMPS_AVANT_DEMARRAGE', '5', 'Temps d''attente avant de pouvoir démarrer le test en minutes'),
('VALIDATION_INSCRIPTION', 'true', 'Nécessite une validation admin pour les inscriptions'),
('EMAIL_HOST', 'smtp.gmail.com', 'Serveur SMTP pour l''envoi d''emails'),
('EMAIL_PORT', '587', 'Port du serveur SMTP'),
('EMAIL_USERNAME', '', 'Nom d''utilisateur pour le serveur SMTP'),
('EMAIL_PASSWORD', '', 'Mot de passe pour le serveur SMTP');

-- Insertion des questions exemples
-- Mathématiques
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(1, 1, 'Quelle est la valeur de 2 + 2 ?', 'Addition simple'),
(1, 1, 'Combien font 7 × 8 ?', 'Multiplication'),
(1, 2, 'Quels sont les nombres premiers suivants : 2, 3, 5, 7, 11 ?', 'Identification des nombres premiers'),
(1, 1, 'Quelle est la racine carrée de 64 ?', 'Racine carrée'),
(1, 1, 'Combien font 15% de 200 ?', 'Pourcentage'),
(1, 2, 'Quelles opérations sont correctes : 10+5=15, 8×3=24, 20-5=18, 12÷4=3 ?', 'Vérification d''opérations');

-- Informatique
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(2, 1, 'Quel langage est principalement utilisé pour le développement web frontend ?', 'Langages web'),
(2, 2, 'Quels sont des systèmes de gestion de bases de données : MySQL, PostgreSQL, Excel, MongoDB ?', 'SGBD'),
(2, 1, 'Que signifie l''acronyme API ?', 'Définition technique'),
(2, 1, 'Quel protocole est utilisé pour la communication web sécurisée ?', 'Protocoles réseau'),
(2, 2, 'Quels sont des paradigmes de programmation : Orienté objet, Fonctionnel, Impératif, Visuel ?', 'Paradigmes'),
(2, 1, 'Quel est le rôle d''un compilateur ?', 'Compilation');

-- Physique
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(3, 1, 'Quelle est l''unité SI de la force ?', 'Unités de mesure'),
(3, 1, 'Qui a formulé la loi de la gravitation universelle ?', 'Histoire des sciences'),
(3, 2, 'Quels sont des états de la matière : Solide, Liquide, Gazeux, Plasmique ?', 'États de la matière'),
(3, 1, 'Quelle est la vitesse de la lumière dans le vide ?', 'Constantes physiques'),
(3, 1, 'Quel est le principe d''Archimède ?', 'Principes physiques'),
(3, 2, 'Quelles formes d''énergie existent : Cinétique, Potentielle, Thermique, Magnétique ?', 'Types d''énergie');

-- Chimie
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(4, 1, 'Quel est le symbole chimique de l''or ?', 'Éléments chimiques'),
(4, 1, 'Combien d''électrons peut contenir la couche K d''un atome ?', 'Structure atomique'),
(4, 2, 'Quelles sont des réactions chimiques : Oxydation, Réduction, Neutralisation, Évaporation ?', 'Types de réactions'),
(4, 1, 'Quel est le pH de l''eau pure ?', 'Acidité'),
(4, 1, 'Quelle est la formule chimique de l''eau ?', 'Molécules'),
(4, 2, 'Quels sont des gaz nobles : Hélium, Néon, Argon, Oxygène ?', 'Classification périodique');

-- Français
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(5, 1, 'Quel est le pluriel de "cheval" ?', 'Grammaire'),
(5, 2, 'Quels sont des temps de l''indicatif : Présent, Imparfait, Futur simple, Conditionnel ?', 'Conjugaison'),
(5, 1, 'Qui a écrit "Les Misérables" ?', 'Littérature'),
(5, 1, 'Quel est le synonyme de "rapidement" ?', 'Vocabulaire'),
(5, 1, 'Combien de temps comporte le passé composé ?', 'Grammaire'),
(5, 2, 'Quels sont des figures de style : Métaphore, Comparaison, Allitération, Définition ?', 'Figures de style');

-- Anglais
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(6, 1, 'Comment dit-on "bonjour" en anglais ?', 'Vocabulaire de base'),
(6, 2, 'Quels sont des temps verbaux anglais : Present Simple, Past Continuous, Future Perfect, Subjonctif ?', 'Temps anglais'),
(6, 1, 'Quel est le superlatif de "good" ?', 'Comparatifs et superlatifs'),
(6, 1, 'Qui a écrit "Romeo and Juliet" ?', 'Littérature anglaise'),
(6, 1, 'Comment se conjugue "to be" au présent à la première personne du singulier ?', 'Conjugaison'),
(6, 2, 'Quels sont des pays anglophones : Canada, Australie, France, Nouvelle-Zélande ?', 'Géographie linguistique');

-- Insertion des réponses possibles
-- Réponses pour les questions de mathématiques
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(1, '3', FALSE),
(1, '4', TRUE),
(1, '5', FALSE),
(1, '6', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(2, '54', FALSE),
(2, '56', TRUE),
(2, '58', FALSE),
(2, '60', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(3, '2', TRUE),
(3, '3', TRUE),
(3, '5', TRUE),
(3, '7', TRUE),
(3, '9', FALSE),
(3, '11', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(4, '6', FALSE),
(4, '7', FALSE),
(4, '8', TRUE),
(4, '9', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(5, '25', FALSE),
(5, '30', TRUE),
(5, '35', FALSE),
(5, '40', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(6, '10+5=15', TRUE),
(6, '8×3=24', TRUE),
(6, '20-5=18', FALSE),
(6, '12÷4=3', TRUE);

-- Réponses pour les questions d'informatique
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(7, 'Java', FALSE),
(7, 'JavaScript', TRUE),
(7, 'Python', FALSE),
(7, 'C++', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(8, 'MySQL', TRUE),
(8, 'PostgreSQL', TRUE),
(8, 'Excel', FALSE),
(8, 'MongoDB', TRUE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(9, 'Application Programming Interface', TRUE),
(9, 'Advanced Programming Integration', FALSE),
(9, 'Automated Process Interface', FALSE),
(9, 'Application Process Integration', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(10, 'HTTP', FALSE),
(10, 'HTTPS', TRUE),
(10, 'FTP', FALSE),
(10, 'SSH', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(11, 'Orienté objet', TRUE),
(11, 'Fonctionnel', TRUE),
(11, 'Impératif', TRUE),
(11, 'Visuel', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(12, 'Exécuter le code directement', FALSE),
(12, 'Traduire le code en langage machine', TRUE),
(12, 'Déboguer le code', FALSE),
(12, 'Optimiser le code', FALSE);

-- Réponses pour les questions de physique
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(13, 'Newton', TRUE),
(13, 'Pascal', FALSE),
(13, 'Einstein', FALSE),
(13, 'Coulomb', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(14, 'Solide', TRUE),
(14, 'Liquide', TRUE),
(14, 'Gazeux', TRUE),
(14, 'Plasmique', TRUE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(15, '299 792 458 m/s', TRUE),
(15, '300 000 km/h', FALSE),
(15, '299 792 km/s', FALSE),
(15, '3×10⁸ m/s', TRUE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(16, 'Un corps plongé dans un fluide subit une poussée verticale vers le haut', TRUE),
(16, 'La somme des forces est nulle à l''équilibre', FALSE),
(16, 'L''énergie se conserve', FALSE),
(16, 'L''action est égale à la réaction', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(17, 'Cinétique', TRUE),
(17, 'Potentielle', TRUE),
(17, 'Thermique', TRUE),
(17, 'Magnétique', TRUE);

-- Réponses pour les questions de chimie
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(18, 'Ag', TRUE),
(18, 'Au', FALSE),
(18, 'Go', FALSE),
(18, 'Gd', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(19, '2', TRUE),
(19, '4', FALSE),
(19, '6', FALSE),
(19, '8', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(20, 'Oxydation', TRUE),
(20, 'Réduction', TRUE),
(20, 'Neutralisation', TRUE),
(20, 'Évaporation', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(21, '6', FALSE),
(21, '7', TRUE),
(21, '8', FALSE),
(21, '9', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(22, 'H₂O', TRUE),
(22, 'HO', FALSE),
(22, 'H₂O₂', FALSE),
(22, 'OH', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(23, 'Hélium', TRUE),
(23, 'Néon', TRUE),
(23, 'Argon', TRUE),
(23, 'Oxygène', FALSE);

-- Réponses pour les questions de français
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(24, 'Chevals', FALSE),
(24, 'Chevaux', TRUE),
(24, 'Chevalx', FALSE),
(24, 'Cheveaux', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(25, 'Présent', TRUE),
(25, 'Imparfait', TRUE),
(25, 'Futur simple', TRUE),
(25, 'Conditionnel', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(26, 'Victor Hugo', TRUE),
(26, 'Alexandre Dumas', FALSE),
(26, 'Émile Zola', FALSE),
(26, 'Marcel Proust', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(27, 'Lentement', FALSE),
(27, 'Vite', FALSE),
(27, 'Rapidement', TRUE),
(27, 'Doucement', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(28, '1', FALSE),
(28, '2', TRUE),
(28, '3', FALSE),
(28, '4', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(29, 'Métaphore', TRUE),
(29, 'Comparaison', TRUE),
(29, 'Allitération', TRUE),
(29, 'Définition', FALSE);

-- Réponses pour les questions d'anglais
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(30, 'Hello', TRUE),
(30, 'Hi', FALSE),
(30, 'Good morning', FALSE),
(30, 'Hey', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(31, 'Present Simple', TRUE),
(31, 'Past Continuous', TRUE),
(31, 'Future Perfect', TRUE),
(31, 'Subjonctif', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(32, 'Gooder', FALSE),
(32, 'Better', FALSE),
(32, 'Best', TRUE),
(32, 'Goodest', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(33, 'William Shakespeare', TRUE),
(33, 'Charles Dickens', FALSE),
(33, 'Jane Austen', FALSE),
(33, 'George Orwell', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(34, 'I be', FALSE),
(34, 'I am', TRUE),
(34, 'I is', FALSE),
(34, 'I are', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(35, 'Canada', TRUE),
(35, 'Australie', TRUE),
(35, 'France', FALSE),
(35, 'Nouvelle-Zélande', TRUE);

-- Insertion de quelques créneaux horaires pour les tests
INSERT INTO creneaux_horaires (date_exam, heure_debut, heure_fin, duree_minutes, places_disponibles) VALUES
(CURDATE() + INTERVAL 1 DAY, '09:00:00', '11:00:00', 120, 30),
(CURDATE() + INTERVAL 1 DAY, '14:00:00', '16:00:00', 120, 30),
(CURDATE() + INTERVAL 2 DAY, '10:00:00', '12:00:00', 120, 25),
(CURDATE() + INTERVAL 2 DAY, '15:00:00', '17:00:00', 120, 25),
(CURDATE() + INTERVAL 3 DAY, '09:00:00', '11:00:00', 120, 30),
(CURDATE() + INTERVAL 3 DAY, '14:00:00', '16:00:00', 120, 30);
