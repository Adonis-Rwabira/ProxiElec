
### **Livrable 1 : Dossier de Vision et de Périmètre du Projet**

**Nom du Projet :** ProxiElec  
**Version du Document :** 1.0  
**Date :** 17 septembre 2025  
**État :** Finalisé

---

#### **Table des Matières**
1.  [Vision du Produit](#1-vision-du-produit)
2.  [Problématique et Solution Proposée](#2-problématique-et-solution-proposée)
3.  [Proposition de Valeur Clé](#3-proposition-de-valeur-clé)
4.  [Identification des Acteurs](#4-identification-des-acteurs)
5.  [Délimitation du Périmètre (Scope)](#5-délimitation-du-périmètre-scope)

---

### **1. Vision du Produit**

> Fournir une application mobile multiplateforme, simple, fiable et intuitive, permettant à tout utilisateur de localiser rapidement sur une carte interactive les points de vente et de service d'électricité à proximité, de consulter leurs informations essentielles et d'obtenir un itinéraire pour s'y rendre en un minimum de clics.

### **2. Problématique et Solution Proposée**

#### **2.1. Le Problème**

Actuellement, les usagers font face à plusieurs difficultés pour trouver un service lié à l'électricité :
*   **Manque d'information centralisée :** Les informations sur les agences de paiement, les bornes de recharge pour véhicules électriques (VE) ou les kiosques de vente prépayée sont dispersées, souvent obsolètes ou difficiles à trouver via une simple recherche web.
*   **Inefficacité et Perte de Temps :** Les utilisateurs, qu'ils soient résidents locaux ou de passage (touristes, professionnels), perdent un temps précieux à chercher le point de service le plus proche, surtout en situation d'urgence (batterie de VE faible, facture à régler avant échéance).
*   **Incertitude :** Il est difficile de connaître à l'avance les informations cruciales comme les horaires d'ouverture, les services exacts proposés ou même l'adresse précise, menant à des déplacements inutiles.

#### **2.2. La Solution : ProxiElec**

ProxiElec est une application mobile qui répond directement à ces problèmes en :
*   **Centralisant l'information :** L'application agrège et affiche tous les types de points de service sur une seule et même interface.
*   **Utilisant la Géolocalisation :** Elle identifie instantanément la position de l'utilisateur pour lui présenter les options les plus pertinentes et les plus proches.
*   **Fournissant des Données Fiables :** Elle affiche des informations claires et détaillées pour chaque point (adresse, horaires, services), permettant à l'utilisateur de faire un choix éclairé avant de se déplacer.

### **3. Proposition de Valeur Clé**

| Bénéfice pour l'Utilisateur | Description |
| :-------------------------- | :---------------------------------------------------------------------------------------------------------------------------- |
| **Gain de Temps Immédiat**  | Trouver le point de service adéquat le plus proche en moins de 10 secondes après avoir ouvert l'application.                  |
| **Fiabilité et Confiance**  | Accéder à des informations vérifiées et à jour, réduisant le risque de se déplacer pour rien.                                 |
| **Simplicité d'Utilisation**| Une interface épurée et une expérience utilisateur intuitive centrées sur la tâche principale : trouver et se rendre à un point. |
| **Universalité**            | Une solution unique pour différents besoins : paiement de factures, recharge de véhicule électrique, achat de crédit prépayé. |

### **4. Identification des Acteurs**

| Type d'Acteur | Nom de l'Acteur | Description | Besoins Clés |
| :------------ | :-------------- | :-------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| **Primaire**  | **Utilisateur Final** | Toute personne physique ayant besoin d'un service lié à l'électricité. Ce groupe se segmente en plusieurs personas. | |
|               | ↳ **Le Résident Local** | Personne payant régulièrement ses factures ou utilisant des services prépayés. Connaît la zone mais pas tous les points. | Trouver l'agence la moins bondée ou le kiosque ouvert tard le soir. Connaître les horaires d'ouverture. |
|               | ↳ **Le Conducteur de VE** | Possesseur d'un véhicule électrique, nomade par nature, ayant besoin de planifier ses recharges. | Localiser les bornes de recharge compatibles, connaître leur type (rapide/normale). La disponibilité est un plus. |
|               | ↳ **Le Visiteur / Professionnel** | Personne de passage (touriste, commercial) ne connaissant pas la région et ayant un besoin ponctuel. | Trouver le point le plus proche de sa position actuelle (hôtel, rdv) sans aucune connaissance préalable de la zone. |
| **Secondaire**| **Systèmes Externes** | Systèmes et services avec lesquels ProxiElec doit interagir pour fonctionner. | |
|               | ↳ **API Google Maps/Places** | Fournit les fonds de carte, les données de géolocalisation, les informations sur les lieux et les données d'itinéraire. | L'application doit pouvoir envoyer des requêtes valides et interpréter correctement les réponses JSON. |
|               | ↳ **Application de Navigation Externe** | Google Maps, Waze, Plans (iOS). L'application qui prendra en charge la navigation guidée. | L'application doit pouvoir lancer une intention (intent) avec des coordonnées de destination valides. |

### **5. Délimitation du Périmètre (Scope)**

#### **5.1. Dans le Périmètre (Version 1.0 - Minimum Viable Product)**

Les fonctionnalités suivantes constituent le cœur de la première version de l'application :

*   **F-01 : Géolocalisation Automatique :** Détection de la position de l'utilisateur et centrage de la carte.
*   **F-02 : Affichage sur Carte Interactive :** Visualisation des points de vente sous forme de marqueurs sur une carte Google Maps.
*   **F-03 : Clustering de Marqueurs :** Regroupement automatique des marqueurs à des niveaux de zoom faibles pour une meilleure lisibilité.
*   **F-04 : Recherche à Proximité :** Chargement automatique des points de vente dans la zone visible de la carte.
*   **F-05 : Fiche d'Information Détaillée :** Affichage d'un panneau avec le nom, l'adresse, la distance, les horaires et les services d'un point sélectionné.
*   **F-06 : Lancement d'Itinéraire :** Intégration avec les applications de navigation externes pour guider l'utilisateur vers un point sélectionné.
*   **F-07 : Filtrage par Type :** Possibilité de filtrer les points de vente affichés par catégorie (Agence, Borne VE, Kiosque).
*   **F-ax-08 : Recherche Manuelle par Adresse :** Permettre à l'utilisateur de rechercher un lieu différent de sa position actuelle.

#### **5.2. Hors du Périmètre (Versions Futures Possibles)**

Les fonctionnalités suivantes sont explicitement exclues de la version 1.0 pour assurer une livraison rapide et ciblée, mais constituent une feuille de route pour les évolutions futures :

*   **Système de Compte Utilisateur :** Pas d'inscription, de connexion ou de profil utilisateur.
*   **Gestion des Favoris :** Pas de possibilité de sauvegarder des points de vente.
*   **Avis et Notations :** Les utilisateurs ne pourront pas laisser d'avis ou noter les points de vente.
*   **Disponibilité en Temps Réel :** Pas d'information sur l'état actuel des bornes de recharge (disponible, occupée, en panne).
*   **Paiements In-App :** Aucune transaction financière ne sera effectuée via l'application.
*   **Mode Hors-Ligne :** L'application nécessitera une connexion internet active pour la plupart de ses fonctionnalités.
*   **Interface d'Administration :** Pas de back-office permettant aux propriétaires de points de vente de gérer leurs informations.
*   **Affichage d'Itinéraire In-App :** Le tracé de l'itinéraire ne sera pas dessiné dans ProxiElec ; cette tâche est déléguée à une application externe.