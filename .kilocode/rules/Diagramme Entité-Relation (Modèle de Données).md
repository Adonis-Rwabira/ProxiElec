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

' --- Style des Tables (Classes) ---
skinparam class {
  BackgroundColor #D6E8FF ' Un bleu clair pour ProxiElec
  BorderColor #0D47A1
  FontColor Black
  FontSize 12
  RoundCorner 10
}

' --- Style des Notes ---
skinparam note {
  BackgroundColor #FFF8D6 ' Un jaune clair pour les notes
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
}

' --- Macros pour les Tables et Attributs ---
!define Table(name) class name << (T, #0D47A1) >>
!define PK(field) <b><color:DarkRed><&key> field </color></b>
!define FK(field) <b><color:DarkSlateGray><&key> field </color></b>
!define Attr(field) <font color=black><&media-record> field </font>
!define AttrOpt(field) <font color=gray><&media-record> field </font>
!define AttrJson(field) <font color=#2B65EC><&code> field </font>

' --- Définition du Package Principal ---

package "Domaine Principal - ProxiElec MVP" #LightSkyBlue {
    Table(PointDeVente) {
        PK(id) : TEXT
        Attr(nom) : VARCHAR(255)
        Attr(adresse) : TEXT
        Attr(latitude) : REAL
        Attr(longitude) : REAL
        AttrOpt(horaires) : TEXT
        FK(typeId) : TEXT
        AttrJson(servicesJson) : JSON
        -- Timestamps --
        Attr(dateCache) : TIMESTAMPTZ
    }
    note left of PointDeVente
      Entité centrale représentant un lieu
      physique. L'ID est le "place_id" de
      Google pour garantir l'unicité.
      Stocke toutes les informations
      nécessaires pour l'affichage.
    end note

    Table(TypePointVente) {
        PK(id) : INTEGER
        Attr(code) : VARCHAR(50)
        Attr(libelle) : VARCHAR(100)
    }
    note bottom of TypePointVente
      Dictionnaire des catégories
      de points de vente pour permettre
      le filtrage.
      Ex: (AGENCE, "Agence de paiement")
    end note

    Table(Service) {
        PK(id) : INTEGER
        Attr(nom) : VARCHAR(100)
    }
    note right of Service
      Dictionnaire des services
      potentiels. Pour la V1, ces
      données sont dénormalisées
      dans le champ JSON de PointDeVente.
      Cette table est pour référence future.
    end note

    Table(PointService) {
        PK(pointId) : TEXT
        PK(serviceId) : INTEGER
    }
    note bottom of PointService
      Table de jonction pour la relation N-N
      entre PointDeVente et Service.
      Sera implémentée dans une future version
      pour remplacer le champ servicesJson.
    end note
}

' --- Définition des Relations avec Cardinalités et Libellés ---
PointDeVente "0..N" -- "1" TypePointVente : "est de type"

' Relation future (V2)
PointDeVente "1" -- "0..N" PointService : "propose via"
Service "1" -- "0..N" PointService : "est proposé via"

@enduml