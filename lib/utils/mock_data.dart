import 'package:transport_app/models/trip.dart';

class MockData {
  static List<Trip> getPopularTrips() {
    return [
      Trip(
        id: '1',
        departureCity: 'Abidjan',
        destinationCity: 'Yamoussoukro',
        departureTime: DateTime.now().add(const Duration(hours: 2)),
        arrivalTime: DateTime.now().add(const Duration(hours: 5)),
        price: 5000,
        transportType: 'Bus',
        availableSeats: 12,
        companyName: 'UTB Express',
      ),
      Trip(
        id: '2',
        departureCity: 'Abidjan',
        destinationCity: 'Bouaké',
        departureTime: DateTime.now().add(const Duration(hours: 4)),
        arrivalTime: DateTime.now().add(const Duration(hours: 10)),
        price: 8000,
        transportType: 'Bus',
        availableSeats: 5,
        companyName: 'AVS Transport',
      ),
      Trip(
        id: '3',
        departureCity: 'San Pedro',
        destinationCity: 'Abidjan',
        departureTime: DateTime.now().add(const Duration(hours: 6)),
        arrivalTime: DateTime.now().add(const Duration(hours: 14)),
        price: 10000,
        transportType: 'Bus',
        availableSeats: 8,
        companyName: 'AHT Express',
      ),
    ];
  }

  static List<Trip> searchTrips(String from, String to) {
    return getPopularTrips().where((trip) => 
      trip.departureCity.toLowerCase() == from.toLowerCase() && 
      trip.destinationCity.toLowerCase() == to.toLowerCase()
    ).toList();
  }
}
