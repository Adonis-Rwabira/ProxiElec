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
skinparam sequenceMessageAlign center

' --- Style des Participants ---
skinparam actor {
    BackgroundColor #FFEBD6
    BorderColor #B58900
}
skinparam participant {
    BackgroundColor #D6E8FF
    BorderColor #0D47A1
    FontColor Black
}

' --- Style des Notes ---
skinparam note {
  BackgroundColor #FFF8D6
  BorderColor #FFC107
  FontColor Black
  FontSize 11
  Padding 8
}

' --- Style des Groupes (alt, opt, loop) ---
skinparam group {
    BorderColor #6D6875
    BackgroundColor #F5F5F5
    FontColor #333333
}

' --- Définition des Participants ---
actor "Utilisateur" as User

box "Presentation Layer" #LightSkyBlue
    participant ":MapScreen" as View
    participant ":MapViewModel" as ViewModel
end box

box "Domain & Data Layers" #Wheat
    participant ":IPointDeVenteRepository" as Repo
    participant ":IPlacesApiDataSource" as ApiDS
    participant ":ILocalCacheDataSource" as CacheDS
end box

' --- Scénario ---
User -> View: Ouvre l'application
activate View

View -> ViewModel: init() / fetchInitialPoints()
activate ViewModel
ViewModel -> Repo: getPointsInArea(...)
activate Repo

note right of Repo : Le Repository orchestre la récupération des données.

group API First
    Repo -> ApiDS: getNearbyPlaces(...)
    activate ApiDS
    
    note right of ApiDS
        Tentative de récupération
        des données fraîches depuis l'API.
    end note
    
    ApiDS --> Repo: Future<List<PointDeVenteModel>>
    deactivate ApiDS

    Repo -> CacheDS: cachePoints(points)
    activate CacheDS
    note right of CacheDS
        Mise en cache réussie
        des nouvelles données.
    end note
    CacheDS --> Repo
    deactivate CacheDS

    Repo --> ViewModel: List<PointDeVente>
deactivate Repo

ViewModel -> View: Met à jour l'état (state) avec les données
deactivate ViewModel

View --> User: Affiche les marqueurs sur la carte
deactivate View

else Cas d'erreur Réseau

    Repo -> ApiDS: getNearbyPlaces(...)
    activate ApiDS
    ApiDS --[#D32F2F]>> Repo: Lève une NetworkException
    deactivate ApiDS

    note right of Repo #FFD2D2
        L'appel API a échoué.
        Le Repository tente maintenant
        de récupérer depuis le cache.
    end note
    
    Repo -> CacheDS: getPoints()
    activate CacheDS
    CacheDS --> Repo: Future<List<PointDeVenteModel>>
    deactivate CacheDS
    
    Repo --> ViewModel: List<PointDeVente> (depuis le cache)
    deactivate Repo

    ViewModel -> View: Met à jour l'état avec les données du cache
    deactivate ViewModel

    View --> User: Affiche les marqueurs (depuis le cache)
    deactivate View
end
@enduml