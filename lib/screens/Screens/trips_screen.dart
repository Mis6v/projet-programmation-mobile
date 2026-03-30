import 'package:flutter/material.dart';



import '../models/trip.dart';

class TripsScreen extends StatelessWidget {
  final String departure;
  final String destination;

  const TripsScreen({
    super.key,
    required this.departure,
    required this.destination,
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
        destinationCity: 'Aleg',
        departureTime: DateTime.now().add(const Duration(days: 1)),
        arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
        price: 5000,
        transportType: 'Bus',
        availableSeats: 5,
        companyName: 'Esselam',
      ),
    ];


    final filteredTrips = trips.where((trip) {
      return trip.departureCity.toLowerCase() == departure.toLowerCase() &&
          trip.destinationCity.toLowerCase() == destination.toLowerCase();
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: filteredTrips.isEmpty
          ? const Center(child: Text('Aucun voyage trouvé'))
          : ListView.builder(
        itemCount: filteredTrips.length,
        itemBuilder: (context, index) {
          final trip = filteredTrips[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                '${trip.departureCity} → ${trip.destinationCity}',
              ),
              subtitle: Text(
                'Départ: ${trip.departureTime.day}/${trip.departureTime.month} à ${trip.departureTime.hour}:${trip.departureTime.minute}',
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${trip.availableSeats} places'),
                  Text('${trip.price} MRU'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}