import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transport_app/theme/app_theme.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mes Billets'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: AppTheme.secondaryColor,
            tabs: [
              Tab(text: 'À venir'),
              Tab(text: 'Historique'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUpcomingList(),
            _buildHistoryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBookingItem(
          departure: 'Nouakchoot',
          destination: 'Boutilimit',
          date: '28 Mar 2026',
          time: '08:30',
          status: 'Confirmé',
          statusColor: Colors.green,
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBookingItem(
          departure: 'Aleg',
          destination: 'Nouakchoot',
          date: '15 Mar 2026',
          time: '14:00',
          status: 'Terminé',
          statusColor: Colors.grey,
        ),
        _buildBookingItem(
          departure: 'Nouakchoot',
          destination: 'Naima',
          date: '10 Mar 2026',
          time: '07:00',
          status: 'Terminé',
          statusColor: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildBookingItem({
    required String departure,
    required String destination,
    required String date,
    required String time,
    required String status,
    required Color statusColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textSecondaryColor),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(FontAwesomeIcons.bus, size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$departure → $destination',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Départ à $time',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondaryColor),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
