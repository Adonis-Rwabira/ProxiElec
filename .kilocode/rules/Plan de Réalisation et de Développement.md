### **Livrable 5 : Plan de Réalisation et de Développement**

**Nom du Projet :** ProxiElec  
**Version du Document :** 1.0  
**Date :** 17 septembre 2025  
**État :** Finalisé

---

#### **Table des Matières**
1.  [Résumé des Phases du Projet](#1-résumé-des-phases-du-projet)
2.  [Phase 0 : Prérequis et Configuration de l'Environnement](#2-phase-0--prérequis-et-configuration-de-lenvironnement)
3.  [Phase 1 : Construction - Itération 1 (Le Cœur de la Carte)](#3-phase-1--construction---itération-1-le-cœur-de-la-carte)
4.  [Phase 1 : Construction - Itération 2 (La Couche de Données)](#4-phase-1--construction---itération-2-la-couche-de-données)
5.  [Phase 1 : Construction - Itération 3 (Interactions et UI Complète)](#5-phase-1--construction---itération-3-interactions-et-ui-complète)
6.  [Phase 2 : Finalisation et Polissage](#6-phase-2--finalisation-et-polissage)
7.  [Phase 3 : Transition (Préparation au Déploiement)](#7-phase-3--transition-préparation-au-déploiement)
8.  [Séquencement des Dépendances et Tâches Critiques](#8-séquencement-des-dépendances-et-tâches-critiques)

---

### **1. Résumé des Phases du Projet**

Le développement du projet suivra une approche itérative et incrémentale, alignée avec le Processus Unifié.

| Phase           | Objectif Principal                                                              | Livrable Clé                                      |
| :-------------- | :------------------------------------------------------------------------------ | :------------------------------------------------ |
| **Phase 0**     | Préparer l'environnement de développement et les services externes.             | Un poste de travail prêt à l'emploi.              |
| **Construction**| Développer l'ensemble des fonctionnalités du MVP de manière incrémentale.         | Des versions fonctionnelles de l'application.     |
| ↳ **Itération 1** | Mettre en place une carte interactive affichant la position de l'utilisateur. | Une application avec une carte fonctionnelle.     |
| ↳ **Itération 2** | Intégrer la récupération des données (API & Cache) et la logique métier.      | Une application peuplée de données non interactives. |
| ↳ **Itération 3** | Implémenter toutes les interactions utilisateur (détails, filtres, etc.).      | Une version "feature-complete" de l'application.  |
| **Finalisation**| Améliorer la qualité, la robustesse, et tester de manière exhaustive.         | Une version stable et de qualité "release".       |
| **Transition**  | Préparer et packager l'application pour la publication sur les stores.          | Les fichiers binaires signés (`.aab`, `.ipa`).    |

### **2. Phase 0 : Prérequis et Configuration de l'Environnement**

*   **Objectif :** Éliminer tout bloqueur technique avant le début du codage.
*   **Checklist des Tâches :**
    1.  [ ] **Installer Flutter SDK :** S'assurer que `flutter doctor` est sans erreur.
    2.  [ ] **Installer l'IDE :** VS Code avec les extensions `Flutter` et `Dart`.
    3.  [ ] **Installer Git :** Configurer l'authentification avec le dépôt distant (GitHub/GitLab).
    4.  [ ] **Créer le projet Google Cloud :** Activer les API (`Maps SDK for Android/iOS`, `Places API`).
    5.  [ ] **Générer et sécuriser la clé d'API Google Maps.**

### **3. Phase 1 : Construction - Itération 1 (Le Cœur de la Carte)**

*   **Objectif :** Avoir une application testable qui affiche une carte et la position de l'utilisateur.
*   **Plan de Tâches Séquentiel :**
    1.  [ ] **Créer le projet Flutter :** `flutter create ...`
    2.  [ ] **Initialiser le dépôt Git :** `git init`, premier commit, lier au distant.
    3.  [ ] **Définir la structure de dossiers :** `core`, `data`, `presentation`.
    4.  [ ] **Ajouter les dépendances de l'itération :** `google_maps_flutter`, `location`, `flutter_riverpod` dans `pubspec.yaml`.
    5.  [ ] **Configurer Android :** Intégrer la clé API et les permissions dans `AndroidManifest.xml` et `build.gradle`.
    6.  [ ] **Configurer iOS :** Intégrer la clé API dans `AppDelegate.swift` et les permissions dans `Info.plist`.
    7.  [ ] **Coder le `LocationService` :** Créer une classe pour encapsuler la logique de demande de permission et de récupération de la position.
    8.  [ ] **Coder le `MapScreen` (version minimale) :** Créer un `StatefulWidget` qui appelle le `LocationService` et affiche le widget `GoogleMap` avec la position initiale.
    9.  [ ] **Coder le `FloatingActionButton` de recentrage.**
    10. [ ] **Valider sur les deux plateformes (Android & iOS).**
*   **Critère de fin d'itération :** L'application s'ouvre, demande la permission de localisation, affiche la carte centrée sur l'utilisateur, et celui-ci peut se recentrer avec le bouton.

### **4. Phase 1 : Construction - Itération 2 (La Couche de Données)**

*   **Objectif :** Rendre l'application "vivante" en la connectant à une source de données réelle et en implémentant une stratégie de cache.
*   **Plan de Tâches Séquentiel :**
    1.  [ ] **Ajouter les dépendances de l'itération :** `dio`, `sqflite`, `path_provider`.
    2.  [ ] **Coder les modèles de données :** Créer la classe `PointDeVente` avec la méthode `fromJson`.
    3.  [ ] **Coder la source de données API :** Créer `PlacesApiDataSource` utilisant `dio` pour appeler l'endpoint "Nearby Search".
    4.  [ ] **Coder la source de données Locale :** Créer `LocalCacheDataSource` utilisant `sqflite` pour ouvrir la base de données et implémenter les méthodes `get` et `cache`.
    5.  [ ] **Coder l'interface du `PointDeVenteRepository` :** Définir le contrat abstrait.
    6.  [ ] **Coder l'implémentation du `PointDeVenteRepositoryImpl` :** Intégrer la logique "API-first, cache-fallback".
    7.  [ ] **Configurer les `providers` Riverpod :** Créer les providers pour chaque classe de cette couche afin de permettre l'injection de dépendances.
    8.  [ ] **Écrire des tests unitaires** pour le `PointDeVenteRepository` afin de valider la logique de cache sans UI.
*   **Critère de fin d'itération :** La couche de données est complète, testée unitairement et prête à être consommée par un ViewModel.

### **5. Phase 1 : Construction - Itération 3 (Interactions et UI Complète)**

*   **Objectif :** Finaliser toutes les fonctionnalités du MVP et rendre l'application pleinement interactive.
*   **Plan de Tâches Séquentiel :**
    1.  [ ] **Ajouter la dépendance de l'itération :** `url_launcher`.
    2.  [ ] **Coder le `MapViewModel` :** Créer le `StateNotifier` qui dépend du repository, expose l'état de l'UI (`loading`, `data`, `error`) et contient les méthodes (`fetchPoints`, `applyFilter`, etc.).
    3.  [ ] **Connecter `MapScreen` au `MapViewModel` :** Transformer l'écran en `ConsumerWidget`, observer l'état et afficher les marqueurs sur la carte.
    4.  [ ] **Intégrer le Clustering des marqueurs.**
    5.  [ ] **Développer le widget `DetailsBottomSheet` :** Créer le composant UI qui affiche les détails d'un `PointDeVente`.
    6.  [ ] **Implémenter l'interaction de sélection :** Configurer le `onTap` des marqueurs pour afficher l'InfoWindow, puis le Bottom Sheet.
    7.  [ ] **Implémenter le bouton "ITINÉRAIRE"** en utilisant `url_launcher`.
    8.  [ ] **Développer la barre de recherche et les puces de filtre** et les lier aux méthodes correspondantes du ViewModel.
    9.  [ ] **Implémenter la gestion des états** (indicateurs de chargement, messages d'erreur via SnackBar).
*   **Critère de fin d'itération :** L'application est fonctionnellement complète conformément aux spécifications du MVP.

### **6. Phase 2 : Finalisation et Polissage**

*   **Objectif :** Augmenter la qualité globale de l'application.
*   **Checklist des Tâches :**
    1.  [ ] **Implémenter le Thème :** Centraliser les couleurs et la typographie.
    2.  [ ] **Revue de l'UI/UX :** S'assurer que les espacements, les animations et les transitions sont fluides et cohérents.
    3.  [ ] **Tests Manuels Exhaustifs :** Exécuter tous les scénarios utilisateur sur des appareils physiques réels (Android et iOS).
    4.  [ ] **Optimisation des Performances :** Utiliser les DevTools de Flutter pour profiler l'application et identifier d'éventuels goulots d'étranglement.
    5.  [ ] **Revue de Code Complète.**

### **7. Phase 3 : Transition (Préparation au Déploiement)**

*   **Objectif :** Préparer les artefacts nécessaires à la publication.
*   **Checklist des Tâches :**
    1.  [ ] **Créer l'icône de l'application :** Utiliser `flutter_launcher_icons` pour la générer.
    2.  [ ] **Créer le Splash Screen natif :** Utiliser `flutter_native_splash`.
    3.  [ ] **Augmenter les numéros de version/build** dans `pubspec.yaml`.
    4.  [ ] **Pour Android :**
        *   [ ] Configurer la signature de l'application (keystore).
        *   [ ] Exécuter `flutter build appbundle --release`.
    5.  [ ] **Pour iOS :**
        *   [ ] Configurer la signature via Xcode.
        *   [ ] Exécuter `flutter build ipa --release`.
    6.  [ ] **Préparer les métadonnées pour les stores :** Captures d'écran, description, politique de confidentialité.

### **8. Séquencement des Dépendances et Tâches Critiques**

*   **Dépendance Critique Initiale :** L'obtention de la clé d'API Google et sa configuration correcte dans le projet sont absolument prioritaires. Aucune tâche de carte ne peut commencer sans cela.
*   **Ordre de Développement :** L'ordre des itérations est crucial. Il est impossible d'afficher des données (Itération 2) sans avoir une carte fonctionnelle (Itération 1). Il est impossible de créer des interactions riches (Itération 3) sans avoir de données à manipuler.
*   **Tests Continus :** Les tests unitaires de la couche de données (Itération 2) doivent être écrits avant de commencer l'Itération 3 pour garantir que le ViewModel s'appuiera sur une base stable et testée.