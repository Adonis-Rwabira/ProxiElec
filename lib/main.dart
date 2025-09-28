import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universe/universe.dart';

import 'service_details_panel.dart';
import 'service_location.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Colors.indigo;

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
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
        titleTextStyle: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primarySeedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
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
        titleTextStyle: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primarySeedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
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
          home: const HomeScreen(),
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
  Timer? _debounce;
  
  List<ServiceLocation> _searchResults = [];
  ServiceLocation? _selectedSearchResult;

  final Set<ServiceType> _selectedServiceTypes = Set.from(ServiceType.values);
  bool _isSearchPanelVisible = false;

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
  ];

  List<ServiceLocation> get _filteredData {
    if (_selectedSearchResult != null) {
      return [_selectedSearchResult!];
    }
    return _dummyData.where((service) {
      final bool matchesFilter = _selectedServiceTypes.contains(service.type);
      return matchesFilter;
    }).toList();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        if (query.isEmpty) {
          _searchResults = [];
        } else {
          _searchResults = _dummyData.where((service) {
            return service.name.toLowerCase().contains(query.toLowerCase());
          }).toList();
        }
      });
    });
  }

  void _navigateToLocation(ServiceLocation location) {
    setState(() {
      _selectedSearchResult = location;
      _isSearchPanelVisible = false;
      _searchResults = [];
      FocusScope.of(context).unfocus(); // Dismiss keyboard
    });
    _mapController.move(location.coordinates, zoom: 15.0);
  }

  void _toggleServiceType(ServiceType type) {
    setState(() {
      _selectedSearchResult = null;
      if (_selectedServiceTypes.contains(type)) {
        _selectedServiceTypes.remove(type);
      } else {
        _selectedServiceTypes.add(type);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
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
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Changer le thème',
          ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                _searchResults = [];
              });
            },
            child: MapScreen(
              mapController: _mapController,
              serviceLocations: _filteredData,
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
                padding: const EdgeInsets.all(12.0).copyWith(top: MediaQuery.of(context).padding.top + 12),
                color: Theme.of(context).appBarTheme.backgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un nom de service...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: ServiceType.values.map((type) {
                        final bool isSelected = _selectedServiceTypes.contains(type);
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
                          selectedColor: Theme.of(context).colorScheme.primary,
                          backgroundColor: Theme.of(context).colorScheme.surface,
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
                  constraints: BoxConstraints(
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
                        onTap: () {
                          _navigateToLocation(service);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
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
  final MapController mapController;

  const MapScreen({
    super.key, 
    required this.serviceLocations,
    required this.mapController,
  });

  void _onMarkerTapped(BuildContext context, ServiceLocation service) {
    FocusScope.of(context).unfocus();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.75,
          builder: (_, controller) => ServiceDetailsPanel(
            service: service, 
            scrollController: controller,
          ),
        ),
      ),
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
      center: "Goma",
      zoom: 12.0,
      controller: mapController,
      base: U.TileLayer(
        'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
        subdomains: ['mt0','mt1','mt2','mt3'],
        attribution: 'Map Data &copy; Google',
        updateInterval: 100,
        maxZoom: 20,
        minZoom: 0,
      ),
      markers: U.MarkerLayer(
        serviceLocations.map((service) {
          return U.Marker(
            service.coordinates,
            widget: GestureDetector(
              onTap: () => _onMarkerTapped(context, service),
              child: Icon(
                _getMarkerIconData(service.type),
                color: _getMarkerColor(service.type),
                size: 40,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
