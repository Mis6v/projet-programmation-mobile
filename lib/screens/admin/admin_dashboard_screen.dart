import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transport_app/models/driver.dart';
import 'package:transport_app/models/trip.dart';
import 'package:transport_app/services/api_service.dart';
import 'package:transport_app/theme/app_theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: FutureBuilder(
        future: Future.wait([
          ApiService.getAdminDrivers(),
          ApiService.getAdminTrips(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final drivers = snapshot.data?[0] as List<Driver>? ?? [];
          final trips = snapshot.data?[1] as List<Trip>? ?? [];
          final assignedTrips =
              trips.where((trip) => trip.driver != null).length;
          final availableDrivers =
              drivers.where((driver) => driver.available).length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatCard(
                icon: FontAwesomeIcons.idCard,
                title: 'Drivers',
                value: drivers.length.toString(),
                subtitle: '$availableDrivers disponibles',
              ),
              const SizedBox(height: 12),
              _StatCard(
                icon: FontAwesomeIcons.route,
                title: 'Trips',
                value: trips.length.toString(),
                subtitle: '$assignedTrips avec chauffeur',
              ),
              const SizedBox(height: 12),
              _StatCard(
                icon: FontAwesomeIcons.bus,
                title: 'Scheduled',
                value: trips
                    .where((trip) =>
                        trip.status == null || trip.status == 'SCHEDULED')
                    .length
                    .toString(),
                subtitle: 'Trajets programmés',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              child: Icon(icon, color: AppTheme.primaryColor, size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
