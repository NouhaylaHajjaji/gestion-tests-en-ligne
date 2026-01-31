# Processus d'Inscription et Validation

## 🔄 **Nouveau processus corrigé**

Le code de session n'est plus généré lors de l'inscription mais uniquement après validation par l'administrateur.

### 1. **Étape 1 : Inscription** 📝
- Le candidat remplit le formulaire d'inscription
- **Aucun code session n'est généré** à ce stade
- Statut : `estValide = false`
- Email de confirmation envoyé : "Inscription enregistrée, en attente de validation"

### 2. **Étape 2 : Validation par l'administrateur** ✅
- L'administrateur consulte la liste des candidats en attente
- Il valide le candidat via l'interface d'administration
- **Le code session est généré automatiquement** lors de la validation
- Statut : `estValide = true`
- Email envoyé avec le code session

### 3. **Étape 3 : Réception du code session** 🔑
- Le candidat reçoit un email avec son code session unique
- Il peut récupérer son code via la page `/code-session`
- Le code permet d'accéder au test le jour J

## 📧 **Emails envoyés**

### Email 1 : Confirmation d'inscription
```
Sujet: Inscription enregistrée - En attente de validation

Bonjour [Prénom Nom],

Votre inscription a bien été enregistrée pour le test du [Date].

Votre inscription est actuellement en attente de validation par l'administrateur.

Vous recevrez un email avec votre code de session dès que votre inscription sera validée.

Cordialement,
L'équipe de gestion des tests
```

### Email 2 : Validation avec code session
```
Sujet: Inscription validée - Votre code de session

Bonjour [Prénom Nom],

Votre inscription a été validée !

Votre code de session est : [CODE_SESSION]

Conservez ce code précieusement, il vous servira à :
- Vous identifier le jour du test
- Accéder à vos résultats

Informations du créneau :
- Date : [Date]
- Heure : [Heure]

À très bientôt !
```

## 🛠️ **Interface d'administration**

### Validation des candidats
1. Accéder à `/admin`
2. Section "Gestion des Candidats"
3. Onglet "Candidats en attente"
4. Cliquer sur "Valider" pour chaque candidat

### Actions disponibles
- **Valider** : Génère le code session et envoie l'email
- **Supprimer** : Refuse l'inscription
- **Voir détails** : Consulte les informations du candidat

## 🔍 **Récupération du code session**

### Page dédiée
- URL : `/code-session`
- Fonction : Recherche par email
- Affiche : Statut de validation et code si disponible

### Cas possibles
1. **Candidat validé** : Affiche le code session
2. **Candidat en attente** : Message d'attente de validation
3. **Email non trouvé** : Message d'erreur

## ⚠️ **Points importants**

### Sécurité
- Le code session est unique et généré aléatoirement
- 8 caractères alphanumériques
- Généré uniquement après validation administrative

### Traçabilité
- Chaque génération de code est loguée
- Email de notification systématique
- Historique des validations conservé

### UX/UI
- Messages clairs à chaque étape
- Statut visible pour le candidat
- Interface de validation simple pour l'admin

## 🧪 **Tests à effectuer**

### Test 1 : Flux complet
1. S'inscrire avec un nouvel email
2. Vérifier que aucun code n'est affiché
3. Se connecter en admin et valider le candidat
4. Vérifier la réception de l'email avec code
5. Tester la récupération du code

### Test 2 : Cas d'erreur
1. Inscrire un candidat
2. Essayer de récupérer le code avant validation
3. Vérifier le message d'attente
4. Valider puis récupérer le code

### Test 3 : Interface admin
1. Accéder à l'interface d'administration
2. Vérifier la liste des candidats en attente
3. Tester la validation
4. Vérifier les emails envoyés

---

**Note** : Ce processus garantit que seuls les candidats validés par l'administration reçoivent un code d'accès aux tests.
