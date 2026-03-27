import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transport_app/theme/app_theme.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(
              FontAwesomeIcons.circleCheck,
              color: Colors.white,
              size: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              'Réservation Confirmée !',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Votre billet est prêt.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    _buildTicketHeader(),
                    const Divider(height: 40, thickness: 1, color: Colors.grey),
                    _buildTicketDetails(),
                    const Spacer(),
                    _buildQRCode(),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('RETOUR À L\'ACCUEIL'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DÉPART', style: TextStyle(fontSize: 12, color: AppTheme.textSecondaryColor)),
            Text('ABIDJAN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Gare de Treichville', style: TextStyle(fontSize: 10, color: AppTheme.textSecondaryColor)),
          ],
        ),
        Icon(FontAwesomeIcons.arrowRight, color: AppTheme.secondaryColor, size: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('ARRIVÉE', style: TextStyle(fontSize: 12, color: AppTheme.textSecondaryColor)),
            Text('BOUAKÉ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Gare Centrale', style: TextStyle(fontSize: 10, color: AppTheme.textSecondaryColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildTicketDetails() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DetailItem(label: 'DATE', value: '28 MAR 2026'),
            _DetailItem(label: 'HEURE', value: '08:30'),
            _DetailItem(label: 'PLACE', value: '12A'),
          ],
        ),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DetailItem(label: 'PASSAGER', value: 'Jean Kouassi'),
            _DetailItem(label: 'COMPAGNIE', value: 'UTB Express'),
          ],
        ),
      ],
    );
  }

  Widget _buildQRCode() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            FontAwesomeIcons.qrcode,
            size: 120,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Présentez ce code à l\'embarquement',
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondaryColor),
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondaryColor)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
