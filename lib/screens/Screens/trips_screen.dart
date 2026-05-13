import 'package:flutter/material.dart';
import '../booking_screen.dart';
import '../models/trip.dart';
import 'package:intl/intl.dart';
import '../service/api_service.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: FutureBuilder<List<Trip>>(
        future: ApiService.getAllTrips(),
        builder: (context, snapshot) {


          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }


          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun voyage disponible'));
          }

          final trips = snapshot.data!;


          final filteredTrips = trips.where((trip) {
            return trip.departureCity.trim().toLowerCase() ==
                departure.trim().toLowerCase() &&
                trip.destinationCity.trim().toLowerCase() ==
                    destination.trim().toLowerCase() &&
                trip.availableSeats >= seats.length;
          }).toList();


          if (filteredTrips.isEmpty) {
            return const Center(child: Text('Aucun voyage trouvé'));
          }


          return ListView.builder(
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
                        builder: (context) => BookingScreen(
                          trip: trip,
                          seats: List<dynamic>.from(seats),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}