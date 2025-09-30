import '../../domain/point_de_vente_repository.dart';
import '../../domain/service_location.dart';

class DummyPointDeVenteRepository implements PointDeVenteRepository {
  final List<ServiceLocation> _dummyData = [
    ServiceLocation(
      name: 'ENEO Agence Les Volcans',
      address: 'Avenue des Volcans, Goma',
      type: ServiceType.agency,
      coordinates: [-1.678, 29.231],
    ),
    ServiceLocation(
      name: 'Borne de recharge KivuWatt',
      address: 'Près du lac Kivu, Goma',
      type: ServiceType.chargingStation,
      coordinates: [-1.685, 29.225],
    ),
    ServiceLocation(
      name: 'Kiosque prépayé Birere',
      address: 'Marché de Birere, Goma',
      type: ServiceType.kiosk,
      coordinates: [-1.669, 29.235],
    ),
    // --- Trois nouvelles entrées --- 
    ServiceLocation(
      name: 'ENEO Agence Himbi',
      address: 'Avenue de la Paix, Goma',
      type: ServiceType.agency,
      coordinates: [-1.670, 29.220],
    ),
    ServiceLocation(
      name: 'Kiosque prépayé Alanine',
      address: 'Boulevard Kanyamuhanga, Goma',
      type: ServiceType.kiosk,
      coordinates: [-1.682, 29.239],
    ),
    ServiceLocation(
      name: 'Borne de recharge TMK',
      address: 'Rond-point Signers, Goma',
      type: ServiceType.chargingStation,
      coordinates: [-1.675, 29.245],
    ),
  ];

  @override
  Future<List<ServiceLocation>> getPoints() async {
    // Simule une latence réseau
    await Future.delayed(const Duration(seconds: 1));
    return _dummyData;
  }
}
