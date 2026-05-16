import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:transport_app/models/trip.dart';
import 'package:transport_app/services/api_service.dart';
import 'package:transport_app/theme/app_theme.dart';

class MyRecordedTripsScreen extends StatelessWidget {
  final String phone;

  const MyRecordedTripsScreen({
    super.key,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes trajets'),
      ),
      body: FutureBuilder<List<Trip>>(
        future: ApiService.getDriverTripsByPhone(phone),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Impossible de charger vos trajets'),
            );
          }

          final trips = snapshot.data ?? [];

          if (trips.isEmpty) {
            return const Center(
              child: Text('Aucun trajet enregistré pour ce chauffeur'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final trip = trips[index];

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color:
                                AppTheme.primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.route,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${trip.departureCity} -> ${trip.destinationCity}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                        ),
                        if (trip.tripNumber != null)
                          Text(
                            trip.tripNumber!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryColor,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _TripDetail(
                      icon: FontAwesomeIcons.clock,
                      text: 'Depart : ${formatter.format(trip.departureTime)}',
                    ),
                    const SizedBox(height: 8),
                    _TripDetail(
                      icon: FontAwesomeIcons.bus,
                      text: '${trip.companyName} - ${trip.transportType}',
                    ),
                    const SizedBox(height: 8),
                    _TripDetail(
                      icon: FontAwesomeIcons.chair,
                      text: '${trip.availableSeats} places disponibles',
                    ),
                    if (trip.status != null) ...[
                      const SizedBox(height: 8),
                      _TripDetail(
                        icon: FontAwesomeIcons.signal,
                        text: 'Statut : ${trip.status}',
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _TripDetail extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TripDetail({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.textSecondaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppTheme.textSecondaryColor),
          ),
        ),
      ],
    );
  }
}
