import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transport_app/theme/app_theme.dart';

class DriverHomeScreen extends StatelessWidget {
  final String phone;
  final VoidCallback onViewTrips;

  const DriverHomeScreen({
    super.key,
    required this.phone,
    required this.onViewTrips,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'ESSELAM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Espace chauffeur',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.idCard,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Bienvenue chauffeur',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '+222 $phone',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.82),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Consultez vos trajets enregistrés et préparez votre départ.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.82),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const _DriverInfoCard(
                    icon: FontAwesomeIcons.route,
                    title: 'Vos trajets du jour',
                    description:
                        'Accédez rapidement aux trajets qui vous sont assignés.',
                  ),
                  const SizedBox(height: 16),
                  const _DriverInfoCard(
                    icon: FontAwesomeIcons.clock,
                    title: 'Heures de départ',
                    description:
                        'Vérifiez les horaires avant de commencer le voyage.',
                  ),
                  const SizedBox(height: 16),
                  const _DriverInfoCard(
                    icon: FontAwesomeIcons.chair,
                    title: 'Places disponibles',
                    description:
                        'Suivez les places restantes pour chaque trajet.',
                  ),
                  const SizedBox(height: 16),
                  const _DriverInfoCard(
                    icon: FontAwesomeIcons.shieldHalved,
                    title: 'Voyage sécurisé',
                    description:
                        'Gardez les informations du trajet claires et à jour.',
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton.icon(
                    onPressed: onViewTrips,
                    icon: const Icon(FontAwesomeIcons.route),
                    label: const Text('VOIR MES TRAJETS'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _DriverInfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
