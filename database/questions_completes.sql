-- Script SQL pour ajouter des questions complètes par thème
-- Exécuter ce script après avoir chargé les données de base

-- =============================================
-- MATHÉMATIQUES - Questions supplémentaires
-- =============================================

-- Questions QCM (type 1)
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(1, 1, 'Quelle est la valeur de π (pi) à 2 décimales près ?', 'Constantes mathématiques'),
(1, 1, 'Combien font 15% de 200 ?', 'Pourcentages'),
(1, 1, 'Quel est le périmètre d''un carré de côté 5 cm ?', 'Géométrie'),
(1, 1, 'Combien font 7² (7 au carré) ?', 'Puissances'),
(1, 1, 'Quelle est la racine carrée de 144 ?', 'Racines'),
(1, 1, 'Combien font 3/4 + 1/4 ?', 'Fractions'),
(1, 1, 'Quel est l''aire d''un triangle de base 8 et hauteur 6 ?', 'Géométrie'),
(1, 1, 'Combien font 12 × 15 ?', 'Calcul mental'),
(1, 1, 'Quelle est la médiane de la série : 2, 5, 8, 10, 12 ?', 'Statistiques'),
(1, 1, 'Combien font 2³ (2 au cube) ?', 'Puissances');

-- Questions à choix multiples (type 2)
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(1, 2, 'Quels sont des nombres premiers : 2, 4, 7, 9, 11, 15 ?', 'Nombres premiers'),
(1, 2, 'Quelles sont des figures géométriques : Cercle, Carré, Triangle, Ligne, Point ?', 'Géométrie'),
(1, 2, 'Quels sont des opérateurs mathématiques : +, -, ×, ÷, =, %, √ ?', 'Opérations');

-- =============================================
-- INFORMATIQUE - Questions supplémentaires
-- =============================================

-- Questions QCM (type 1)
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(2, 1, 'Quel langage est principalement utilisé pour le développement web ?', 'Langages de programmation'),
(2, 1, 'Que signifie l''acronyme "URL" ?', 'Terminologie web'),
(2, 1, 'Quel est le rôle d''un firewall ?', 'Sécurité'),
(2, 1, 'Combien d''octets y a-t-il dans 1 kilooctet (Ko) ?', 'Unités de mesure'),
(2, 1, 'Quel protocole est utilisé pour envoyer des emails ?', 'Protocoles réseau'),
(2, 1, 'Que signifie "HTML" ?', 'Technologies web'),
(2, 1, 'Quel est le système d''exploitation le plus utilisé sur smartphones ?', 'OS mobile'),
(2, 1, 'Combien de bits y a-t-il dans un octet ?', 'Unités de base'),
(2, 1, 'Quel algorithme de tri est le plus efficace en moyenne ?', 'Algorithmes'),
(2, 1, 'Que signifie "CSS" en développement web ?', 'Technologies web');

-- Questions à choix multiples (type 2)
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(2, 2, 'Quels sont des langages de programmation : Python, HTML, Java, SQL, CSS, C++ ?', 'Langages'),
(2, 2, 'Quels sont des navigateurs web : Chrome, Firefox, Safari, Excel, Photoshop ?', 'Navigateurs'),
(2, 2, 'Quelles sont des bases de données : MySQL, MongoDB, Oracle, Word, PostgreSQL ?', 'Bases de données');

-- =============================================
-- PHYSIQUE - Questions supplémentaires
-- =============================================

-- Questions QCM (type 1)
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(3, 1, 'Quelle est l''unité SI de la température ?', 'Unités de mesure'),
(3, 1, 'Qui a découvert la radioactivité ?', 'Histoire des sciences'),
(3, 1, 'Quel est le symbole chimique du carbone ?', 'Éléments'),
(3, 1, 'Quelle est la loi d''Ohm ?', 'Électricité'),
(3, 1, 'Combien de planètes y a-t-il dans notre système solaire ?', 'Astronomie'),
(3, 1, 'Quel est le principe de conservation de l''énergie ?', 'Principes physiques'),
(3, 1, 'Quelle est la masse d''un litre d''eau ?', 'Propriétés physiques'),
(3, 1, 'Qui a développé la théorie de la relativité ?', 'Histoire des sciences'),
(3, 1, 'Quel est l''effet Doppler ?', 'Phénomènes physiques'),
(3, 1, 'Quelle est la température absolue zéro en Celsius ?', 'Température');

