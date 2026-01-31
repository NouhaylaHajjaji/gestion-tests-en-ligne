# Diagramme de Cas d'Utilisation - Gestion des Tests en Ligne

```plantuml
@startuml
!theme plain
skinparam actorStyle awesome

left to right direction
actor "Candidat" as Candidat #lightblue
actor "Administrateur" as Admin #lightgreen
rectangle "Système de Gestion des Tests" as System #lightyellow

' Cas d'utilisation du Candidat
Candidat -- (S'inscrire à la plateforme) as UC1
Candidat -- (Se connecter) as UC2
Candidat -- (Choisir un créneau horaire) as UC3
Candidat -- (Passer un test en ligne) as UC4
Candidat -- (Voir ses résultats) as UC5
Candidat -- (Recevoir code de session) as UC6
Candidat -- (Consulter son profil) as UC7

' Cas d'utilisation de l'Administrateur
Admin -- (Gérer les candidats) as UC8
Admin -- (Valider les inscriptions) as UC9
Admin -- (Rejeter les candidatures) as UC10
Admin -- (Envoyer codes de session) as UC11
Admin -- (Gérer les questions) as UC12
Admin -- (Créer des thèmes de test) as UC13
Admin -- (Définir les créneaux horaires) as UC14
Admin -- (Voir les statistiques) as UC15
Admin -- (Gérer les résultats) as UC16
Admin -- (Configurer les paramètres) as UC17
Admin -- (Se connecter à l'admin) as UC18

' Relations d'héritage et d'extension
(Se connecter) .> (S'inscrire à la plateforme) : <<extend>>
(Choisir un créneau horaire) .> (S'inscrire à la plateforme) : <<extend>>
(Passer un test en ligne) .> (Se connecter) : <<include>>
(Voir ses résultats) .> (Passer un test en ligne) : <<extend>>
(Recevoir code de session) .> (Valider les inscriptions) : <<include>>

' Relations d'inclusion pour l'administrateur
(Gérer les candidats) .> (Valider les inscriptions) : <<include>>
(Gérer les candidats) .> (Rejeter les candidatures) : <<include>>
(Gérer les candidats) .> (Envoyer codes de session) : <<include>>
(Gérer les questions) .> (Créer des thèmes de test) : <<include>>

' Notes descriptives
note right of UC1
  Le candidat remplit le formulaire
  d'inscription avec ses informations
  personnelles et académiques
end note

note right of UC4
  Le candidat répond aux questions
  du test avec un timer par question
  et voit son score en temps réel
end note

note right of UC12
  L'administrateur peut ajouter,
  modifier ou supprimer des questions
  et définir les bonnes réponses
end note

@enduml
```

## Description des Cas d'Utilisation

### Pour le Candidat :

1. **S'inscrire à la plateforme (UC1)**
   - Remplir le formulaire d'inscription
   - Valider les informations (email, GSM, école)
   - Recevoir confirmation d'inscription

2. **Se connecter (UC2)**
   - Saisir email et code de session
   - Valider l'authentification
   - Accéder à son espace personnel

3. **Choisir un créneau horaire (UC3)**
   - Consulter les créneaux disponibles
   - Sélectionner une date et heure
   - Confirmer l'inscription au créneau

4. **Passer un test en ligne (UC4)**
   - Démarrer la session de test
   - Répondre aux questions avec timer
   - Soumettre les réponses

5. **Voir ses résultats (UC5)**
   - Consulter le score obtenu
   - Voir les réponses correctes/incorrectes
   - Télécharger l'attestation si réussi

6. **Recevoir code de session (UC6)**
   - Recevoir email avec code unique
   - Utiliser le code pour se connecter

7. **Consulter son profil (UC7)**
   - Voir ses informations personnelles
   - Modifier certaines données
   - Voir l'historique des tests passés

### Pour l'Administrateur :

8. **Gérer les candidats (UC8)**
   - Consulter la liste des candidats
   - Valider ou rejeter les inscriptions
   - Envoyer les codes de session

9. **Valider les inscriptions (UC9)**
   - Vérifier les informations des candidats
   - Approuver les dossiers complets
   - Notifier les candidats

10. **Rejeter les candidatures (UC10)**
    - Identifier les dossiers incomplets
    - Motiver le rejet
    - Notifier les candidats

11. **Envoyer codes de session (UC11)**
    - Générer des codes uniques
    - Envoyer par email
    - Suivre les envois

12. **Gérer les questions (UC12)**
    - Ajouter/modifier/supprimer des questions
    - Définir les types de questions
    - Associer aux thèmes

13. **Créer des thèmes de test (UC13)**
    - Définir les catégories de questions
    - Organiser les questions par thème
    - Gérer les descriptions

14. **Définir les créneaux horaires (UC14)**
    - Créer des plages horaires
    - Définir le nombre de places
    - Gérer les dates d'examen

15. **Voir les statistiques (UC15)**
    - Consulter les taux de réussite
    - Voir les statistiques par thème
    - Exporter les rapports

16. **Gérer les résultats (UC16)**
    - Consulter tous les résultats
    - Valider les scores
    - Générer les attestations

17. **Configurer les paramètres (UC17)**
    - Définir les durées des tests
    - Configurer les seuils de réussite
    - Gérer les paramètres système

18. **Se connecter à l'admin (UC18)**
    - S'authentifier avec identifiants admin
    - Accéder au panneau d'administration
    - Gérer les droits d'accès
