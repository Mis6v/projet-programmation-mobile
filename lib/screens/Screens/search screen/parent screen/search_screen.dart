import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:transport_app/controllers/search_controller.dart';
import 'package:transport_app/screens/service/SeatSelectionScreen.dart';
import 'package:transport_app/theme/app_theme.dart';

import '../trips_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final SearchTripController controller =
  Get.put(SearchTripController());

  Future<String?> _selectCity(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Choisir une ville'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'Nouakchott'),
              child: const Text('Nouakchott'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'Aleg'),
              child: const Text('Aleg'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'Rosso'),
              child: const Text('Rosso'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'Nouadhibou'),
              child: const Text('Nouadhibou'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 30),
      ),
    );

    if (picked != null) {
      controller.setDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Rechercher un Voyage'),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20.0),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              'Préparez votre prochain trajet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Remplissez les informations ci-dessous pour trouver les meilleurs horaires.',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),

            const SizedBox(height: 32),

            _buildSearchCard(context),

            const SizedBox(height: 32),

            const Text(
              'Conseils de voyage',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _buildTipCard(
              FontAwesomeIcons.clock,
              'Arrivez en avance',
              'Nous vous recommandons d\'arriver au moins 30 minutes avant le départ.',
            ),

            const SizedBox(height: 12),

            _buildTipCard(
              FontAwesomeIcons.idCard,
              'Pièce d\'identité',
              'N\'oubliez pas votre pièce d\'identité originale pour l\'embarquement.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {

    return Card(

      child: Padding(

        padding: const EdgeInsets.all(20.0),

        child: Column(

          children: [

            /// DEPART
            Obx(() => _buildSelectionRow(

              icon: FontAwesomeIcons.locationDot,

              label: 'Ville de départ',

              value: controller.departureCity.value,

              onTap: () async {

                final city = await _selectCity(context);

                if (city != null) {
                  controller.setDeparture(city);
                }
              },
            )),

            const Divider(height: 32),

            /// DESTINATION
            Obx(() => _buildSelectionRow(

              icon: FontAwesomeIcons.locationArrow,

              label: 'Destination',

              value: controller.destinationCity.value,

              onTap: () async {

                final city = await _selectCity(context);

                if (city != null) {
                  controller.setDestination(city);
                }
              },
            )),

            const Divider(height: 32),

            Row(

              children: [

                /// DATE
                Expanded(

                  child: Obx(() => _buildSelectionRow(

                    icon: FontAwesomeIcons.calendarDay,

                    label: 'Date',

                    value: DateFormat('dd MMM yyyy').format(
                      controller.selectedDate.value,
                    ),

                    onTap: () => _selectDate(context),
                  )),
                ),

                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),

                /// PASSAGERS
                Expanded(

                  child: Obx(() => _buildSelectionRow(

                    icon: FontAwesomeIcons.users,

                    label: 'Passagers',

                    value:
                    '${controller.passengerCount.value} '
                        'Personne${controller.passengerCount.value > 1 ? 's' : ''}',

                    onTap: () async {

                      final result = await Get.to(
                            () => SeatSelectionScreen(),
                      );

                      if (result != null) {

                        controller.setSeats(result);
                      }
                    },
                  )),
                ),
              ],
            ),

            const SizedBox(height: 32),

            SizedBox(

              width: double.infinity,
              height: 50,

              child: ElevatedButton(

                onPressed: () {

                  print(
                    'Departure: ${controller.departureCity.value}',
                  );

                  print(
                    'Destination: ${controller.destinationCity.value}',
                  );

                  print(
                    'Date: ${controller.selectedDate.value}',
                  );

                  print(
                    'Passengers: ${controller.passengerCount.value}',
                  );

                  Get.to(

                        () => TripsScreen(

                      departure:
                      controller.departureCity.value,

                      destination:
                      controller.destinationCity.value,

                      seats:
                      controller.selectedSeats,
                    ),
                  );
                },

                child: const Text(
                  'TROUVER UN VOYAGE',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionRow({

    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,

  }) {

    return InkWell(

      onTap: onTap,

      child: Row(

        children: [

          Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),

          const SizedBox(width: 16),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  label,

                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),

                Text(

                  value,

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(
      IconData icon,
      String title,
      String description,
      ) {

    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: Colors.grey[200]!,
        ),
      ),

      child: Row(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: AppTheme.secondaryColor,
            size: 20,
          ),

          const SizedBox(width: 16),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(

                  description,

                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
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
