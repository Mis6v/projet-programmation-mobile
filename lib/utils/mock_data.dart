

import '../screens/models/trip.dart';

class MockData {
  static List<Trip> getPopularTrips() {
    return [
      Trip(
        id: '1',
        departureCity: 'Nouakchott',
        destinationCity: 'Aleg',
        departureTime: DateTime.now().add(const Duration(hours: 2)),
        arrivalTime: DateTime.now().add(const Duration(hours: 5)),
        price: 5000,
        transportType: 'Bus',
        availableSeats: 12,
        companyName: 'Esselam',
      ),
      Trip(
        id: '2',
        departureCity: 'Nouadhibou',
        destinationCity: 'Nouakchott',
        departureTime: DateTime.now().add(const Duration(hours: 4)),
        arrivalTime: DateTime.now().add(const Duration(hours: 10)),
        price: 6000,
        transportType: 'Bus',
        availableSeats: 5,
        companyName: 'Esselam',
      ),
      Trip(
        id: '3',
        departureCity: 'Kiffa',
        destinationCity: 'Nouakchott',
        departureTime: DateTime.now().add(const Duration(hours: 6)),
        arrivalTime: DateTime.now().add(const Duration(hours: 14)),
        price: 8000,
        transportType: 'Bus',
        availableSeats: 8,
        companyName: 'Esselam',
      ),
    ];
  }

  static List<Trip> searchTrips(String from, String to) {
    return getPopularTrips().where((trip) {
      return trip.departureCity.toLowerCase() == from.toLowerCase() &&
          trip.destinationCity.toLowerCase() == to.toLowerCase();
    }).toList();
  }
}