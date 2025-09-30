import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'domain/service_location.dart';

class ServiceDetailsPanel extends StatelessWidget {
  final ServiceLocation service;
  final ScrollController scrollController;

  const ServiceDetailsPanel({
    super.key,
    required this.service,
    required this.scrollController,
  });

  Future<void> _launchMapsUrl(double lat, double lon) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            color: const Color.fromRGBO(0, 0, 0, 0.2),
          ),
        ],
      ),
      child: ListView(
        controller: scrollController,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Text(
            service.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.location_on_outlined,
            text: service.address,
          ),
          const SizedBox(height: 8),
          const _InfoRow(
            icon: Icons.schedule_outlined,
            text: 'Horaires non disponibles', // Donnée factice
          ),
           const SizedBox(height: 8),
          const _InfoRow(
            icon: Icons.apps_outlined,
            text: 'Paiement, Conseil', // Donnée factice
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.directions),
            label: const Text('ITINÉRAIRE'),
            // Correction majeure : Utilisation de la liste [lat, lon]
            onPressed: () => _launchMapsUrl(service.coordinates[0], service.coordinates[1]),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}
