# Blueprint: ProxiElec

**Dernière mise à jour :** 27/09/2025 15:20

## Vue d'ensemble

ProxiElec est une application mobile conçue pour aider les utilisateurs à localiser facilement les services liés à l'électricité. L'application fournit une carte interactive, des fonctions de recherche/filtrage et des informations détaillées pour chaque point de service.

---

## Plan Actuel

L'interface utilisateur est complète et fonctionnelle avec des données locales. La priorité absolue est de la connecter à une source de données externe et de mettre en place une architecture de données robuste et performante.

---

## Fonctionnalités Implémentées

**Phase 1: Initialisation et Carte de Base**

*   [x] Initialiser le projet Flutter.
*   [x] Ajouter les dépendances nécessaires (`google_maps_flutter`, `provider`).
*   [x] Créer un widget de carte de base.
*   [x] Afficher un marqueur d'exemple sur la carte.
*   [x] Mettre en place la gestion de l'état de base pour le thème (clair/sombre).
*   [x] Configuration de la clé API Google Maps pour Android (avec espace réservé).

**Phase 2: Amélioration de l'Interface Utilisateur et Personnalisation du Thème**

*   [x] Ajouter `google_fonts` pour une typographie plus riche.
*   [x] Créer un thème complet pour les modes clair et sombre.
*   [x] Appliquer les polices personnalisées au thème.
*   [x] Affiner la mise en page de l'écran d'accueil avec un `FloatingActionButton.extended`.

**Phase 3: Interaction avec la Carte et Services de Localisation**

*   [x] Ajouter le package `geolocator`.
*   [x] Demander les autorisations de localisation (Android & iOS).
*   [x] Centrer la carte sur la position de l'utilisateur au démarrage.
*   [x] Ajouter un bouton pour recentrer manuellement la carte.

**Phase 4: Modélisation des Données et Affichage de Marqueurs Multiples**

*   [x] Créer un modèle de données `ServiceLocation`.
*   [x] Créer une liste de données factices de `ServiceLocation`.
*   [x] Transformer la liste de données en `Marker`s.
*   [x] Afficher les marqueurs multiples sur la carte.
*   [x] Personnaliser l'apparence des marqueurs par type de service.

**Phase 5: Affichage des Détails du Service**

*   [x] Créer un widget de panneau inférieur (`BottomSheet`).
*   [x] Mettre à jour l'état pour suivre le service sélectionné.
*   [x] Afficher le panneau inférieur au clic sur un marqueur.
*   [x] Concevoir l'interface du panneau inférieur.
*   [x] Ajouter un bouton "Itinéraire".

**Phase 6: Recherche, Filtrage et Navigation**

*   [x] Ajouter un champ de recherche dans la barre d'application.
*   [x] Filtrer la liste des services en fonction du texte de recherche.
*   [x] Mettre à jour les marqueurs sur la carte pour n'afficher que les résultats filtrés.
*   [x] Ajouter des boutons de filtre pour basculer la visibilité des types de services.
*   [x] Implémenter la fonctionnalité "Itinéraire" en utilisant `url_launcher`.

---

## Fonctionnalités Implémentées (Phases 1-6)

*   **Phase 1: Initialisation et Carte de Base :** Mise en place du projet, du thème et de la carte initiale (remplacée depuis par `universe`).
*   **Phase 2: Amélioration de l'UI :** Intégration de polices personnalisées (`google_fonts`) et création d'un thème complet.
*   **Phase 3: Interaction avec la Carte (Legacy) :** Implémentation initiale de la géolocalisation.
*   **Phase 4: Modélisation et Marqueurs :** Création du modèle `ServiceLocation`, affichage de marqueurs multiples à partir de données factices.
*   **Phase 5: Affichage des Détails :** Création et déclenchement du `BottomSheet` pour les détails du service.
*   **Phase 6: Recherche, Filtrage et Navigation :** Implémentation complète de la recherche, du filtrage et du lancement d'itinéraire externe (`url_launcher`).
*   **Refactoring Technique :** Remplacement de `google_maps_flutter` par `universe` et adaptation de toute l'application à sa nouvelle API.

---

## Prochaine Étape : Itération 2 - Architecture et Couche de Données

