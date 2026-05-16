class Trip {
  final String id;
  final String? tripNumber;
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
  final Map<String, dynamic>? driver;

  Trip({
    required this.id,
    this.tripNumber,
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
    this.driver,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'].toString(),
      tripNumber: json['tripNumber']?.toString(),
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
      driver: json['driver'] is Map<String, dynamic> ? json['driver'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripNumber': tripNumber,
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
      'driver': driver,
    };
  }
}
