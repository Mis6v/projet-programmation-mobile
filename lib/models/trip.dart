import 'driver.dart';

class Trip {
  final String id;
  final String? tripNumber;
  final Driver? driver;
  final String departureCity;
  final String destinationCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String transportType;
  final int availableSeats;
  final String companyName;
  final String? status;
  final double? progressPercentage;
  final double? departureLatitude;
  final double? departureLongitude;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final double? currentLatitude;
  final double? currentLongitude;
  final DateTime? lastLocationUpdate;

  Trip({
    required this.id,
    this.tripNumber,
    this.driver,
    required this.departureCity,
    required this.destinationCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.transportType,
    required this.availableSeats,
    required this.companyName,
    this.status,
    this.progressPercentage,
    this.departureLatitude,
    this.departureLongitude,
    this.destinationLatitude,
    this.destinationLongitude,
    this.currentLatitude,
    this.currentLongitude,
    this.lastLocationUpdate,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'].toString(),
      tripNumber: json['tripNumber']?.toString(),
      driver: json['driver'] is Map<String, dynamic>
          ? Driver.fromJson(json['driver'] as Map<String, dynamic>)
          : null,
      departureCity: json['departureCity'] ?? '',
      destinationCity: json['destinationCity'] ?? '',
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: DateTime.parse(json['arrivalTime']),
      price: (json['price'] as num).toDouble(),
      transportType: json['transportType'] ?? 'Bus',
      availableSeats: json['availableSeats'] ?? 0,
      companyName: json['companyName'] ?? 'Esselam',
      status: json['status']?.toString(),
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble(),
      departureLatitude: (json['departureLatitude'] as num?)?.toDouble(),
      departureLongitude: (json['departureLongitude'] as num?)?.toDouble(),
      destinationLatitude: (json['destinationLatitude'] as num?)?.toDouble(),
      destinationLongitude: (json['destinationLongitude'] as num?)?.toDouble(),
      currentLatitude: (json['currentLatitude'] as num?)?.toDouble(),
      currentLongitude: (json['currentLongitude'] as num?)?.toDouble(),
      lastLocationUpdate: json['lastLocationUpdate'] == null
          ? null
          : DateTime.parse(json['lastLocationUpdate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripNumber': tripNumber,
      'driver': driver?.toJson(),
      'departureCity': departureCity,
      'destinationCity': destinationCity,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'price': price,
      'transportType': transportType,
      'availableSeats': availableSeats,
      'companyName': companyName,
      'status': status,
      'progressPercentage': progressPercentage,
      'departureLatitude': departureLatitude,
      'departureLongitude': departureLongitude,
      'destinationLatitude': destinationLatitude,
      'destinationLongitude': destinationLongitude,
      'currentLatitude': currentLatitude,
      'currentLongitude': currentLongitude,
      'lastLocationUpdate': lastLocationUpdate?.toIso8601String(),
    };
  }
}

class TripRequest {
  final String tripNumber;
  final String? driverId;
  final String departureCity;
  final String destinationCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String transportType;
  final int availableSeats;
  final String companyName;
  final String status;
  final double progressPercentage;
  final double departureLatitude;
  final double departureLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  final double currentLatitude;
  final double currentLongitude;

  const TripRequest({
    required this.tripNumber,
    this.driverId,
    required this.departureCity,
    required this.destinationCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.transportType,
    required this.availableSeats,
    required this.companyName,
    required this.status,
    required this.progressPercentage,
    required this.departureLatitude,
    required this.departureLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.currentLatitude,
    required this.currentLongitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'tripNumber': tripNumber,
      if (driverId != null && driverId!.isNotEmpty) 'driverId': driverId,
      'departureCity': departureCity,
      'destinationCity': destinationCity,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'price': price,
      'transportType': transportType,
      'availableSeats': availableSeats,
      'companyName': companyName,
      'status': status,
      'progressPercentage': progressPercentage,
      'departureLatitude': departureLatitude,
      'departureLongitude': departureLongitude,
      'destinationLatitude': destinationLatitude,
      'destinationLongitude': destinationLongitude,
      'currentLatitude': currentLatitude,
      'currentLongitude': currentLongitude,
    };
  }
}
