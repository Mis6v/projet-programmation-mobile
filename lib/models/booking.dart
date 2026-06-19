import 'trip.dart';

class Booking {
  final String id;
  final Trip? trip;
  final String passengerName;
  final String passengerPhone;
  final List<int> seatNumbers;
  final String status;

  const Booking({
    required this.id,
    this.trip,
    required this.passengerName,
    required this.passengerPhone,
    required this.seatNumbers,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString() ?? '',
      trip: json['trip'] is Map<String, dynamic>
          ? Trip.fromJson(json['trip'] as Map<String, dynamic>)
          : null,
      passengerName: json['passengerName']?.toString() ?? '',
      passengerPhone: json['passengerPhone']?.toString() ?? '',
      seatNumbers: (json['seatNumbers'] as List<dynamic>? ?? [])
          .map((seat) => int.tryParse(seat.toString()) ?? 0)
          .toList(),
      status: json['status']?.toString() ?? '',
    );
  }
}
