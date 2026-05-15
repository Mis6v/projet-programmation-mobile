import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transport_app/theme/app_theme.dart';

class AuthFormCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<Widget> children;

  const AuthFormCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 42,
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class MauritaniaPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const MauritaniaPhoneField({
    super.key,
    required this.controller,
    this.labelText = 'Numero',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: '22345678',
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '+222',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                width: 1,
                height: 24,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Entrez votre numero';
        }

        if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value)) {
          return 'Numero invalide (8 chiffres, commence par 2, 3 ou 4)';
        }

        return null;
      },
    );
  }
}

class PinField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const PinField({
    super.key,
    required this.controller,
    this.labelText = 'PIN',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: const Icon(FontAwesomeIcons.lock),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Entrez votre PIN';
        }

        if (!RegExp(r'^[0-9]{4}$').hasMatch(value)) {
          return 'PIN invalide (4 chiffres)';
        }

        return null;
      },
    );
  }
}
