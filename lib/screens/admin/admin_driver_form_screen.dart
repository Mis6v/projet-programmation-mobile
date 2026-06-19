import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_app/models/driver.dart';
import 'package:transport_app/services/api_service.dart';

class AdminDriverFormScreen extends StatefulWidget {
  final Driver? driver;

  const AdminDriverFormScreen({super.key, this.driver});

  @override
  State<AdminDriverFormScreen> createState() => _AdminDriverFormScreenState();
}

class _AdminDriverFormScreenState extends State<AdminDriverFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _licenseController;
  late final TextEditingController _vehicleController;
  late final TextEditingController _plateController;
  bool _available = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final driver = widget.driver;
    _nameController = TextEditingController(text: driver?.fullName ?? '');
    _phoneController = TextEditingController(text: driver?.phone ?? '');
    _licenseController =
        TextEditingController(text: driver?.licenseNumber ?? '');
    _vehicleController = TextEditingController(text: driver?.vehicleName ?? '');
    _plateController = TextEditingController(text: driver?.vehiclePlate ?? '');
    _available = driver?.available ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _vehicleController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final request = DriverRequest(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      licenseNumber: _licenseController.text.trim(),
      vehicleName: _vehicleController.text.trim(),
      vehiclePlate: _plateController.text.trim(),
      available: _available,
    );

    try {
      if (widget.driver == null) {
        await ApiService.createAdminDriver(request);
      } else {
        await ApiService.updateAdminDriver(widget.driver!.id, request);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.driver == null ? 'Ajouter chauffeur' : 'Modifier chauffeur'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_nameController, 'Nom complet'),
            _field(_phoneController, 'Téléphone',
                keyboardType: TextInputType.phone),
            _field(_licenseController, 'Permis'),
            _field(_vehicleController, 'Véhicule'),
            _field(_plateController, 'Plaque'),
            SwitchListTile(
              value: _available,
              onChanged: (value) => setState(() => _available = value),
              title: const Text('Disponible'),
            ),
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
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Champ requis' : null,
      ),
    );
  }
}
