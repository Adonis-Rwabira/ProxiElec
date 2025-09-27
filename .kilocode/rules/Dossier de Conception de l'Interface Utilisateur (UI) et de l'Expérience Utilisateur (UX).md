### **Livrable 4 : Dossier de Conception de l'Interface Utilisateur (UI) et de l'Expérience Utilisateur (UX)**

**Nom du Projet :** ProxiElec  
**Version du Document :** 1.0  
**Date :** 17 septembre 2025  
**État :** Finalisé

---

#### **Table des Matières**
1.  [Charte Graphique et Style Visuel](#1-charte-graphique-et-style-visuel)
    *   1.1. Palette de Couleurs
    *   1.2. Typographie
    *   1.3. Iconographie
2.  [Wireframes et Maquettes des Écrans](#2-wireframes-et-maquettes-des-écrans)
    *   2.1. Écran de Démarrage (Splash Screen)
    *   2.2. Écran Principal (Map Screen)
    *   2.3. Panneau de Détails (Details Bottom Sheet)
3.  [Flux d'Interaction et Scénarios Utilisateur](#3-flux-dinteraction-et-scénarios-utilisateur)
    *   3.1. Scénario : Premier Lancement et Demande de Permission
    *   3.2. Scénario : Exploration et Consultation d'un Point de Vente
    *   3.3. Scénario : Gestion des Erreurs (Pas de Connexion / Localisation)

---

### **1. Charte Graphique et Style Visuel**

#### **1.1. Palette de Couleurs**

La palette est choisie pour inspirer confiance, technologie et énergie, tout en garantissant une excellente lisibilité.

| Rôle                | Couleur                                                              | HEX       | Usage                                                              |
| :------------------ | :------------------------------------------------------------------- | :-------- | :----------------------------------------------------------------- |
| **Primaire**        | ![#0D47A1](https://via.placeholder.com/15/0D47A1/000000?text=+) Bleu Profond | `#0D47A1` | AppBar, Boutons d'action principaux (Itinéraire), Icônes actives. |
| **Secondaire**      | ![#FFC107](https://via.placeholder.com/15/FFC107/000000?text=+) Ambre      | `#FFC107` | Puces de filtre actives, accents visuels, indicateurs de chargement. |
| **Arrière-plan**    | ![#F5F5F5](https://via.placeholder.com/15/F5F5F5/000000?text=+) Blanc Cassé | `#F5F5F5` | Fond des panneaux (Bottom Sheet), zones hors-carte.              |
| **Surface**         | ![#FFFFFF](https://via.placeholder.com/15/FFFFFF/000000?text=+) Blanc     | `#FFFFFF` | Fond de la barre de recherche et des puces de filtre.                |
| **Texte Principal** | ![#212121](https://via.placeholder.com/15/212121/000000?text=+) Noir Profond | `#212121` | Titres, corps de texte principal.                                  |
| **Texte Secondaire**| ![#757575](https://via.placeholder.com/15/757575/000000?text=+) Gris       | `#757575` | Sous-titres, textes d'aide, informations moins importantes.      |
| **Erreur**          | ![#D32F2F](https://via.placeholder.com/15/D32F2F/000000?text=+) Rouge      | `#D32F2F` | Messages d'erreur, SnackBar d'alerte.                             |

#### **1.2. Typographie**

La police `Roboto` est choisie pour sa lisibilité sur les écrans mobiles et son intégration native dans l'écosystème Material Design.

| Élément                    | Police         | Graisse (Weight) | Taille (Size) |
| :------------------------- | :------------- | :--------------- | :------------ |
| **Titre d'AppBar**         | Roboto         | Medium           | 20pt          |
| **Titre (Panneau Détails)**| Roboto         | Bold             | 22pt          |
| **Sous-titre**             | Roboto         | Regular          | 16pt          |
| **Corps de texte**         | Roboto         | Regular          | 14pt          |
| **Bouton**                 | Roboto         | Medium           | 14pt          |
| **Texte de Puce**          | Roboto         | Regular          | 13pt          |

#### **1.3. Iconographie**

*   **Source :** Bibliothèque `Material Design Icons` intégrée à Flutter.
*   **Style :** Icônes au style "Filled" pour une meilleure visibilité.
*   **Exemples d'icônes :**
    *   `Icons.my_location` : Bouton de recentrage.
    *   `Icons.location_on` : Adresse.
    *   `Icons.schedule` : Horaires.
    *   `Icons.apps` : Services.
    *   `Icons.directions` : Bouton d'itinéraire.
    *   `Icons.search` : Barre de recherche.
    *   `Icons.bolt` : Marqueur pour Borne VE.
    *   `Icons.corporate_fare` : Marqueur pour Agence.
    *   `Icons.storefront` : Marqueur pour Kiosque.

### **2. Wireframes et Maquettes des Écrans**

#### **2.1. Écran de Démarrage (Splash Screen)**
*   **Description :** Écran simple et éphémère affiché au lancement de l'application.
*   **Layout :**
    *   Fond : Couleur Primaire (`#0D47A1`).
    *   Centre : Logo de ProxiElec (une icône stylisée d'épingle de carte avec un éclair).
    *   Bas : Nom "ProxiElec" en typographie blanche.
*   **Animation :** Le logo apparaît avec un léger fondu (fade-in).

#### **2.2. Écran Principal (Map Screen)**
*   **Description :** L'écran central de l'application, superposant des contrôles sur une carte interactive.
*   **Layout (en `Stack` de bas en haut) :**
    1.  **Widget `GoogleMap` :** Occupe tout l'écran. Style de carte "Silver" pour ne pas surcharger visuellement. Affiche les marqueurs/clusters et le marqueur bleu de la position de l'utilisateur.
    2.  **`FloatingActionButton` (Recentrer) :**
        *   **Position :** En bas à droite, au-dessus de la carte.
        *   **Apparence :** Cercle de couleur Primaire (`#0D47A1`) avec une icône `Icons.my_location` blanche.
    3.  **Barre de Contrôles Supérieure (dans une `Column` avec un `Padding`) :**
        *   **`SearchBar` (Barre de Recherche) :**
            *   **Position :** En haut, centrée, avec une marge par rapport au statut bar.
            *   **Apparence :** Widget `Card` avec une légère élévation, des coins arrondis. Contient une icône `Icons.search` et un texte indicatif "Rechercher une ville, une adresse...".
        *   **`FilterChips` (Puces de Filtre) :**
            *   **Position :** Juste en dessous de la barre de recherche.
            *   **Apparence :** Une `Row` ou `Wrap` de `ChoiceChip`s ("Tous", "Agences", "Bornes VE", "Kiosques").
                *   **Style Inactif :** Fond blanc, bordure grise, texte gris.
                *   **Style Actif :** Fond Secondaire (`#FFC107`), pas de bordure, texte noir.

#### **2.3. Panneau de Détails (Details Bottom Sheet)**
*   **Description :** Panneau modal qui glisse depuis le bas de l'écran pour afficher les informations d'un point de vente sélectionné.
*   **Layout (dans une `Column` avec un `Padding`) :**
    1.  **`Drag Handle` (Poignée) :** Petite barre grise centrée en haut pour indiquer la possibilité de glisser.
    2.  **`Titre` :** Le nom du point de vente, sur 1 ou 2 lignes.
    3.  **`Sous-titre` :** Une `Row` contenant :
        *   La distance calculée (ex: "à 500m").
        *   Un point de séparation "•".
        *   Le type du point de vente dans un `Chip` (ex: "Agence de paiement").
    4.  **`Ligne d'Information` (Répétée pour chaque info) :** Une `Row` contenant :
        *   Une `Icon` (ex: `Icons.location_on`).
        *   Un `SizedBox` pour l'espacement.
        *   Un `Text` flexible pour l'information (ex: l'adresse complète).
        *   *Lignes à inclure : Adresse, Horaires, Services.*
    5.  **`Bouton Itinéraire` :**
        *   **Position :** En bas du panneau, avec une marge.
        *   **Apparence :** Un `ElevatedButton` pleine largeur.
        *   **Style :** Fond de couleur Primaire (`#0D47A1`), texte "ITINÉRAIRE" en majuscules blanches, précédé d'une icône `Icons.directions`.

### **3. Flux d'Interaction et Scénarios Utilisateur**

#### **3.1. Scénario : Premier Lancement et Demande de Permission**
1.  **Lancement :** L'utilisateur ouvre l'app. L'écran de démarrage s'affiche pendant 2s.
2.  **Demande de Permission :** Une boîte de dialogue native du système d'exploitation (iOS/Android) s'affiche : "Autoriser ProxiElec à accéder à la position de cet appareil ?".
3.  **Cas 1 : L'utilisateur accepte.**
    *   La boîte de dialogue disparaît.
    *   L'écran de la carte s'affiche. Un indicateur de chargement (`CircularProgressIndicator`) est brièvement visible.
    *   La carte s'anime pour se centrer sur la position de l'utilisateur.
    *   Les marqueurs des points de vente à proximité apparaissent.
4.  **Cas 2 : L'utilisateur refuse.**
    *   La boîte de dialogue disparaît.
    *   L'écran de la carte s'affiche, centré sur une position par défaut (ex: capitale du pays).
    *   Un `SnackBar` apparaît en bas avec le message : "Activez la localisation pour trouver les points proches de vous." et un bouton "PARAMÈTRES" qui ouvre les réglages de l'application.

#### **3.2. Scénario : Exploration et Consultation d'un Point de Vente**
1.  **Navigation :** L'utilisateur déplace la carte avec son doigt (`drag`) ou zoome (`pinch`).
2.  **Mise à jour :** Après chaque fin de mouvement (`onCameraIdle`), un indicateur de chargement apparaît brièvement et les marqueurs se mettent à jour pour la nouvelle zone visible.
3.  **Sélection :** L'utilisateur appuie sur un marqueur.
4.  **InfoWindow :** Une petite bulle d'information apparaît au-dessus du marqueur, contenant uniquement le nom du point de vente. La carte se recentre légèrement sur ce point.
5.  **Demande de Détails :** L'utilisateur appuie sur l'InfoWindow.
6.  **Affichage du Panneau :** Le `DetailsBottomSheet` glisse depuis le bas avec une animation fluide, affichant toutes les informations du point sélectionné.
7.  **Action :** L'utilisateur appuie sur le bouton "ITINÉRAIRE".
8.  **Redirection :** L'application ProxiElec se met en arrière-plan et l'application de navigation par défaut de l'utilisateur (Google Maps, Waze) s'ouvre, pré-remplie avec l'itinéraire vers le point de vente.

#### **3.3. Scénario : Gestion des Erreurs (Pas de Connexion / Localisation)**
*   **Cas 1 : Perte de Connexion Internet**
    *   L'utilisateur ouvre l'application ou se déplace sur la carte.
    *   Si l'appel API échoue, un `SnackBar` rouge (`#D32F2F`) apparaît en bas : "Aucune connexion internet. Les données affichées peuvent ne pas être à jour."
    *   L'application affiche les derniers points de vente qu'elle avait mis en cache (si disponibles).
*   **Cas 2 : GPS Désactivé**
    *   Au lancement ou en appuyant sur le bouton de recentrage, si le système détecte que la localisation est désactivée au niveau de l'appareil.
    *   Une boîte de dialogue s'affiche : "Veuillez activer les services de localisation pour que ProxiElec puisse trouver votre position." avec les boutons "ANNULER" and "ACTIVER" (qui ouvre les paramètres de localisation de l'appareil).