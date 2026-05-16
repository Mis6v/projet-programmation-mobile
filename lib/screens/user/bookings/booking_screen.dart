import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:transport_app/models/trip.dart';
import 'package:transport_app/services/api_service.dart';
import 'package:transport_app/theme/app_theme.dart';

import 'confirmation_screen.dart';

class BookingScreen extends StatelessWidget {
  final Trip trip;
  final List<dynamic> seats;

  BookingScreen({
    super.key,
    required this.trip,
    required this.seats,
  });

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final RxBool _isLoading = false.obs;

  Future<void> _onConfirm() async {
    if (!_formKey.currentState!.validate()) return;

    _isLoading.value = true;

    final List<int> seatNumbers =
        seats.map((s) => int.parse(s.id.toString())).toList();

    final success = await ApiService.createBooking(
      trip.id,
      _nameController.text,
      _phoneController.text,
      seatNumbers,
    );

    _isLoading.value = false;

    if (success) {
      Get.to(() => ConfirmationScreen(trip: trip));
    } else {
      Get.snackbar('Erreur', 'Erreur lors de la réservation',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTripSummary(),
              const SizedBox(height: 32),
              const Text(
                'Informations du passager',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'Nom complet',
                hint: 'Entrez votre nom',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Téléphone',
                hint: 'Ex: +222 42 38 21 82',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre numéro';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'Choisir une place',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSelectedSeats(),
              const SizedBox(height: 40),
              _buildPaymentSummary(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(() => ElevatedButton(
                      onPressed: _isLoading.value ? null : _onConfirm,
                      child: _isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('CONFIRMER LA RÉSERVATION'),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(FontAwesomeIcons.bus, color: AppTheme.primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${trip.departureCity} → ${trip.destinationCity}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${trip.departureTime}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${trip.price} MRU',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSelectedSeats() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Siéges sélectionnés",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            seats.map((s) => s.id.toString()).join(', '),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    final total = (trip.price * seats.length) + 200;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Prix'),
            Text('${trip.price} MRU'),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Frais'),
            const Text('200 MRU'),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('TOTAL'),
            Text('$total MRU'),
          ],
        ),
      ],
    );
  }
}
