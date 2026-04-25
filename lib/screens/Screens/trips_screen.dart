import 'package:flutter/material.dart';
import '../booking_screen.dart';
import '../models/trip.dart';
import 'package:intl/intl.dart';

import '../service/SeatSelectionScreen.dart';


class TripsScreen extends StatelessWidget {
  final String departure;
  final String destination;
  final List<dynamic> seats;

  const TripsScreen({
    super.key,
    required this.departure,
    required this.destination,
    required this.seats,
  });

  @override
  Widget build(BuildContext context) {
    final trips = [
      Trip(
        id: '1',
        departureCity: 'Nouakchott',
        destinationCity: 'Aleg',
        departureTime: DateTime.now(),
        arrivalTime: DateTime.now().add(const Duration(hours: 3)),
        price: 5000,
        transportType: 'Bus',
        availableSeats: 3,
        companyName: 'Esselam',
      ),
      Trip(
        id: '2',
        departureCity: 'Nouakchott',
        destinationCity: 'Rosso',
        departureTime: DateTime.now().add(const Duration(days: 1)),
        arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
        price: 6000,
        transportType: 'Bus',
        availableSeats: 5,
        companyName: 'Esselam',
      ),
    ];

    final filteredTrips = trips.where((trip) {
      return trip.departureCity.toLowerCase() == departure.toLowerCase() &&
          trip.destinationCity.toLowerCase() == destination.toLowerCase() &&
          trip.availableSeats >= seats.length;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: filteredTrips.isEmpty
          ? const Center(child: Text('Aucun voyage trouvé'))
          : ListView.builder(
        itemCount: filteredTrips.length,
        itemBuilder: (context, index) {
          final trip = filteredTrips[index];

          final departureFormatted =
          DateFormat('dd/MM/yyyy HH:mm').format(trip.departureTime);

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text('${trip.departureCity} → ${trip.destinationCity}'),
              subtitle: Text('Départ: $departureFormatted'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${trip.availableSeats} places'),
                  Text('${trip.price} MRU'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingScreen(trip: trip,
                        seats:  List<dynamic>.from(seats),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}