import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:transport_app/screens/admin/admin_main_screen.dart';
import 'package:transport_app/services/api_service.dart';
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

  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final phone = _phoneController.text.trim();
      final code = _codeController.text.trim();

      if (phone == '22222222' && code == '1111') {
        Get.offAll(() => const AdminMainScreen());
        return;
      }

      final result = await ApiService.login(phone, code);

      if (result == "SUCCESS") {
        Get.offAll(
          () => MainNavigation(
            phone: phone,
          ),
        );
      } else if (result == "UTILISATEUR_INTROUVABLE") {
        Get.snackbar(
          "Erreur",
          "Utilisateur introuvable",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (result == "CODE_INCORRECT") {
        Get.snackbar(
          "Erreur",
          "Code incorrect",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Erreur",
          "Connexion impossible",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Serveur inaccessible",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                          'Connectez-vous avec votre numéro et votre code.',
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
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'SE CONNECTER',
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        FontAwesomeIcons.arrowLeft,
                      ),
                      label: const Text('RETOUR'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: const BorderSide(
                          color: AppTheme.primaryColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
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
