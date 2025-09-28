enum ServiceType {
  agency,
  chargingStation,
  kiosk,
}

class ServiceLocation {
  final String name;
  final String address;
  final ServiceType type;
  // Correction majeure : Le package attend une List<double> et non un objet LatLng.
  final List<double> coordinates;

  ServiceLocation({
    required this.name,
    required this.address,
    required this.type,
    required this.coordinates,
  });
}
