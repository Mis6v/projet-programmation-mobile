import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_app/models/driver.dart';
import 'package:transport_app/models/trip.dart';
import 'package:transport_app/screens/admin/admin_driver_form_screen.dart';
import 'package:transport_app/services/api_service.dart';
import 'package:transport_app/theme/app_theme.dart';

class AdminDriversScreen extends StatefulWidget {
  const AdminDriversScreen({super.key});

  @override
  State<AdminDriversScreen> createState() => _AdminDriversScreenState();
}

class _AdminDriversScreenState extends State<AdminDriversScreen> {
  late Future<List<Driver>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = ApiService.getAdminDrivers();
  }

  Future<void> _openForm([Driver? driver]) async {
    final changed =
        await Get.to<bool>(() => AdminDriverFormScreen(driver: driver));
    if (changed == true && mounted) setState(_load);
  }

  Future<void> _deleteDriver(Driver driver) async {
    try {
      await ApiService.deleteAdminDriver(driver.id);
      if (mounted) setState(_load);
    } catch (_) {
      Get.snackbar('Erreur', 'Suppression impossible',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _showTrips(Driver driver) async {
    final trips = await ApiService.getAdminDriverTrips(driver.id);
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      builder: (_) => _DriverTripsSheet(driver: driver, trips: trips),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drivers'),
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
      body: FutureBuilder<List<Driver>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final drivers = snapshot.data ?? [];
          if (drivers.isEmpty) {
            return const Center(child: Text('Aucun chauffeur'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: drivers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final driver = drivers[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        AppTheme.primaryColor.withValues(alpha: 0.1),
                    child: const Icon(FontAwesomeIcons.userTie, size: 16),
                  ),
                  title: Text(driver.fullName),
                  subtitle: Text(
                    '${driver.phone}\n${driver.vehicleName} - ${driver.vehiclePlate}',
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') _openForm(driver);
                      if (value == 'trips') _showTrips(driver);
                      if (value == 'delete') _deleteDriver(driver);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Modifier')),
                      PopupMenuItem(
                          value: 'trips', child: Text('Voir trajets')),
                      PopupMenuItem(value: 'delete', child: Text('Supprimer')),
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

class _DriverTripsSheet extends StatelessWidget {
  final Driver driver;
  final List<Trip> trips;

  const _DriverTripsSheet({
    required this.driver,
    required this.trips,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM HH:mm');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trajets de ${driver.fullName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (trips.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('Aucun trajet assigné')),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    return ListTile(
                      title: Text(
                        '${trip.tripNumber ?? '-'}: ${trip.departureCity} -> ${trip.destinationCity}',
                      ),
                      subtitle: Text(formatter.format(trip.departureTime)),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
