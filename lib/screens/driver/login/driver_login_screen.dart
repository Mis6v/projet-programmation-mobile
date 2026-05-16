import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:transport_app/screens/driver/main/driver_main_screen.dart';
import 'package:transport_app/theme/app_theme.dart';
import 'package:transport_app/widgets/auth_form_card.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      Get.offAll(
        () => DriverMainScreen(phone: _phoneController.text),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion chauffeur'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/images/bus.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    AuthFormCard(
                      icon: FontAwesomeIcons.idCard,
                      title: 'Connexion chauffeur',
                      description:
                          'Entrez votre numero de telephone et votre PIN chauffeur pour acceder a votre espace.',
                      children: [
                        MauritaniaPhoneField(
                          controller: _phoneController,
                          labelText: 'Numero de telephone',
                        ),
                        const SizedBox(height: 18),
                        PinField(
                          controller: _pinController,
                          labelText: 'PIN chauffeur',
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _login,
                          child: const Text('ACCEDER A MON ESPACE'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(FontAwesomeIcons.arrowLeft),
                      label: const Text('RETOUR'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: const BorderSide(color: AppTheme.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