-- Questions à choix multiples (type 2)
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(3, 2, 'Quels sont des types d''ondes : Sonores, Lumineuses, Électromagnétiques, Statiques ?', 'Ondes'),
(3, 2, 'Quelles sont des unités de force : Newton, Joule, Watt, Pascal, Dyne ?', 'Unités');

-- =============================================
-- CHIMIE - Questions supplémentaires
-- =============================================

-- Questions QCM (type 1)
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(4, 1, 'Quel est le numéro atomique de l''hydrogène ?', 'Tableau périodique'),
(4, 1, 'Quelle est la formule du dioxyde de carbone ?', 'Molécules'),
(4, 1, 'Qui a découvert l''oxygène ?', 'Histoire de la chimie'),
(4, 1, 'Quel est le pH le plus acide ?', 'Acidité'),
(4, 1, 'Combien d''électrons peut contenir la couche L ?', 'Structure atomique'),
(4, 1, 'Quel est le symbole chimique du sodium ?', 'Éléments'),
(4, 1, 'Quelle est la masse molaire de l''eau (H₂O) ?', 'Masse molaire'),
(4, 1, 'Quel type de liaison lie les atomes dans une molécule d''eau ?', 'Liaisons chimiques'),
(4, 1, 'Qui a proposé le tableau périodique moderne ?', 'Histoire des sciences'),
(4, 1, 'Quel est l''état le plus répandu de la matière dans l''univers ?', 'États de la matière');

-- Questions à choix multiples (type 2)
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(4, 2, 'Quels sont des acides : Acide chlorhydrique, Soude, Vinaigre, Eau pure ?', 'Acides et bases'),
(4, 2, 'Quelles sont des réactions chimiques : Combustion, Dissolution, Évaporation, Oxydation ?', 'Types de réactions');

-- =============================================
-- FRANÇAIS - Questions supplémentaires
-- =============================================

-- Questions QCM (type 1)
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(5, 1, 'Quel est le féminin de "loup" ?', 'Genre'),
(5, 1, 'Qui a écrit "Le Petit Prince" ?', 'Littérature'),
(5, 1, 'Quel est le contraire de "chaud" ?', 'Antonymes'),
(5, 1, 'Combien de temps comporte le subjonctif présent ?', 'Conjugaison'),
(5, 1, 'Quel est le participe passé du verbe "voir" ?', 'Participes passés'),
(5, 1, 'Qui a écrit "Candide" ?', 'Littérature'),
(5, 1, 'Quel est le pluriel de "œil" ?', 'Pluriels irréguliers'),
(5, 1, 'Quelle est la fonction grammaticale de "je" dans "Je mange" ?', 'Fonctions grammaticales'),
(5, 1, 'Quel est le synonyme de "malin" ?', 'Synonymes'),
(5, 1, 'Combien de voyelles dans l''alphabet français ?', 'Alphabet');

-- Questions à choix multiples (type 2)
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(5, 2, 'Quels sont des pronoms personnels : Je, Tu, Il, Le, Nous, Vous ?', 'Pronoms'),
(5, 2, 'Quels sont des temps composés : Passé composé, Plus-que-parfait, Futur antérieur, Imparfait ?', 'Temps verbaux');

-- =============================================
-- ANGLAIS - Questions supplémentaires
-- =============================================

