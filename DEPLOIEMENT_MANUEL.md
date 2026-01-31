# Guide de Déploiement Manuel - Backend

## 🚨 **Problème actuel**
Les candidats s'enregistrent en base de données mais ne s'affichent pas dans l'administration car l'application n'a pas été redéployée avec les dernières modifications.

## 📋 **Étapes de déploiement**

### Étape 1 : Compiler l'application
```bash
cd d:\gestion\backend
mvn clean package
```

### Étape 2 : Localiser le fichier WAR
Le fichier généré se trouve dans :
```
d:\gestion\backend\target\gestion-tests-backend.war
```

### Étape 3 : Déployer sur WildFly

#### Option A : Via la console d'administration
1. Ouvrir : http://localhost:8080/console
2. Se connecter avec les identifiants admin
3. Aller dans "Deployments"
4. Cliquer sur "Add Content"
5. Sélectionner le fichier `gestion-tests-backend.war`
6. Cliquer "Next" puis "Finish"

#### Option B : Par copie directe
1. Localiser le répertoire de déploiement WildFly :
   ```
   C:\wildfly\standalone\deployments\
   ```
2. Copier le fichier WAR dans ce répertoire
3. WildFly détectera et déploiera automatiquement

### Étape 4 : Vérifier le déploiement
1. Attendre 30-60 secondes
2. Vérifier les logs WildFly si nécessaire
3. Tester l'API :
   ```bash
   curl -X GET http://localhost:8080/gestion-tests-backend/api/admin/candidats
   ```

## 🔧 **Modifications nécessitant le déploiement**

### Backend
- ✅ Endpoint `GET /api/admin/candidats` ajouté
- ✅ Sérialisation simplifiée pour éviter les erreurs lazy loading
- ✅ Endpoints de validation/rejet/envoi de code
- ✅ Gestion des erreurs améliorée

### Frontend
- ✅ URLs corrigées avec chemin complet
- ✅ Gestion du format de réponse
- ✅ Actions d'administration fonctionnelles

## 🧪 **Tests après déploiement**

### Test 1 : API des candidats
```bash
# PowerShell
Invoke-WebRequest -Uri "http://localhost:8080/gestion-tests-backend/api/admin/candidats" -Method GET -UseBasicParsing

# Attendu : Status 200 avec liste des candidats
```

### Test 2 : Interface d'administration
1. Ouvrir : http://localhost:3000/admin
2. Cliquer sur "Candidats"
3. Vérifier que la liste s'affiche

### Test 3 : Validation d'un candidat
1. Sélectionner un candidat "En attente"
2. Cliquer sur l'icône de validation (✓)
3. Vérifier que le statut change

## 📊 **Résultat attendu**

Après déploiement :
- ✅ Les candidats inscrits s'affichent dans l'administration
- ✅ Les actions de validation/rejet fonctionnent
- ✅ Les codes session sont générés après validation
- ✅ Les emails de notification sont envoyés

## 🚨 **Si le problème persiste**

1. **Vérifier les logs WildFly** :
   - Console : http://localhost:8080/console
   - Fichier : `wildfly/standalone/log/server.log`

2. **Redémarrer WildFly** :
   ```bash
   # Services Windows
   net stop wildfly
   net start wildfly
   ```

3. **Vérifier la base de données** :
   ```sql
   SELECT id, nom, prenom, email, estValide FROM gestion_tests.candidats;
   ```

---

**Note importante** : Tant que l'application n'est pas redéployée, les modifications ne seront pas visibles. Le déploiement est obligatoire pour que les candidats s'affichent correctement.
