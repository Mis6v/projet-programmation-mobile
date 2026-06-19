import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_app/models/driver.dart';
import 'package:transport_app/models/trip.dart';
import 'package:transport_app/services/api_service.dart';

class AdminTripFormScreen extends StatefulWidget {
  final Trip? trip;

  const AdminTripFormScreen({super.key, this.trip});

  @override
  State<AdminTripFormScreen> createState() => _AdminTripFormScreenState();
}

class _AdminTripFormScreenState extends State<AdminTripFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tripNumberController;
  late final TextEditingController _departureController;
  late final TextEditingController _destinationController;
  late final TextEditingController _priceController;
  late final TextEditingController _transportController;
  late final TextEditingController _seatsController;
  late final TextEditingController _companyController;
  late final TextEditingController _progressController;
  late final TextEditingController _departureLatController;
  late final TextEditingController _departureLngController;
  late final TextEditingController _destinationLatController;
  late final TextEditingController _destinationLngController;
  late final TextEditingController _currentLatController;
  late final TextEditingController _currentLngController;

  DateTime _departureTime = DateTime.now().add(const Duration(days: 1));
  DateTime _arrivalTime = DateTime.now().add(const Duration(days: 1, hours: 3));
  String _status = 'SCHEDULED';
  String? _driverId;
  List<Driver> _drivers = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final trip = widget.trip;
    _tripNumberController = TextEditingController(text: trip?.tripNumber ?? '');
    _departureController =
        TextEditingController(text: trip?.departureCity ?? 'Nouakchott');
    _destinationController =
        TextEditingController(text: trip?.destinationCity ?? 'Rosso');
    _priceController =
        TextEditingController(text: (trip?.price ?? 3000).toStringAsFixed(0));
    _transportController =
        TextEditingController(text: trip?.transportType ?? 'Bus');
    _seatsController =
        TextEditingController(text: (trip?.availableSeats ?? 45).toString());
    _companyController =
        TextEditingController(text: trip?.companyName ?? 'Esselam');
    _progressController = TextEditingController(
        text: (trip?.progressPercentage ?? 0).toStringAsFixed(0));
    _departureLatController = TextEditingController(
        text: (trip?.departureLatitude ?? 18.0735).toString());
    _departureLngController = TextEditingController(
        text: (trip?.departureLongitude ?? -15.9582).toString());
    _destinationLatController = TextEditingController(
        text: (trip?.destinationLatitude ?? 16.5138).toString());
    _destinationLngController = TextEditingController(
        text: (trip?.destinationLongitude ?? -15.805).toString());
    _currentLatController = TextEditingController(
        text: (trip?.currentLatitude ?? 18.0735).toString());
    _currentLngController = TextEditingController(
        text: (trip?.currentLongitude ?? -15.9582).toString());
    _departureTime = trip?.departureTime ?? _departureTime;
    _arrivalTime = trip?.arrivalTime ?? _arrivalTime;
    _status = trip?.status ?? _status;
    _driverId = trip?.driver?.id;
    _loadDrivers();
  }

  Future<void> _loadDrivers() async {
    final drivers = await ApiService.getAdminDrivers();
    if (mounted) setState(() => _drivers = drivers);
  }

  @override
  void dispose() {
    _tripNumberController.dispose();
    _departureController.dispose();
    _destinationController.dispose();
    _priceController.dispose();
    _transportController.dispose();
    _seatsController.dispose();
    _companyController.dispose();
    _progressController.dispose();
    _departureLatController.dispose();
    _departureLngController.dispose();
    _destinationLatController.dispose();
    _destinationLngController.dispose();
    _currentLatController.dispose();
    _currentLngController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(bool departure) async {
    final initial = departure ? _departureTime : _arrivalTime;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;
    final value =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      if (departure) {
        _departureTime = value;
      } else {
        _arrivalTime = value;
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_arrivalTime.isAfter(_departureTime)) {
      Get.snackbar('Erreur', 'L’arrivée doit être après le départ',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _saving = true);
    final request = TripRequest(
      tripNumber: _tripNumberController.text.trim(),
      driverId: _driverId,
      departureCity: _departureController.text.trim(),
      destinationCity: _destinationController.text.trim(),
      departureTime: _departureTime,
      arrivalTime: _arrivalTime,
      price: double.parse(_priceController.text.trim()),
      transportType: _transportController.text.trim(),
      availableSeats: int.parse(_seatsController.text.trim()),
      companyName: _companyController.text.trim(),
      status: _status,
      progressPercentage: double.parse(_progressController.text.trim()),
      departureLatitude: double.parse(_departureLatController.text.trim()),
      departureLongitude: double.parse(_departureLngController.text.trim()),
      destinationLatitude: double.parse(_destinationLatController.text.trim()),
      destinationLongitude: double.parse(_destinationLngController.text.trim()),
      currentLatitude: double.parse(_currentLatController.text.trim()),
      currentLongitude: double.parse(_currentLngController.text.trim()),
    );

    try {
      if (widget.trip == null) {
        await ApiService.createAdminTrip(request);
      } else {
        await ApiService.updateAdminTrip(widget.trip!.id, request);
      }
      Get.back(result: true);
    } catch (_) {
      Get.snackbar('Erreur', 'Enregistrement impossible',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip == null ? 'Ajouter trajet' : 'Modifier trajet'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_tripNumberController, 'Numéro trajet'),
            DropdownButtonFormField<String?>(
              initialValue: _driverId,
              decoration: const InputDecoration(
                labelText: 'Chauffeur',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Sans chauffeur'),
                ),
                ..._drivers.map(
                  (driver) => DropdownMenuItem<String?>(
                    value: driver.id,
                    child: Text('${driver.fullName} - ${driver.vehiclePlate}'),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _driverId = value),
            ),
            const SizedBox(height: 14),
            _field(_departureController, 'Ville départ'),
            _field(_destinationController, 'Destination'),
            _dateTile('Départ', formatter.format(_departureTime),
                () => _pickDateTime(true)),
            _dateTile('Arrivée', formatter.format(_arrivalTime),
                () => _pickDateTime(false)),
            _field(_priceController, 'Prix',
                keyboardType: TextInputType.number),
            _field(_transportController, 'Type transport'),
            _field(_seatsController, 'Places',
                keyboardType: TextInputType.number),
            _field(_companyController, 'Compagnie'),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Statut',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'SCHEDULED', child: Text('SCHEDULED')),
                DropdownMenuItem(
                    value: 'IN_PROGRESS', child: Text('IN_PROGRESS')),
                DropdownMenuItem(value: 'ARRIVED', child: Text('ARRIVED')),
                DropdownMenuItem(value: 'CANCELLED', child: Text('CANCELLED')),
              ],
              onChanged: (value) =>
                  setState(() => _status = value ?? 'SCHEDULED'),
            ),
            const SizedBox(height: 14),
            _field(_progressController, 'Progression %',
                keyboardType: TextInputType.number),
            _field(_departureLatController, 'Départ latitude',
                keyboardType: TextInputType.number),
            _field(_departureLngController, 'Départ longitude',
                keyboardType: TextInputType.number),
            _field(_destinationLatController, 'Destination latitude',
                keyboardType: TextInputType.number),
            _field(_destinationLngController, 'Destination longitude',
                keyboardType: TextInputType.number),
            _field(_currentLatController, 'Actuelle latitude',
                keyboardType: TextInputType.number),
            _field(_currentLngController, 'Actuelle longitude',
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('ENREGISTRER'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateTile(String label, String value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        title: Text(label),
        subtitle: Text(value),
        trailing: const Icon(Icons.calendar_month),
        onTap: onTap,
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Champ requis';
          if (keyboardType == TextInputType.number &&
              double.tryParse(value.trim()) == null) {
            return 'Nombre invalide';
          }
          return null;
        },
      ),
    );
  }
}
