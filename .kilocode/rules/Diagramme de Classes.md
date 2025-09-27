```plantuml
@startuml
' --- Configuration Globale du Style (Inspiré de WTE) ---
' skinparam dpi 180
skinparam classAttributeIconSize 0
skinparam shadowing true
skinparam backgroundColor #FAFAFA
skinparam defaultFontName Arial
skinparam defaultFontSize 12
' skinparam linetype ortho
skinparam roundcorner 10

' --- Style des Classes et Interfaces ---
skinparam class {
  BackgroundColor #D6E8FF
  BorderColor #0D47A1
  ArrowColor #6D6875
  FontSize 12
}
skinparam interface {
  BackgroundColor #FFFFFF
  BorderColor #0D47A1
}
skinparam enum {
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

' --- Style des Packages ---
skinparam package {
    FontColor #333333
    BorderColor #6D6875
    FontSize 14
    StereotypeFontSize 12
}

' --- Couche de Présentation (UI) ---
package "Presentation Layer (View & ViewModel)" #LightSkyBlue {
    class MapScreen << (W, #FFC107) Widget >> {
        + build(BuildContext context, WidgetRef ref)
    }
    note top of MapScreen
        La Vue, un Widget Flutter.
        Son rôle est d'afficher l'état
        et de notifier le ViewModel
        des actions utilisateur.
    end note

    class MapViewModel << (N, #FFC107) Notifier >> {
        - ref: Ref
        - _repository: IPointDeVenteRepository
        --
        + state: AsyncValue<MapState>
        --
        + fetchPointsInArea()
        + applyFilter(TypePointVente type)
        + selectPoint(String pointId)
    }
    note right of MapViewModel
        Le "cerveau" de la Vue.
        Il contient la logique de présentation
        et expose l'état de l'UI.
        Ne connaît pas la Vue.
    end note

    class MapState << (S, #FFC107) State >> {
        + markers: Set<Marker>
        + selectedPoint: PointDeVente?
        + isLoading: boolean
        + error: String?
    }
    note bottom of MapState : Objet immuable représentant l'état de l'UI.
}

' --- Couche de Domaine (Logique Métier) ---
package "Domain Layer (Contracts & Entities)" #Wheat {
    interface IPointDeVenteRepository {
        + getPointsInArea(MapBounds bounds): Future<List<PointDeVente>>
    }
    note left of IPointDeVenteRepository
        Le contrat (l'interface) que le
        ViewModel utilise. Il définit "ce que"
        la couche de données doit faire,
        pas "comment".
    end note

    class PointDeVente << (E, #F4A261) Entity >> {
        + id: String
        + nom: String
        + adresse: String
        + coordonnees: CoordonneesGPS
        + type: TypePointVente
    }

    class CoordonneesGPS << (V, #F4A261) ValueObject >> {
        + latitude: double
        + longitude: double
    }

    enum TypePointVente {
        AGENCE_PAIEMENT
        BORNE_RECHARGE
        KIOSQUE_PREPAYE
    }
}

' --- Couche de Données (Implémentation) ---
package "Data Layer (Sources & Implementation)" #Pink {
    class PointDeVenteRepositoryImpl {
        - _apiDataSource: IPlacesApiDataSource
        - _localDataSource: ILocalCacheDataSource
        --
        + getPointsInArea(MapBounds bounds): Future<List<PointDeVente>>
    }
    note bottom of PointDeVenteRepositoryImpl
        Implémentation concrète du Repository.
        Orchestre les appels entre l'API
        et le cache local.
    end note

    interface IPlacesApiDataSource {
        + getNearbyPlaces(lat, lng): Future<List<PointDeVenteModel>>
    }

    interface ILocalCacheDataSource {
        + getPoints(): Future<List<PointDeVenteModel>>
        + cachePoints(List<PointDeVenteModel> points)
    }
    
    class PointDeVenteModel << (M, #6D6875) Model >> {
        + place_id: String
        + name: String
        ...
        --
        + fromJson(Map json)
        + toEntity(): PointDeVente
    }
    note right of PointDeVenteModel
        Modèle de données spécifique à la source
        (ici, calqué sur le JSON de l'API).
        Contient la logique de sérialisation
        et la conversion vers l'entité du domaine.
    end note
}

' --- Relations entre les couches ---
MapScreen ..> MapViewModel : "notifie"
MapViewModel ..> MapState : "expose"
MapViewModel --> IPointDeVenteRepository : "dépend de"

IPointDeVenteRepository <|.. PointDeVenteRepositoryImpl : "implémente"
PointDeVenteRepositoryImpl --> IPlacesApiDataSource : "utilise"
PointDeVenteRepositoryImpl --> ILocalCacheDataSource : "utilise"

IPlacesApiDataSource ..> PointDeVenteModel : "retourne"
ILocalCacheDataSource ..> PointDeVenteModel : "gère"
PointDeVenteModel ..> PointDeVente : "se transforme en"

PointDeVente *-- CoordonneesGPS
PointDeVente *-- TypePointVente

@enduml