import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transport_app/theme/app_theme.dart';
import 'package:transport_app/widgets/trip_card.dart';
import 'package:transport_app/models/trip.dart';
import 'package:transport_app/utils/mock_data.dart';
import 'package:transport_app/screens/booking_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final popularTrips = MockData.getPopularTrips();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Esselam Transport ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.primaryColor, Color(0xFF3F51B5)],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(FontAwesomeIcons.bus, size: 60, color: Colors.white),
                      const SizedBox(height: 10),
                      Text(
                        'Voyagez en toute sérénité',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Où voulez-vous aller ?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildQuickSearch(context),
                  const SizedBox(height: 24),
                  const Text(
                    'Destinations Populaires',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return TripCard(
                  trip: popularTrips[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(trip: popularTrips[index]),
                      ),
                    );
                  },
                );
              },
              childCount: popularTrips.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSearch(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLocationField(FontAwesomeIcons.locationDot, 'Ville de départ', 'Ex: Laiyoun'),
          const Divider(height: 30),
          _buildLocationField(FontAwesomeIcons.locationArrow, 'Destination', 'Ex:Kiffa'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Action de recherche
              },
              child: const Text('RECHERCHER'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField(IconData icon, String label, String hint) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondaryColor)),
              Text(hint, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
