class Trip {
  final String id;
  final String departureCity;
  final String destinationCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String transportType; // Bus, Train, Minibus
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

  String get duration {
    final diff = arrivalTime.difference(departureTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}
