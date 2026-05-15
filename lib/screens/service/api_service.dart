import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.8.3:9090/api';



  static Future<List<Trip>> getAllTrips() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trips'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Trip.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Erreur getAllTrips: $e');
      return [];
    }
  }

  static Future<List<Trip>> searchTrips(
      String from,
      String to,
      DateTime date,
      ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/trips/search?from=$from&to=$to&date=${date.toIso8601String()}',
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Trip.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Erreur searchTrips: $e');
      return [];
    }
  }


  static Future<bool> createBooking(
      String tripId,
      String name,
      String passengerPhone,
      List<int> seatNumbers,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tripId': tripId,
          'passengerName': name,
          'passengerPhone': passengerPhone,
          'seatNumbers': seatNumbers,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Erreur createBooking: $e');
      return false;
    }
  }



  static Future<List<dynamic>> getBookingsByPhone(String passengerPhone) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/user/$passengerPhone'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return [];
    } catch (e) {
      print('Erreur getBookingsByPhone: $e');
      return [];
    }
  }
}