-- Questions QCM (type 1)
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(6, 1, 'Comment dit-on "merci" en anglais ?', 'Vocabulaire de base'),
(6, 1, 'Quel est le prétérit du verbe "to go" ?', 'Verbes irréguliers'),
(6, 1, 'Qui a écrit "1984" ?', 'Littérature anglaise'),
(6, 1, 'Quel est le comparatif de "big" ?', 'Comparatifs'),
(6, 1, 'Comment se conjugue "to have" au présent à la 3ème personne ?', 'Conjugaison'),
(6, 1, 'Quel est l''article défini en anglais ?', 'Articles'),
(6, 1, 'Comment dit-on "aujourd''hui" en anglais ?', 'Vocabulaire temporel'),
(6, 1, 'Quel est le superlatif de "beautiful" ?', 'Superlatifs'),
(6, 1, 'Qui a écrit "Hamlet" ?', 'Littérature anglaise'),
(6, 1, 'Comment dit-on "livre" en anglais ?', 'Vocabulaire');

-- Questions à choix multiples (type 2)
INSERT INTO questions (id_theme, id_type_question, libelle, explication) VALUES
(6, 2, 'Quels sont des pays anglophones : USA, Espagne, Inde, Chine, Australie ?', 'Pays anglophones'),
(6, 2, 'Quels sont des temps anglais : Present Perfect, Past Simple, Future Continuous, Subjonctif ?', 'Temps anglais');

-- =============================================
-- RÉPONSES POSSIBLES POUR LES NOUVELLES QUESTIONS
-- =============================================

