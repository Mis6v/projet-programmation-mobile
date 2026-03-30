class Trip {
  final String id;
  final String departureCity;
  final String destinationCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String transportType;
  final int availableSeats;
  final String companyName;

  Trip({
    required this.id,
    required this.departureCity,
    required this.destinationCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.transportType,
    required this.availableSeats,
    required this.companyName,
  });


  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'].toString(),
      departureCity: json['departureCity'],
      destinationCity: json['destinationCity'],
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: DateTime.parse(json['arrivalTime']),
      price: (json['price'] as num).toDouble(),
      transportType: json['transportType'] ?? 'Bus',
      availableSeats: json['availableSeats'] ?? 0,
      companyName: json['companyName'] ?? 'Esselam',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departureCity': departureCity,
      'destinationCity': destinationCity,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'price': price,
      'transportType': transportType,
      'availableSeats': availableSeats,
      'companyName': companyName,
    };
  }
}