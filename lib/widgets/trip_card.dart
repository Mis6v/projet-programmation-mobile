import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:transport_app/models/trip.dart';
import 'package:transport_app/theme/app_theme.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;

  const TripCard({
    super.key,
    required this.trip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trip.companyName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Text(
                    '${trip.price.toStringAsFixed(0)} MRU',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        timeFormat.format(trip.departureTime),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(trip.departureCity, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(child: Divider(indent: 10, endIndent: 10)),
                            Icon(
                              trip.transportType == 'Bus' 
                                  ? FontAwesomeIcons.bus 
                                  : FontAwesomeIcons.train,
                              size: 16,
                              color: AppTheme.textSecondaryColor,
                            ),
                            const Expanded(child: Divider(indent: 10, endIndent: 10)),
                          ],
                        ),
                        Text(
                          trip.duration,
                          style: const TextStyle(fontSize: 10, color: AppTheme.textSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        timeFormat.format(trip.arrivalTime),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(trip.destinationCity, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event_seat, size: 14, color: AppTheme.textSecondaryColor),
                      const SizedBox(width: 4),
                      Text(
                        '${trip.availableSeats} places libres',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondaryColor),
                      ),
                    ],
                  ),
                  const Text(
                    'Réserver >',
                    style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.bold, 
                      color: AppTheme.primaryColor
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
