import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip.dart';

class ApiService {

  static const String baseUrl = 'http://10.0.2.2:8080/api';


  static Future<List<Trip>> getAllTrips() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trips'),
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Trip.fromJson(item)).toList();
      } else {
        throw Exception('Erreur serveur');
      }
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
      final String formattedDate = date.toIso8601String();

      final response = await http.get(
        Uri.parse(
          '$baseUrl/trips/search?from=$from&to=$to&date=$formattedDate',
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Trip.fromJson(item)).toList();
      } else {
        throw Exception('Erreur recherche');
      }
    } catch (e) {
      print('Erreur searchTrips: $e');
      return [];
    }
  }


  static Future<bool> createBooking(
      String tripId,
      String name,
      String phone,
      String seat,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tripId': tripId,
          'passengerName': name,
          'phoneNumber': phone,
          'seatNumber': seat,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Erreur createBooking: $e');
      return false;
    }
  }
}