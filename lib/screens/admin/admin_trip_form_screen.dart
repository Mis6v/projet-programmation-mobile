import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_app/models/driver.dart';
import 'package:transport_app/models/trip.dart';
import 'package:transport_app/services/api_service.dart';
import 'package:transport_app/utils/city_data.dart';

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
  late final TextEditingController _progressController;
  late final TextEditingController _departureLatController;
  late final TextEditingController _departureLngController;
  late final TextEditingController _destinationLatController;
  late final TextEditingController _destinationLngController;
  late final TextEditingController _currentLatController;
  late final TextEditingController _currentLngController;

  DateTime _departureTime = DateTime.now().add(const Duration(days: 1));
  DateTime _arrivalTime = DateTime.now().add(const Duration(days: 1, hours: 3));
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
    _driverId = trip?.driver?.id;
    _syncCityCoordinates();
    if (trip == null) {
      _syncEstimatedArrival();
    }
    _loadDrivers();
  }

  Future<void> _loadDrivers() async {
    final drivers = await ApiService.getAdminDrivers();
    if (mounted) setState(() => _drivers = drivers);
  }

  DateTime _tomorrow() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1);
  }

  DateTime _maxDepartureDate() {
    return _tomorrow().add(const Duration(days: 14));
  }

  bool _isAllowedDepartureDate(DateTime value) {
    final tomorrow = _tomorrow();
    final maxDate = _maxDepartureDate();
    final dateOnly = DateTime(value.year, value.month, value.day);
    return !dateOnly.isBefore(tomorrow) && !dateOnly.isAfter(maxDate);
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  void _syncCityCoordinates() {
    if (_departureController.text.toLowerCase() ==
        _destinationController.text.toLowerCase()) {
      final replacement = availableCities.firstWhere(
        (city) =>
            city.name.toLowerCase() != _departureController.text.toLowerCase(),
      );
      _destinationController.text = replacement.name;
    }

    final departure = cityByName(_departureController.text);
    final destination = cityByName(_destinationController.text);
    _departureLatController.text = departure.latitude.toString();
    _departureLngController.text = departure.longitude.toString();
    _destinationLatController.text = destination.latitude.toString();
    _destinationLngController.text = destination.longitude.toString();
    _currentLatController.text = departure.latitude.toString();
    _currentLngController.text = departure.longitude.toString();
  }

  void _syncEstimatedArrival() {
    final duration = _estimatedDuration(
      _departureController.text,
      _destinationController.text,
    );
    _arrivalTime = _departureTime.add(duration);
  }

  Duration _estimatedDuration(String departure, String destination) {
    final from = departure.toLowerCase();
    final to = destination.toLowerCase();
    final pair = {from, to};

    if (pair.contains('nouakchott') && pair.contains('rosso')) {
      return const Duration(hours: 3);
    }
    if (pair.contains('nouakchott') && pair.contains('aleg')) {
      return const Duration(hours: 4);
    }
    if (pair.contains('nouakchott') && pair.contains('nouadhibou')) {
      return const Duration(hours: 6);
    }
    if (pair.contains('rosso') && pair.contains('aleg')) {
      return const Duration(hours: 5);
    }
    if (pair.contains('rosso') && pair.contains('nouadhibou')) {
      return const Duration(hours: 8);
    }
    if (pair.contains('aleg') && pair.contains('nouadhibou')) {
      return const Duration(hours: 9);
    }

    return const Duration(hours: 3);
  }

  Future<String?> _validateSelectedDriver() async {
    if (_driverId == null || _driverId!.isEmpty) return null;

    final driverTrips = await ApiService.getAdminDriverTrips(_driverId!);
    final otherTrips =
        driverTrips.where((trip) => trip.id != widget.trip?.id).toList();

    final sameDayTrip = otherTrips
        .where((trip) => _isSameDay(trip.departureTime, _departureTime))
        .firstOrNull;
    if (sameDayTrip != null) {
      return 'Ce chauffeur a déjà un trajet enregistré le même jour.';
    }

    final previousTrips = otherTrips
        .where((trip) => trip.departureTime.isBefore(_departureTime))
        .toList()
      ..sort((a, b) => b.departureTime.compareTo(a.departureTime));

    if (previousTrips.isEmpty) return null;

    final lastTrip = previousTrips.first;
    if (lastTrip.destinationCity.toLowerCase() !=
        _departureController.text.trim().toLowerCase()) {
      return 'Ce chauffeur devrait être à ${lastTrip.destinationCity}. Le départ doit commencer depuis cette ville.';
    }

    return null;
  }

  Future<void> _selectDriver(String? driverId) async {
    final previousDriverId = _driverId;
    setState(() => _driverId = driverId);

    final error = await _validateSelectedDriver();
    if (error == null) return;

    if (!mounted) return;
    setState(() => _driverId = previousDriverId);
    Get.snackbar('Erreur', error, snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void dispose() {
    _tripNumberController.dispose();
    _departureController.dispose();
    _destinationController.dispose();
    _priceController.dispose();
    _transportController.dispose();
    _seatsController.dispose();
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
    final tomorrow = _tomorrow();
    final date = await showDatePicker(
      context: context,
      initialDate: departure ? tomorrow : initial,
      firstDate: departure ? tomorrow : DateTime.now(),
      lastDate: departure
          ? _maxDepartureDate()
          : DateTime.now().add(const Duration(days: 365)),
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
        _syncEstimatedArrival();
      } else {
        _arrivalTime = value;
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isAllowedDepartureDate(_departureTime)) {
      Get.snackbar(
          'Erreur', 'Le départ doit être entre demain et les 14 jours suivants',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (!_arrivalTime.isAfter(_departureTime)) {
      Get.snackbar('Erreur', 'L’arrivée doit être après le départ',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final driverError = await _validateSelectedDriver();
    if (driverError != null) {
      Get.snackbar('Erreur', driverError, snackPosition: SnackPosition.BOTTOM);
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
      companyName: 'Esselam',
      status: 'SCHEDULED',
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
              key: ValueKey(_driverId),
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
              onChanged: _selectDriver,
            ),
            const SizedBox(height: 14),
            _cityDropdown(
              label: 'Ville départ',
              value: _departureController.text,
              excludedCity: _destinationController.text,
              onChanged: (city) {
                if (city == null) return;
                setState(() {
                  _departureController.text = city;
                  _syncCityCoordinates();
                  _syncEstimatedArrival();
                });
              },
            ),
            const SizedBox(height: 14),
            _cityDropdown(
              label: 'Destination',
              value: _destinationController.text,
              excludedCity: _departureController.text,
              onChanged: (city) {
                if (city == null) return;
                setState(() {
                  _destinationController.text = city;
                  _syncCityCoordinates();
                  _syncEstimatedArrival();
                });
              },
            ),
            const SizedBox(height: 14),
            _dateTile('Départ', formatter.format(_departureTime),
                () => _pickDateTime(true)),
            _dateTile('Arrivée estimée', formatter.format(_arrivalTime), null),
            _field(_priceController, 'Prix',
                keyboardType: TextInputType.number),
            _field(_transportController, 'Type transport'),
            _field(_seatsController, 'Places',
                keyboardType: TextInputType.number),
            _field(_progressController, 'Progression %',
                keyboardType: TextInputType.number, readOnly: true),
            _field(_departureLatController, 'Départ latitude',
                keyboardType: TextInputType.number, readOnly: true),
            _field(_departureLngController, 'Départ longitude',
                keyboardType: TextInputType.number, readOnly: true),
            _field(_destinationLatController, 'Destination latitude',
                keyboardType: TextInputType.number, readOnly: true),
            _field(_destinationLngController, 'Destination longitude',
                keyboardType: TextInputType.number, readOnly: true),
            _field(_currentLatController, 'Actuelle latitude',
                keyboardType: TextInputType.number, readOnly: true),
            _field(_currentLngController, 'Actuelle longitude',
                keyboardType: TextInputType.number, readOnly: true),
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

  Widget _dateTile(String label, String value, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        title: Text(label),
        subtitle: Text(value),
        trailing: Icon(
          onTap == null ? Icons.lock_clock : Icons.calendar_month,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _cityDropdown({
    required String label,
    required String value,
    required String excludedCity,
    required ValueChanged<String?> onChanged,
  }) {
    final cityItems = availableCities
        .where(
          (city) => city.name.toLowerCase() != excludedCity.toLowerCase(),
        )
        .toList();
    final selectedValue = cityItems.any((city) => city.name == value)
        ? value
        : cityItems.first.name;

    return DropdownButtonFormField<String>(
      key: ValueKey('$label-$selectedValue-$excludedCity'),
      initialValue: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: cityItems
          .map(
            (city) => DropdownMenuItem(
              value: city.name,
              child: Text(city.name),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Champ requis';
        if (label == 'Destination' &&
            value.toLowerCase() == _departureController.text.toLowerCase()) {
          return 'Choisissez une ville différente';
        }
        if (label == 'Ville départ' &&
            value.toLowerCase() == _destinationController.text.toLowerCase()) {
          return 'Choisissez une ville différente';
        }
        return null;
      },
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
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
