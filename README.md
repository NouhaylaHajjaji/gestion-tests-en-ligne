# 🎯 Gestion des Tests en Ligne

Application web complète pour la gestion de tests en ligne avec inscription de candidats, passage de tests et administration.

## 📋 Objectif

Permettre aux candidats de s'inscrire, choisir des créneaux horaires, passer des tests en ligne et consulter leurs résultats, tandis que les administrateurs gèrent l'ensemble du processus.

## 🏗️ Architecture

- **Frontend** : React.js avec Tailwind CSS
- **Backend** : Jakarta EE avec WildFly 27
- **Base de données** : MySQL 8.0
- **Serveur web** : Apache avec phpMyAdmin

## 🚀 Démarrage Rapide

### Prérequis
- Java 11+
- Node.js 16+
- MySQL 8.0
- WildFly 27
- Apache/XAMPP

### Installation

1. **Base de données**
   ```bash
   # Importer le schéma
   mysql -u root -p gestion_tests < database/schema_mysql8.sql
   ```

2. **Backend**
   ```bash
   cd backend
   mvn clean package
   # Copier le WAR dans WildFly
   cp target/gestion-tests-backend.war C:/wildfly27/standalone/deployments/
   ```

3. **Frontend**
   ```bash
   cd frontend
   npm install
   npm start
   ```

### Configuration

- **WildFly** : Configurer la datasource MySqlDS
- **MySQL** : Utilisateur root/root
- **Apache** : Virtual Host pour phpMyAdmin

## 🎬 Démo Vidéo

[📹 Lien vers la vidéo explicative](lien-video-ici)

## 📁 Structure du Projet

```
gestion/
├── backend/                 # Application Jakarta EE
│   ├── src/main/java/      # Code source Java
│   ├── src/main/resources/ # Configuration
│   └── pom.xml            # Maven
├── frontend/               # Application React
│   ├── src/               # Code source
│   ├── public/            # Assets statiques
│   └── package.json       # NPM
├── database/              # Scripts SQL
│   ├── schema_mysql8.sql  # Schéma MySQL 8
│   └── schema.sql         # Schéma original
├── diagrammes/            # Diagrammes UML
│   ├── cas_utilisation.uml
│   ├── classes.uml
│   └── deployment.uml
└── README.md
```

## 🔧 Fonctionnalités

### Candidats
- ✅ Inscription en ligne
- ✅ Choix des créneaux horaires
- ✅ Passage de tests avec timer
- ✅ Consultation des résultats
- ✅ Réception par email du code de session

### Administrateurs
- ✅ Gestion des candidats
- ✅ Validation des inscriptions
- ✅ Gestion des questions et thèmes
- ✅ Configuration des créneaux
- ✅ Statistiques et rapports

## 🌐 Accès à l'application

- **Frontend** : http://localhost:3000
- **Backend API** : http://localhost:8080/gestion-tests-backend/api/
- **Administration WildFly** : http://localhost:9990/console (admin/admin123)
- **phpMyAdmin** : http://localhost/phpmyadmin (root/root)

## 🛠️ Technologies Utilisées

### Frontend
- React.js 18
- React Router
- Tailwind CSS
- Axios
- React Hot Toast

### Backend
- Jakarta EE 10
- JAX-RS (REST API)
- JPA/Hibernate
- CDI
- Maven

### Infrastructure
- WildFly 27
- MySQL 8.0
- Apache HTTP Server
- Node.js

## 📈 Statistiques

- **15 tables** dans la base de données
- **18 cas d'utilisation** identifiés
- **3 couches** d'architecture (Entity, Service, API)
- **6 composants** de déploiement

---

## Fonctionnalités principales
- Inscription des candidats avec validation
- Gestion des créneaux horaires
- Tests aléatoires par thème
- Timer automatique par question
- Résultats instantanés
- Interface d'administration 