L'objectif est de construire une couche de données découplée de l'interface, suivant les meilleures pratiques de la *Clean Architecture*.

### **1. Définir l'Architecture et les Contrats**

*   **Action :** Créer la structure de dossiers suivante pour séparer clairement les responsabilités :
    *   `lib/domain/entities` : Contiendra notre classe `ServiceLocation`.
    *   `lib/domain/repositories` : Contiendra le contrat (l'interface) de notre `PointDeVenteRepository`.
    *   `lib/data/datasources` : Contiendra les sources de données (locale et distante).
    *   `lib/data/repositories` : Contiendra l'implémentation concrète du repository.
    *   `lib/data/models` : (Optionnel) Pour les modèles de données spécifiques à l'API, si différents de nos entités.
*   **Action :** Créer le fichier `lib/domain/repositories/point_de_vente_repository.dart`.
*   **Décision Technique :** Ce fichier définira une classe abstraite `PointDeVenteRepository` avec une méthode principale : `Future<List<ServiceLocation>> getPoints(LatLng center, double radius)`. L'UI dépendra uniquement de ce contrat, jamais de son implémentation.

### **2. Implémenter la Source de Données Locale (Cache)**

*   **Action :** Ajouter les dépendances `sqflite` et `path_provider` au `pubspec.yaml`.
*   **Action :** Créer la classe `LocalDataSource` dans `lib/data/datasources/local_data_source.dart`.
*   **Décision Technique :** Utiliser `sqflite` pour créer une base de données SQLite simple. Elle contiendra une table `service_locations` avec des colonnes correspondant au modèle `ServiceLocation`. Des méthodes comme `cachePoints(List<ServiceLocation> points)` et `Future<List<ServiceLocation>> getCachedPoints()` seront implémentées.

### **3. Amorçage de la Base de Données (Seeding)**

*   **Action :** Au premier lancement de la base de données (lors de sa création), la méthode `onCreate` de `sqflite` sera utilisée pour insérer un jeu de données initial.
*   **Décision Stratégique :** Les données `_dummyData` actuellement dans `main.dart` (les points de Goma) seront utilisées comme données de *seeding*. Cela garantit que l'application affiche immédiatement des informations pertinentes au premier lancement, même avant le premier appel API, et qu'elle reste fonctionnelle hors-ligne si l'utilisateur n'a jamais eu de connexion.

### **4. Implémenter la Source de Données API**

*   **Action :** Ajouter la dépendance `dio` au `pubspec.yaml`.
*   **Action :** Créer la classe `ApiDataSource` dans `lib/data/datasources/api_data_source.dart`.
*   **Décision Technique :** Cette classe sera responsable de l'appel à une API externe (nous utiliserons un placeholder gratuit comme [JSONPlaceholder](https://jsonplaceholder.typicode.com/) le temps de choisir un service de cartographie final). Elle gérera la transformation de la réponse JSON en objets `ServiceLocation`.

### **5. Implémenter le Repository**

*   **Action :** Créer la classe `PointDeVenteRepositoryImpl` dans `lib/data/repositories/point_de_vente_repository_impl.dart`.
*   **Décision Technique :** Cette classe implémentera `PointDeVenteRepository`. Sa méthode `getPoints` contiendra la logique métier : 
    1.  Tenter d'appeler `apiDataSource.getPoints()`.
    2.  Si l'appel réussit : 
        *   Mettre à jour le cache en appelant `localDataSource.cachePoints()`.
        *   Retourner les données fraîches de l'API.
    3.  Si l'appel échoue (pas de réseau) : 
        *   Appeler `localDataSource.getCachedPoints()`.
        *   Retourner les données du cache.
        *   Lever une exception personnalisée si le cache est également vide.

### **6. Intégrer le Repository à l'UI avec `FutureProvider`**

*   **Action :** Refactoriser la gestion d'état.
*   **Décision Technique :** Nous allons utiliser le `provider` `FutureProvider` de Riverpod (ou l'équivalent avec `provider`). Il appellera la méthode `getPoints` de notre repository. Le widget `MapScreen` consommera ce provider et utilisera son état (`data`, `error`, `loading`) pour afficher un indicateur de chargement, un message d'erreur ou la liste des marqueurs, éliminant ainsi la gestion manuelle de l'état asynchrone.

