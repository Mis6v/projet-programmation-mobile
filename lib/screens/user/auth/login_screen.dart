import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:transport_app/theme/app_theme.dart';
import 'package:transport_app/widgets/auth_form_card.dart';

import '../../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();

  final _codeController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      Get.offAll(
        () => MainNavigation(
          phone: _phoneController.text,
        ),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();

    _codeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
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
                    const SizedBox(height: 40),
                    AuthFormCard(
                      icon: FontAwesomeIcons.user,
                      title: 'Bienvenue',
                      description:
                          'Connectez-vous à l\'aide de votre numéro de téléphone et du code qui vous a été envoyé.',
                      children: [
                        MauritaniaPhoneField(
                          controller: _phoneController,
                          labelText: 'Numero',
                        ),
                        const SizedBox(height: 18),
                        PinField(
                          controller: _codeController,
                          labelText: 'Code',
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _login,
                          child: const Text(
                            'SE CONNECTER',
                          ),
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
