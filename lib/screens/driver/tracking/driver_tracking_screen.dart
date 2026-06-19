import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_app/models/trip.dart';
import 'package:transport_app/services/api_service.dart';

class DriverTrackingScreen extends StatefulWidget {
  final Trip trip;

  const DriverTrackingScreen({super.key, required this.trip});

  @override
  State<DriverTrackingScreen> createState() => _DriverTrackingScreenState();
}

class _DriverTrackingScreenState extends State<DriverTrackingScreen> {
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _progressController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _latitudeController = TextEditingController(
      text: (widget.trip.currentLatitude ??
              widget.trip.departureLatitude ??
              18.0735)
          .toString(),
    );
    _longitudeController = TextEditingController(
      text: (widget.trip.currentLongitude ??
              widget.trip.departureLongitude ??
              -15.9582)
          .toString(),
    );
    _progressController = TextEditingController(
      text: (widget.trip.progressPercentage ?? 0).toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _updateLocation() async {
    final tripNumber = widget.trip.tripNumber;
    if (tripNumber == null || tripNumber.isEmpty) {
      Get.snackbar('Erreur', 'Numéro de trajet manquant',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _saving = true);
    final result = await ApiService.updateTripLocation(
      tripNumber: tripNumber,
      latitude: double.parse(_latitudeController.text.trim()),
      longitude: double.parse(_longitudeController.text.trim()),
      progressPercentage: double.tryParse(_progressController.text.trim()),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    Get.snackbar(
      result == null ? 'Erreur' : 'Succès',
      result == null ? 'Mise à jour impossible' : 'Position mise à jour',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tracking chauffeur')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.trip.tripNumber ?? 'Trajet',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
              '${widget.trip.departureCity} -> ${widget.trip.destinationCity}'),
          const SizedBox(height: 20),
          _field(_latitudeController, 'Latitude'),
          _field(_longitudeController, 'Longitude'),
          _field(_progressController, 'Progression %'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _saving ? null : _updateLocation,
            child: _saving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('ENVOYER POSITION'),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
