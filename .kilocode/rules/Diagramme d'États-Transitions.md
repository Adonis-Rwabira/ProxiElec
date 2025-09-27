```plantuml
@startuml
' --- Configuration Globale du Style (Inspiré de WTE) ---
' skinparam dpi 180
skinparam shadowing true
skinparam backgroundColor #FAFAFA
skinparam defaultFontName Arial
skinparam defaultFontSize 12
' skinparam linetype ortho
skinparam roundcorner 10

' --- Style des États ---
skinparam state {
    BackgroundColor #D6E8FF
    BorderColor #0D47A1
    FontColor Black
    FontSize 12
}
skinparam state<< Error >> {
    BackgroundColor #FFD2D2
    BorderColor #D32F2F
}
skinparam state<< Loading >> {
    BackgroundColor #FFFACD
    BorderColor #FFC107
}

' --- Style des Notes ---
skinparam note {
  BackgroundColor #FFF8D6
  BorderColor #FFC107
  FontColor Black
  FontSize 11
  Padding 8
}

' --- Définition des États ---
state "Initialisation" as Init
state "Chargement des Données" as Loading << Loading >>

state "Carte Prête" as Ready {
    state "Vue Globale" as Overview
    state "Détails Affichés" as Details
    
    Overview --> Details : utilisateur.clicMarqueur()
    Details --> Overview : utilisateur.fermePanneau()
}

state "État d'Erreur" as Error << Error >>

' --- Définition des Transitions ---
[*] --> Init : Lancement de l'écran

Init --> Loading : Permissions de localisation accordées
note on link
  L'écran passe en mode chargement
  dès que les prérequis sont validés.
end note

Init --> Error : Permissions de localisation refusées
note on link: Erreur bloquante initiale.

Loading --> Ready : Données reçues (API ou Cache)
note on link
  L'UI passe à l'état interactif
  une fois les données prêtes à être affichées.
end note

Loading --> Error : Erreur réseau ET cache vide
note on link
  Impossible de récupérer ou d'afficher
  la moindre donnée.
end note

Ready --> Loading : utilisateur.rafraîchit() / utilisateur.déplaceCarte()
note on link
  Une action nécessitant de nouvelles données
  fait repasser l'UI par l'état de chargement
  (qui peut être très bref).
end note

Error --> Loading : utilisateur.clicRéessayer()
note on link
  Permet à l'utilisateur de
  relancer le processus de
  chargement des données.
end note

@enduml