-- Réponses pour les questions de mathématiques supplémentaires (questions 13-22)
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(13, '3,12', FALSE),
(13, '3,14', TRUE),
(13, '3,16', FALSE),
(13, '3,18', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(14, '20', FALSE),
(14, '25', FALSE),
(14, '30', TRUE),
(14, '35', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(15, '15 cm', FALSE),
(15, '20 cm', TRUE),
(15, '25 cm', FALSE),
(15, '30 cm', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(16, '14', FALSE),
(16, '49', TRUE),
(16, '64', FALSE),
(16, '81', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(17, '10', FALSE),
(17, '11', FALSE),
(17, '12', TRUE),
(17, '13', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(18, '1/2', FALSE),
(18, '1', TRUE),
(18, '3/4', FALSE),
(18, '2', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(19, '24 cm²', TRUE),
(19, '28 cm²', FALSE),
(19, '32 cm²', FALSE),
(19, '36 cm²', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(20, '160', FALSE),
(20, '170', FALSE),
(20, '180', TRUE),
(20, '190', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(21, '5', FALSE),
(21, '8', TRUE),
(21, '10', FALSE),
(21, '12', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(22, '4', FALSE),
(22, '6', FALSE),
(22, '8', TRUE),
(22, '10', FALSE);

-- Réponses pour les questions à choix multiples mathématiques (questions 23-25)
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(23, '2', TRUE),
(23, '4', FALSE),
(23, '7', TRUE),
(23, '9', FALSE),
(23, '11', TRUE),
(23, '15', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(24, 'Cercle', TRUE),
(24, 'Carré', TRUE),
(24, 'Triangle', TRUE),
(24, 'Ligne', FALSE),
(24, 'Point', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(25, '+', TRUE),
(25, '-', TRUE),
(25, '×', TRUE),
(25, '÷', TRUE),
(25, '=', TRUE),
(25, '%', TRUE),
(25, '√', TRUE);

-- Réponses pour les questions d'informatique supplémentaires (questions 26-35)
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(26, 'Python', FALSE),
(26, 'Java', FALSE),
(26, 'JavaScript', TRUE),
(26, 'C++', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(27, 'Universal Resource Locator', TRUE),
(27, 'Uniform Resource Locator', TRUE),
(27, 'Universal Reference Link', FALSE),
(27, 'Uniform Resource Link', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(28, 'Bloquer les virus', FALSE),
(28, 'Filtrer le trafic réseau', TRUE),
(28, 'Accélérer Internet', FALSE),
(28, 'Sauvegarder les données', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(29, '100', FALSE),
(29, '1000', TRUE),
(29, '1024', FALSE),
(29, '1048', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(30, 'HTTP', FALSE),
(30, 'FTP', FALSE),
(30, 'SMTP', TRUE),
(30, 'POP3', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(31, 'HyperText Markup Language', TRUE),
(31, 'High Tech Modern Language', FALSE),
(31, 'HyperText Markup Link', FALSE),
(31, 'Home Tool Markup Language', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(32, 'Android', TRUE),
(32, 'iOS', FALSE),
(32, 'Windows', FALSE),
(32, 'Linux', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(33, '4', FALSE),
(33, '8', TRUE),
(33, '16', FALSE),
(33, '32', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(34, 'Bubble sort', FALSE),
(34, 'Quick sort', TRUE),
(34, 'Selection sort', FALSE),
(34, 'Insertion sort', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(35, 'Computer Style Sheets', FALSE),
(35, 'Creative Style Sheets', FALSE),
(35, 'Cascading Style Sheets', TRUE),
(35, 'Colorful Style Sheets', FALSE);

-- Réponses pour les questions à choix multiples informatique (questions 36-38)
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(36, 'Python', TRUE),
(36, 'HTML', FALSE),
(36, 'Java', TRUE),
(36, 'SQL', FALSE),
(36, 'CSS', FALSE),
(36, 'C++', TRUE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(37, 'Chrome', TRUE),
(37, 'Firefox', TRUE),
(37, 'Safari', TRUE),
(37, 'Excel', FALSE),
(37, 'Photoshop', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(38, 'MySQL', TRUE),
(38, 'MongoDB', TRUE),
(38, 'Oracle', TRUE),
(38, 'Word', FALSE),
(38, 'PostgreSQL', TRUE);

-- Réponses pour les questions de physique supplémentaires (questions 39-48)
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(39, 'Kelvin', TRUE),
(39, 'Celsius', FALSE),
(39, 'Fahrenheit', FALSE),
(39, 'Rankine', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(40, 'Marie Curie', TRUE),
(40, 'Albert Einstein', FALSE),
(40, 'Niels Bohr', FALSE),
(40, 'Ernest Rutherford', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(41, 'C', TRUE),
(41, 'O', FALSE),
(41, 'N', FALSE),
(41, 'Fe', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(42, 'U = R × I', TRUE),
(42, 'P = U × I', FALSE),
(42, 'E = m × c²', FALSE),
(42, 'F = m × a', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(43, '7', FALSE),
(43, '8', TRUE),
(43, '9', FALSE),
(43, '10', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(44, 'L''énergie ne peut être ni créée ni détruite', TRUE),
(44, 'La matière ne peut être ni créée ni détruite', FALSE),
(44, 'La vitesse de la lumière est constante', FALSE),
(44, 'La gravité est universelle', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(45, '1 kg', TRUE),
(45, '0,5 kg', FALSE),
(45, '2 kg', FALSE),
(45, '1,5 kg', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(46, 'Albert Einstein', TRUE),
(46, 'Isaac Newton', FALSE),
(46, 'Stephen Hawking', FALSE),
(46, 'Galileo Galilei', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(47, 'Changement de fréquence d''une onde', TRUE),
(47, 'Réflexion d''une onde', FALSE),
(47, 'Réfraction d''une onde', FALSE),
(47, 'Diffraction d''une onde', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(48, '-273,15°C', TRUE),
(48, '-273°C', FALSE),
(48, '-300°C', FALSE),
(48, '-250°C', FALSE);

-- Réponses pour les questions à choix multiples physique (questions 49-50)
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(49, 'Sonores', TRUE),
(49, 'Lumineuses', TRUE),
(49, 'Électromagnétiques', TRUE),
(49, 'Statiques', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(50, 'Newton', TRUE),
(50, 'Joule', FALSE),
(50, 'Watt', FALSE),
(50, 'Pascal', FALSE),
(50, 'Dyne', TRUE);

-- Réponses pour les questions de chimie supplémentaires (questions 51-60)
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(51, '1', TRUE),
(51, '2', FALSE),
(51, '6', FALSE),
(51, '8', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(52, 'CO₂', TRUE),
(52, 'O₂', FALSE),
(52, 'H₂O', FALSE),
(52, 'N₂', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(53, 'Joseph Priestley', TRUE),
(53, 'Antoine Lavoisier', FALSE),
(53, 'Marie Curie', FALSE),
(53, 'Dmitri Mendeleev', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(54, '0', TRUE),
(54, '1', FALSE),
(54, '7', FALSE),
(54, '14', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(55, '2', FALSE),
(55, '8', TRUE),
(55, '18', FALSE),
(55, '32', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(56, 'Na', TRUE),
(56, 'S', FALSE),
(56, 'K', FALSE),
(56, 'Ca', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(57, '18 g/mol', TRUE),
(57, '16 g/mol', FALSE),
(57, '20 g/mol', FALSE),
(57, '22 g/mol', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(58, 'Covalente', TRUE),
(58, 'Ionique', FALSE),
(58, 'Métallique', FALSE),
(58, 'Hydrogène', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(59, 'Dmitri Mendeleev', TRUE),
(59, 'Antoine Lavoisier', FALSE),
(59, 'Marie Curie', FALSE),
(59, 'Albert Einstein', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(60, 'Gazeux', TRUE),
(60, 'Liquide', FALSE),
(60, 'Solide', FALSE),
(60, 'Plasmique', FALSE);

-- Réponses pour les questions à choix multiples chimie (questions 61-62)
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(61, 'Acide chlorhydrique', TRUE),
(61, 'Soude', FALSE),
(61, 'Vinaigre', TRUE),
(61, 'Eau pure', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(62, 'Combustion', TRUE),
(62, 'Dissolution', FALSE),
(62, 'Évaporation', FALSE),
(62, 'Oxydation', TRUE);

-- Réponses pour les questions de français supplémentaires (questions 63-72)
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(63, 'Loupe', FALSE),
(63, 'Louve', FALSE),
(63, 'Louve', TRUE),
(63, 'Loupes', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(64, 'Victor Hugo', FALSE),
(64, 'Albert Camus', FALSE),
(64, 'Antoine de Saint-Exupéry', TRUE),
(64, 'Jean-Paul Sartre', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(65, 'Froid', TRUE),
(65, 'Tiède', FALSE),
(65, 'Glacial', FALSE),
(65, 'Frais', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(66, '4', FALSE),
(66, '5', FALSE),
(66, '6', TRUE),
(66, '7', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(67, 'Vu', FALSE),
(67, 'Vus', FALSE),
(67, 'Vie', TRUE),
(67, 'Vient', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(68, 'Voltaire', TRUE),
(68, 'Jean-Jacques Rousseau', FALSE),
(68, 'Molière', FALSE),
(68, 'Émile Zola', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(69, 'Yeux', TRUE),
(69, 'Oeils', FALSE),
(69, 'Oeuils', FALSE),
(69, 'Yeulx', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(70, 'Sujet', TRUE),
(70, 'Verbe', FALSE),
(70, 'Complément', FALSE),
(70, 'Attribut', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(71, 'Intelligent', TRUE),
(71, 'Rusé', FALSE),
(71, 'Astucieux', FALSE),
(71, 'Savant', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(72, '5', FALSE),
(72, '6', TRUE),
(72, '7', FALSE),
(72, '8', FALSE);

-- Réponses pour les questions à choix multiples français (questions 73-74)
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(73, 'Je', TRUE),
(73, 'Tu', TRUE),
(73, 'Il', TRUE),
(73, 'Le', FALSE),
(73, 'Nous', TRUE),
(73, 'Vous', TRUE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(74, 'Passé composé', TRUE),
(74, 'Plus-que-parfait', TRUE),
(74, 'Futur antérieur', TRUE),
(74, 'Imparfait', FALSE);

-- Réponses pour les questions d'anglais supplémentaires (questions 75-84)
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(75, 'Thank you', TRUE),
(75, 'Thanks', TRUE),
(75, 'Please', FALSE),
(75, 'Sorry', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(76, 'went', TRUE),
(76, 'goed', FALSE),
(76, 'gone', FALSE),
(76, 'going', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(77, 'George Orwell', TRUE),
(77, 'William Shakespeare', FALSE),
(77, 'Charles Dickens', FALSE),
(77, 'Jane Austen', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(78, 'bigger', TRUE),
(78, 'more big', FALSE),
(78, 'biggest', FALSE),
(78, 'biger', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(79, 'has', TRUE),
(79, 'have', FALSE),
(79, 'haves', FALSE),
(79, 'having', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(80, 'a', FALSE),
(80, 'an', FALSE),
(80, 'the', TRUE),
(80, 'some', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(81, 'today', TRUE),
(81, 'now', FALSE),
(81, 'yesterday', FALSE),
(81, 'tomorrow', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(82, 'most beautiful', TRUE),
(82, 'beautifullest', FALSE),
(82, 'more beautiful', FALSE),
(82, 'beautifulest', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(83, 'William Shakespeare', TRUE),
(83, 'George Orwell', FALSE),
(83, 'Charles Dickens', FALSE),
(83, 'Jane Austen', FALSE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(84, 'book', TRUE),
(84, 'books', FALSE),
(84, 'livre', FALSE),
(84, 'libro', FALSE);

-- Réponses pour les questions à choix multiples anglais (questions 85-86)
INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(85, 'USA', TRUE),
(85, 'Espagne', FALSE),
(85, 'Inde', TRUE),
(85, 'Chine', FALSE),
(85, 'Australie', TRUE);

INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
(86, 'Present Perfect', TRUE),
(86, 'Past Simple', TRUE),
(86, 'Future Continuous', TRUE),
(86, 'Subjonctif', FALSE);

-- =============================================
-- CRÉNEAUX HORAIRES SUPPLÉMENTAIRES
-- =============================================

INSERT INTO creneaux_horaires (date_exam, heure_debut, heure_fin, duree_minutes, places_disponibles) VALUES
('2025-01-15', '09:00:00', '11:00:00', 120, 25),
('2025-01-15', '14:00:00', '16:00:00', 120, 25),
('2025-01-16', '10:00:00', '12:00:00', 120, 30),
('2025-01-16', '15:00:00', '17:00:00', 120, 30),
('2025-01-17', '09:00:00', '11:00:00', 120, 20),
('2025-01-17', '14:00:00', '16:00:00', 120, 20),
('2025-01-18', '10:00:00', '12:00:00', 120, 25),
('2025-01-18', '15:00:00', '17:00:00', 120, 25);

-- =============================================
-- PARAMÈTRES SUPPLÉMENTAIRES
-- =============================================

INSERT INTO parametres (cle_parametre, valeur_parametre, description) VALUES
('NOMBRE_QUESTIONS_PAR_TEST', '20', 'Nombre de questions par test'),
('TEMPS_PAR_QUESTION', '120', 'Temps en secondes par question'),
('SEUIL_REUSSITE', '60', 'Pourcentage minimum pour réussir'),
('ACTIVER_NOTIFICATIONS', 'true', 'Activer les notifications email'),
('DELAI_INSCRIPTION', '24', 'Délai en heures avant le test pour s''inscrire');

-- Pour exécuter ce script :
-- 1. Assurez-vous que la base de données est créée avec schema.sql
-- 2. Chargez les données de base avec data.sql
-- 3. Exécutez ce script pour ajouter les questions supplémentaires
-- mysql -u root -ppro0809 gestion_tests < questions_completes.sql
