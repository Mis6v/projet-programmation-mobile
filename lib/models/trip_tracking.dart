class TripTracking {
  final String tripId;
  final String tripNumber;
  final String departureCity;
  final String destinationCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String status;
  final double progressPercentage;
  final double departureLatitude;
  final double departureLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  final double? currentLatitude;
  final double? currentLongitude;
  final DateTime? lastLocationUpdate;
  final String companyName;
  final String? driverName;
  final String? driverPhone;
  final String? vehicleName;
  final String? vehiclePlate;

  TripTracking({
    required this.tripId,
    required this.tripNumber,
    required this.departureCity,
    required this.destinationCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.status,
    required this.progressPercentage,
    required this.departureLatitude,
    required this.departureLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    this.currentLatitude,
    this.currentLongitude,
    this.lastLocationUpdate,
    required this.companyName,
    this.driverName,
    this.driverPhone,
    this.vehicleName,
    this.vehiclePlate,
  });

  factory TripTracking.fromJson(Map<String, dynamic> json) {
    return TripTracking(
      tripId: json['tripId']?.toString() ?? '',
      tripNumber: json['tripNumber']?.toString() ?? '',
      departureCity: json['departureCity'] ?? '',
      destinationCity: json['destinationCity'] ?? '',
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: DateTime.parse(json['arrivalTime']),
      status: json['status']?.toString() ?? 'SCHEDULED',
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0,
      departureLatitude: (json['departureLatitude'] as num?)?.toDouble() ?? 0,
      departureLongitude: (json['departureLongitude'] as num?)?.toDouble() ?? 0,
      destinationLatitude:
          (json['destinationLatitude'] as num?)?.toDouble() ?? 0,
      destinationLongitude:
          (json['destinationLongitude'] as num?)?.toDouble() ?? 0,
      currentLatitude: (json['currentLatitude'] as num?)?.toDouble(),
      currentLongitude: (json['currentLongitude'] as num?)?.toDouble(),
      lastLocationUpdate: json['lastLocationUpdate'] == null
          ? null
          : DateTime.parse(json['lastLocationUpdate']),
      companyName: json['companyName'] ?? 'Esselam',
      driverName: json['driverName']?.toString(),
      driverPhone: json['driverPhone']?.toString(),
      vehicleName: json['vehicleName']?.toString(),
      vehiclePlate: json['vehiclePlate']?.toString(),
    );
  }

  double get progressValue => (progressPercentage / 100).clamp(0, 1);
}
