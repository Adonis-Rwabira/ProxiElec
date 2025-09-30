import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:universe/universe.dart';

import 'data/dummy_point_de_vente_repository.dart';
import 'domain/point_de_vente_repository.dart';
import 'domain/service_location.dart';
import 'service_details_panel.dart';
import 'splash_screen.dart'; // Importer le nouvel écran

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        Provider<PointDeVenteRepository>(
            create: (_) => DummyPointDeVenteRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Colors.indigo;

    final TextTheme appTextTheme = TextTheme(
      displayLarge:
          GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.openSans(fontSize: 14),
      labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
    );

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primarySeedColor,
        foregroundColor: Colors.white,
        titleTextStyle:
            GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primarySeedColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle:
              GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        titleTextStyle:
            GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primarySeedColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle:
              GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'ProxiElec',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(), // MODIFIÉ ICI
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final MapController _mapController = MapController();
  final Location _location = Location();

  List<double> _mapCenter = [-1.675, 29.229];
  double _mapZoom = 15.0;
  bool _isDefaultView = true;

  Timer? _debounce;
  List<ServiceLocation> _searchResults = [];
  final Set<ServiceType> _selectedServiceTypes = Set.from(ServiceType.values);
  bool _isSearchPanelVisible = false;

  late Future<List<ServiceLocation>> _serviceLocationsFuture;

  @override
  void initState() {
    super.initState();
    _loadServiceLocations();
    _initLocation();
  }

  void _loadServiceLocations() {
    final repository =
        Provider.of<PointDeVenteRepository>(context, listen: false);
    _serviceLocationsFuture = repository.getPoints();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await _location.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      final userLocation = [locationData.latitude!, locationData.longitude!];
      _mapController.move(userLocation, zoom: 15.0);
      if (mounted) {
        setState(() {
          _mapCenter = userLocation;
          _mapZoom = 15.0;
        });
      }
    }
  }

  void _recenterOnUser() async {
    final locationData = await _location.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      final userLocation = [locationData.latitude!, locationData.longitude!];
      _mapController.move(userLocation, zoom: 15.0);
      if (mounted) {
        setState(() {
          _isDefaultView = true;
          _mapCenter = userLocation;
          _mapZoom = 15.0;
        });
      }
    }
  }

  void _resetView(List<ServiceLocation> locations) {
    if (locations.isEmpty) return;

    final bounds = locations.fold<List<List<double>>>(
      [],
      (acc, loc) => acc..add(loc.coordinates),
    );

    _mapController.fitBounds(
      bounds,
      FitBoundsOptions(padding: const EdgeInsets.all(50.0)),
    );

    if (mounted) {
      setState(() {
        _isDefaultView = true;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query, List<ServiceLocation> allLocations) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          if (query.isEmpty) {
            _searchResults = [];
          } else {
            _searchResults = allLocations
                .where((service) =>
                    service.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
          }
        });
      }
    });
  }

  void _navigateToLocation(ServiceLocation location) {
    if (mounted) {
      setState(() {
        _isSearchPanelVisible = false;
        _searchResults = [];
        _isDefaultView = false;
        FocusScope.of(context).unfocus();
      });
    }
    _mapController.move(location.coordinates, zoom: 17.0);
  }

  void _toggleServiceType(ServiceType type) {
    if (mounted) {
      setState(() {
        _selectedServiceTypes.contains(type)
            ? _selectedServiceTypes.remove(type)
            : _selectedServiceTypes.add(type);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ProxiElec'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearchPanelVisible = !_isSearchPanelVisible;
                if (!_isSearchPanelVisible) {
                  _searchResults = [];
                }
              });
            },
            tooltip: 'Rechercher et Filtrer',
          ),
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Changer le thème',
          ),
        ],
      ),
      body: FutureBuilder<List<ServiceLocation>>(
        future: _serviceLocationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun point de service trouvé.'));
          }

          final allLocations = snapshot.data!;
          final filteredLocations = allLocations
              .where((service) => _selectedServiceTypes.contains(service.type))
              .toList();

          return Stack(
            children: [
              MapScreen(
                controller: _mapController,
                serviceLocations: filteredLocations,
                center: _mapCenter,
                zoom: _mapZoom,
                onChanged: (LatLng? center, double? zoom, double? rotation) {
                  if (mounted) {
                    setState(() {
                      _isDefaultView = false;
                      if (center != null) {
                        _mapCenter = [center.lat, center.lng];
                      }
                      if (zoom != null) {
                        _mapZoom = zoom;
                      }
                    });
                  }
                },
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  children: [
                    if (!_isDefaultView) ...[
                      FloatingActionButton(
                        mini: true,
                        onPressed: () => _resetView(filteredLocations),
                        tooltip: 'Vue d\'ensemble',
                        child: const Icon(Icons.aspect_ratio),
                      ),
                      const SizedBox(height: 10),
                    ],
                    FloatingActionButton(
                      onPressed: _recenterOnUser,
                      tooltip: 'Ma position',
                      child: const Icon(Icons.my_location),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: _isSearchPanelVisible ? 0 : -300,
                left: 0,
                right: 0,
                child: Material(
                  elevation: 4.0,
                  child: Container(
                    padding: const EdgeInsets.all(12.0)
                        .copyWith(top: MediaQuery.of(context).padding.top + 12),
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (query) =>
                              _onSearchChanged(query, allLocations),
                          decoration: InputDecoration(
                            hintText: 'Rechercher un nom de service...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor:
                                Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: ServiceType.values.map((type) {
                            final bool isSelected =
                                _selectedServiceTypes.contains(type);
                            return FilterChip(
                              avatar: Icon(
                                _getServiceTypeIcon(type),
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              label: Text(_getServiceTypeName(type)),
                              selected: isSelected,
                              onSelected: (selected) => _toggleServiceType(type),
                              selectedColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              showCheckmark: false,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_searchResults.isNotEmpty)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 150,
                  left: 12,
                  right: 12,
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 200,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final service = _searchResults[index];
                          return ListTile(
                            title: Text(service.name),
                            subtitle: Text(service.address),
                            onTap: () => _navigateToLocation(service),
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  IconData _getServiceTypeIcon(ServiceType type) {
    switch (type) {
      case ServiceType.agency:
        return Icons.corporate_fare;
      case ServiceType.chargingStation:
        return Icons.ev_station;
      case ServiceType.kiosk:
        return Icons.storefront;
    }
  }

  String _getServiceTypeName(ServiceType type) {
    switch (type) {
      case ServiceType.agency:
        return 'Agences';
      case ServiceType.chargingStation:
        return 'Bornes';
      case ServiceType.kiosk:
        return 'Kiosques';
    }
  }
}

class MapScreen extends StatelessWidget {
  final List<ServiceLocation> serviceLocations;
  final List<double> center;
  final double zoom;
  final MapController controller;
  final Function(LatLng?, double?, double)? onChanged;

  const MapScreen({
    super.key,
    required this.serviceLocations,
    required this.center,
    required this.zoom,
    required this.controller,
    required this.onChanged,
  });

  void _onMarkerTapped(BuildContext context, ServiceLocation service) {
    controller.move(service.coordinates, zoom: 17.0);
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.75,
          builder: (_, scrollController) => ServiceDetailsPanel(
            service: service,
            scrollController: scrollController,
          ),
        );
      },
    );
  }

  IconData _getMarkerIconData(ServiceType type) {
    switch (type) {
      case ServiceType.agency:
        return Icons.corporate_fare;
      case ServiceType.chargingStation:
        return Icons.ev_station;
      case ServiceType.kiosk:
        return Icons.storefront;
    }
  }

  Color _getMarkerColor(ServiceType type) {
    switch (type) {
      case ServiceType.agency:
        return Colors.blue.shade800;
      case ServiceType.chargingStation:
        return Colors.green.shade800;
      case ServiceType.kiosk:
        return Colors.orange.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return U.GoogleMap(
      center: center,
      zoom: zoom,
      controller: controller,
      onChanged: onChanged,
      base : U.TileLayer(
          'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
          subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
          attribution: 'Map Data &copy; Google',
      ),
      markers: U.MarkerLayer(
        serviceLocations.map((service) {
          return U.Marker(
            service.coordinates,
            widget: GestureDetector(
              onTap: () => _onMarkerTapped(context, service),
              child: Icon(
                _getMarkerIconData(service.type),                  color: _getMarkerColor(service.type),
                size: 40,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
