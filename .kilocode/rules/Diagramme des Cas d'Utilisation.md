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
skinparam actorStyle awesome

' --- Style des Acteurs ---
skinparam actor {
    BackgroundColor #FFEBD6
    BorderColor #B58900
}

' --- Style des Cas d'Utilisation ---
skinparam usecase {
    BackgroundColor #D6E8FF
    BorderColor #0D47A1
    FontColor Black
    FontSize 12
}
skinparam usecase<< Extend >> {
    ArrowColor #2E8B57
    BorderColor #2E8B57
}
skinparam usecase<< Include >> {
    ArrowColor #4682B4
    BorderColor #4682B4
}

' --- Style des Notes ---
skinparam note {
  BackgroundColor #FFF8D6
  BorderColor #FFC107
  FontColor Black
  FontSize 11
  Padding 8
}

' --- Style du Package (Système) ---
skinparam rectangle {
    FontColor #333333
    BorderColor #6D6875
    FontSize 14
    RoundCorner 10
    StereotypeFontSize 12
}

' --- Acteurs ---
actor "Utilisateur Final" as user
actor "<< Système >>\nAPI Google" as api_google
actor "<< Système >>\nApp Navigation" as app_nav

' --- Cas d'Utilisation dans le Système ---
rectangle "Système ProxiElec" {
    usecase "Consulter les points de vente" as UC1
    usecase "Filtrer par type" as UC2 << Extend >>
    usecase "Voir détails d'un point" as UC3 << Include >>
    usecase "Lancer l'itinéraire" as UC4 << Include >>
    usecase "Rechercher une adresse" as UC5
    usecase "Recentrer sur ma position" as UC6
}

' --- Relations ---
user -- UC1
user -- UC5
user -- UC6

UC1 ..> UC2 : << extends >>
note on link
  L'utilisateur peut optionnellement
  appliquer un filtre pendant la
  consultation de la carte.
end note

UC1 <.. UC3 : << includes >>
note on link
  La consultation de la carte
  implique forcément la possibilité
  de voir les détails d'un point
  pour être complète.
end note

UC3 <.. UC4 : << includes >>
note on link
  Afficher les détails inclut
  la fonctionnalité essentielle
  de pouvoir s'y rendre.
end note


' --- Liens avec les acteurs externes ---
UC1 -- api_google
note on link: Utilise l'API pour les données de carte et les lieux.

UC4 -- app_nav
note on link: Délègue la navigation guidée.

@enduml