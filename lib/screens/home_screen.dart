import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transport_app/screens/search_screen.dart';
import 'package:transport_app/theme/app_theme.dart';
import 'package:transport_app/widgets/trip_card.dart';

import 'package:transport_app/utils/mock_data.dart';
import 'package:transport_app/screens/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transport_app/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // ✅ Background (image bus légère)
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/images/bus.png', // 👉 ajoute une image bus ici
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ✅ Contenu
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 20),

                  // 🔵 Titre
                  const Text(
                    "ESSELAM",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Transport fiable et sécurisé",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ✅ Carte 1
                  _buildCard(
                    icon: FontAwesomeIcons.bus,
                    title: "Voyagez facilement",
                    description:
                    "Réservez vos billets de transport en quelques clics sans vous déplacer.",
                  ),

                  const SizedBox(height: 20),

                  // ✅ Carte 2
                  _buildCard(
                    icon: FontAwesomeIcons.clock,
                    title: "Gain de temps",
                    description:
                    "Consultez les horaires et choisissez le voyage qui vous convient.",
                  ),

                  const SizedBox(height: 20),

                  // ✅ Carte 3
                  _buildCard(
                    icon: FontAwesomeIcons.shieldHalved,
                    title: "Sécurité",
                    description:
                    "Voyagez avec des compagnies fiables comme Esselam.",
                  ),

                  const SizedBox(height: 20),

                  // ✅ Carte 4
                  _buildCard(
                    icon: FontAwesomeIcons.mobileScreen,
                    title: "Simple à utiliser",
                    description:
                    "Une application claire et facile pour tous les utilisateurs.",
                  ),

                  const SizedBox(height: 40),

                  // ✅ Bouton commencer
    SizedBox(
    width: double.infinity,
    child: ElevatedButton(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => const SearchScreen(),
    ),
    );
    },
    child: const Text("COMMENCER"),
    ),
    ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Widget carte info
  Widget _buildCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 28),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
