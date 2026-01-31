# Guide de Test - Ajout de Créneaux

## Problème Résolu
L'erreur "erreur de connexion au serveur" lors de l'ajout d'un créneau a été résolue.

## Modifications Effectuées

### 1. Correction du contexte de l'application
- **Problème** : Le frontend pointait vers `http://localhost:8080` au lieu de `http://localhost:8080/gestion-tests-backend`
- **Solution** : Modification des URLs dans le frontend pour utiliser le contexte correct

### 2. Résolution du problème de sérialisation
- **Problème** : Jackson ne pouvait pas sérialiser les objets `LocalDate`
- **Solution** : Ajout d'une configuration Jackson et modification des ressources REST

### 3. URLs corrigées dans le frontend
- `ScheduleManagement.js` : `fetchCreneaux`, `handleSubmit`, `handleDelete`
- `Inscription.js` : `fetchCreneaux`, `onSubmit`

## Test de l'API

### 1. Lister tous les créneaux
```bash
curl -X GET http://localhost:8080/gestion-tests-backend/api/admin/creneaux
```
**Résultat attendu** : Status 200 avec la liste des créneaux

### 2. Ajouter un créneau
```bash
curl -X POST http://localhost:8080/gestion-tests-backend/api/admin/creneaux \
  -H "Content-Type: application/json" \
  -d '{"dateExam":"2026-01-10","heureDebut":"14:00","dureeMinutes":120,"placesDisponibles":25}'
```
**Résultat attendu** : Status 201 avec le créneau créé

### 3. Modifier un créneau
```bash
curl -X PUT http://localhost:8080/gestion-tests-backend/api/admin/creneaux/7 \
  -H "Content-Type: application/json" \
  -d '{"dateExam":"2026-01-10","heureDebut":"15:00","dureeMinutes":90,"placesDisponibles":20}'
```
**Résultat attendu** : Status 200 avec le créneau modifié

### 4. Supprimer un créneau
```bash
curl -X DELETE http://localhost:8080/gestion-tests-backend/api/admin/creneaux/7
```
**Résultat attendu** : Status 200 avec message de confirmation

## Test de l'Interface Web

### Accès à l'interface
1. Ouvrir `http://localhost:3000` dans le navigateur
2. Naviguer vers la section administration
3. Accéder à "Gestion des Créneaux"

### Test d'ajout de créneau
1. Cliquer sur "Ajouter un créneau"
2. Remplir le formulaire :
   - Date : 2026-01-11
   - Heure de début : 10:00
   - Durée : 120 minutes
   - Places : 30
3. Cliquer sur "Ajouter"
4. **Résultat attendu** : Message de succès et le créneau apparaît dans la liste

### Test de modification
1. Cliquer sur l'icône d'édition d'un créneau existant
2. Modifier les champs
3. Cliquer sur "Modifier"
4. **Résultat attendu** : Message de succès et les modifications apparaissent

### Test de suppression
1. Cliquer sur l'icône de suppression d'un créneau
2. Confirmer la suppression
3. **Résultat attendu** : Message de succès et le créneau disparaît de la liste

## Vérification finale

### Frontend
- [ ] L'interface s'affiche correctement
- [ ] La liste des créneaux se charge
- [ ] L'ajout de créneau fonctionne
- [ ] La modification fonctionne
- [ ] La suppression fonctionne

### Backend
- [ ] L'API répond correctement
- [ ] Les créneaux sont sauvegardés en base de données
- [ ] Les erreurs sont gérées correctement

## Dépannage

Si l'erreur persiste :
1. Vérifier que WildFly est en cours d'exécution (port 8080)
2. Vérifier que le frontend est en cours d'exécution (port 3000)
3. Vérifier la connexion à la base de données MySQL
4. Redémarrer les services si nécessaire

## Notes
- L'application backend est déployée sur le contexte `/gestion-tests-backend`
- Les CORS sont configurés pour autoriser les requêtes du frontend
- La sérialisation des dates est maintenant gérée correctement
