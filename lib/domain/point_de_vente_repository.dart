import 'service_location.dart';

abstract class PointDeVenteRepository {
  Future<List<ServiceLocation>> getPoints();
}
