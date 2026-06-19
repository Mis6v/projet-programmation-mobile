import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_app/models/driver.dart';
import 'package:transport_app/models/trip.dart';
import 'package:transport_app/screens/admin/admin_trip_form_screen.dart';
import 'package:transport_app/services/api_service.dart';
import 'package:transport_app/theme/app_theme.dart';

class AdminTripsScreen extends StatefulWidget {
  const AdminTripsScreen({super.key});

  @override
  State<AdminTripsScreen> createState() => _AdminTripsScreenState();
}

class _AdminTripsScreenState extends State<AdminTripsScreen> {
  late Future<List<Trip>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = ApiService.getAdminTrips();
  }

  Future<void> _openForm([Trip? trip]) async {
    final changed = await Get.to<bool>(() => AdminTripFormScreen(trip: trip));
    if (changed == true && mounted) setState(_load);
  }

  Future<void> _deleteTrip(Trip trip) async {
    try {
      await ApiService.deleteAdminTrip(trip.id);
      if (mounted) setState(_load);
    } catch (_) {
      Get.snackbar(
          'Erreur', 'Suppression impossible: trajet avec réservations ?',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _assignDriver(Trip trip) async {
    final drivers = await ApiService.getAdminDrivers();
    if (!mounted) return;
    final selected = await showDialog<Driver>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Assigner chauffeur'),
        children: drivers
            .map(
              (driver) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, driver),
                child: Text('${driver.fullName} - ${driver.vehiclePlate}'),
              ),
            )
            .toList(),
      ),
    );
    if (selected == null) return;
    try {
      await ApiService.assignDriverToTrip(trip.id, selected.id);
      if (mounted) setState(_load);
    } catch (_) {
      Get.snackbar('Erreur', 'Assignation impossible',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _removeDriver(Trip trip) async {
    try {
      await ApiService.removeDriverFromTrip(trip.id);
      if (mounted) setState(_load);
    } catch (_) {
      Get.snackbar('Erreur', 'Retrait impossible',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
        actions: [
          IconButton(
            onPressed: () => setState(_load),
            icon: const Icon(FontAwesomeIcons.rotateRight, size: 18),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Trip>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final trips = snapshot.data ?? [];
          if (trips.isEmpty) {
            return const Center(child: Text('Aucun trajet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final trip = trips[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                AppTheme.primaryColor.withValues(alpha: 0.1),
                            child: const Icon(FontAwesomeIcons.route, size: 16),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${trip.tripNumber ?? '-'}: ${trip.departureCity} -> ${trip.destinationCity}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') _openForm(trip);
                              if (value == 'assign') _assignDriver(trip);
                              if (value == 'remove') _removeDriver(trip);
                              if (value == 'delete') _deleteTrip(trip);
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                  value: 'edit', child: Text('Modifier')),
                              PopupMenuItem(
                                  value: 'assign',
                                  child: Text('Assigner chauffeur')),
                              PopupMenuItem(
                                  value: 'remove',
                                  child: Text('Retirer chauffeur')),
                              PopupMenuItem(
                                  value: 'delete', child: Text('Supprimer')),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('Départ: ${formatter.format(trip.departureTime)}'),
                      Text('Arrivée: ${formatter.format(trip.arrivalTime)}'),
                      Text('Prix: ${trip.price.toStringAsFixed(0)} MRU'),
                      Text('Places: ${trip.availableSeats}'),
                      Text('Statut: ${trip.status ?? 'SCHEDULED'}'),
                      Text(
                        'Chauffeur: ${trip.driver?.fullName ?? 'Non assigné'}',
                        style:
                            const TextStyle(color: AppTheme.textSecondaryColor),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
