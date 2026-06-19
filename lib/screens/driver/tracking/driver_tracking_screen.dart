import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_app/models/trip.dart';
import 'package:transport_app/services/api_service.dart';
import 'package:transport_app/theme/app_theme.dart';

class DriverTrackingScreen extends StatefulWidget {
  final Trip trip;

  const DriverTrackingScreen({super.key, required this.trip});

  @override
  State<DriverTrackingScreen> createState() => _DriverTrackingScreenState();
}

class _DriverTrackingScreenState extends State<DriverTrackingScreen> {
  late bool _started;
  late String? _currentStatus;
  bool _starting = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.trip.status;
    _started = _currentStatus == 'IN_PROGRESS';
  }

  Future<void> _startTrip() async {
    if (DateTime.now().isBefore(widget.trip.departureTime)) {
      Get.snackbar(
        'Impossible',
        'Vous pouvez démarrer le trajet à partir de l’heure de départ.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _starting = true);
    try {
      final updatedTrip = await ApiService.startTrip(widget.trip);
      if (!mounted) return;
      setState(() {
        _currentStatus = updatedTrip.status ?? 'IN_PROGRESS';
        _started = _currentStatus == 'IN_PROGRESS';
      });
      Get.snackbar(
        'Trajet démarré',
        'Le statut du trajet est maintenant IN_PROGRESS.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (_) {
      Get.snackbar(
        'Erreur',
        'Impossible de démarrer le trajet dans le backend.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    final currentLatitude = trip.currentLatitude ?? trip.departureLatitude;
    final currentLongitude = trip.currentLongitude ?? trip.departureLongitude;

    return Scaffold(
      appBar: AppBar(title: const Text('Suivi chauffeur')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.route,
                        color: AppTheme.primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          trip.tripNumber ?? 'Trajet',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _StatusChip(
                        label: _statusLabel(_currentStatus),
                        active: _currentStatus == 'IN_PROGRESS',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${trip.departureCity} -> ${trip.destinationCity}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${formatter.format(trip.departureTime)} - ${formatter.format(trip.arrivalTime)}',
                    style: const TextStyle(color: AppTheme.textSecondaryColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _InfoTile(
            icon: FontAwesomeIcons.locationDot,
            label: 'Position actuelle',
            value: currentLatitude == null || currentLongitude == null
                ? 'Non disponible'
                : '${currentLatitude.toStringAsFixed(4)}, ${currentLongitude.toStringAsFixed(4)}',
          ),
          _InfoTile(
            icon: FontAwesomeIcons.percent,
            label: 'Progression',
            value: '${(trip.progressPercentage ?? 0).round()}%',
          ),
          _InfoTile(
            icon: FontAwesomeIcons.chair,
            label: 'Places disponibles',
            value: '${trip.availableSeats}',
          ),
          _InfoTile(
            icon: FontAwesomeIcons.bus,
            label: 'Véhicule',
            value: trip.driver == null
                ? '${trip.companyName} - ${trip.transportType}'
                : '${trip.driver!.vehicleName} - ${trip.driver!.vehiclePlate}',
          ),
          _InfoTile(
            icon: FontAwesomeIcons.signal,
            label: 'Statut backend',
            value: _statusLabel(_currentStatus),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _started || _starting ? null : _startTrip,
              icon: _starting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(FontAwesomeIcons.play),
              label: Text(
                _started
                    ? 'TRAJET DÉMARRÉ'
                    : _starting
                        ? 'DÉMARRAGE...'
                        : 'DÉMARRER LE TRAJET',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          child: Icon(icon, color: AppTheme.primaryColor, size: 16),
        ),
        title: Text(label),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool active;

  const _StatusChip({
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (active ? AppTheme.accentColor : AppTheme.secondaryColor)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? AppTheme.accentColor : AppTheme.secondaryColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

String _statusLabel(String? status) {
  switch (status) {
    case 'IN_PROGRESS':
      return 'En route';
    case 'ARRIVED':
      return 'Arrivé';
    case 'CANCELLED':
      return 'Annulé';
    default:
      return 'Programmé';
  }
}
