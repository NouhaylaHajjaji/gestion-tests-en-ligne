# Guide de Création de Questions

## 📋 Deux méthodes pour créer des questions

### Méthode 1 : Via l'interface web (Recommandé)

1. **Accédez à l'administration**
   - Allez sur `http://localhost:3000`
   - Connectez-vous avec : `admin` / `admin123`
   - Cliquez sur "Tests" dans le menu

2. **Créez une nouvelle question**
   - Cliquez sur "Ajouter une question"
   - Remplissez les champs :
     - **Thème** : Choisissez parmi les 6 thèmes disponibles
     - **Type de question** : 
       - QCM (une seule bonne réponse)
       - Choix multiples (plusieurs bonnes réponses possibles)
     - **Question** : Écrivez votre question
     - **Explication** : (Optionnel) Ajoutez une explication

3. **Ajoutez les réponses**
   - Pour QCM : Ajoutez 4 réponses, cochez la bonne réponse
   - Pour Choix multiples : Ajoutez plusieurs réponses, cochez toutes les bonnes réponses
   - Cliquez sur "Enregistrer"

### Méthode 2 : Via SQL (Pour les experts)

1. **Exécutez le script complet**
   ```bash
   cd d:\gestion\database
   charger_toutes_donnees.bat
   ```

2. **Ou manuellement**
   ```sql
   -- Ajouter une question QCM
   INSERT INTO questions (id_theme, id_type_question, libelle, explication) 
   VALUES (1, 1, 'Votre question ici', 'Explication optionnelle');
   
   -- Ajouter les réponses (remplacez 1 par l'ID de votre question)
   INSERT INTO reponses_possibles (id_question, libelle, est_correct) VALUES
   (1, 'Réponse A', FALSE),
   (1, 'Réponse B', TRUE),  -- Bonne réponse
   (1, 'Réponse C', FALSE),
   (1, 'Réponse D', FALSE);
   ```

## 🎯 Thèmes disponibles

| ID | Thème | Description |
|----|-------|-------------|
| 1 | Mathématiques | Calcul, géométrie, statistiques |
| 2 | Informatique | Programmation, web, réseaux |
| 3 | Physique | Mécanique, électricité, optique |
| 4 | Chimie | Molécules, réactions, éléments |
| 5 | Français | Grammaire, littérature, vocabulaire |
| 6 | Anglais | Vocabulaire, grammaire, culture |

## 📝 Types de questions

### Type 1 : QCM (Une seule bonne réponse)
- 4 propositions possibles
- Une seule bonne réponse
- Parfait pour les connaissances factuelles

**Exemple :**
```
Question: Quelle est la capitale de la France ?
□ Londres
✓ Paris
□ Berlin
□ Madrid
```

### Type 2 : Choix multiples (Plusieurs bonnes réponses)
- 4 à 6 propositions possibles
- Une ou plusieurs bonnes réponses
- Idéal pour les listes et catégories

**Exemple :**
```
Question: Quels sont des pays européens ?
□ Chine
✓ France
✓ Allemagne
□ Brésil
✓ Italie
```

## 🚀 Conseils pour de bonnes questions

1. **Clarté** : Formulez des questions précises et sans ambiguïté
2. **Pertinence** : Assurez-vous que les réponses sont plausibles
3. **Difficulté** : Variez le niveau de difficulté
4. **Explications** : Ajoutez des explications pour l'apprentissage
5. **Vérification** : Testez toujours vos questions avant de les publier

## 📊 Statistiques actuelles

Après avoir exécuté le script `questions_completes.sql`, vous aurez :
- **86 questions** au total
- **~15 questions par thème**
- **~4-6 réponses par question**
- **8 créneaux horaires** disponibles
- **6 thèmes** couverts

## 🔧 Maintenance

Pour vérifier l'état de votre base de données :
```sql
-- Nombre de questions par thème
SELECT t.nom, COUNT(q.id) as nb_questions 
FROM themes t 
LEFT JOIN questions q ON t.id = q.id_theme 
GROUP BY t.id, t.nom;

-- Questions sans réponses
SELECT q.id, q.libelle 
FROM questions q 
LEFT JOIN reponses_possibles r ON q.id = r.id_question 
WHERE r.id_question IS NULL;
```

## 🎉 Prochaines étapes

1. Chargez les données avec le script batch
2. Testez l'interface web
3. Créez vos propres questions
4. Organisez des sessions de test
5. Analysez les résultats

Bonne création ! 🚀
