import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/trip.dart';
import '../models/trip_tracking.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:9090/api';

  static Future<List<Trip>> getAllTrips() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trips'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Trip.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      log('Erreur getAllTrips', error: e);
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
      log('Erreur searchTrips', error: e);
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
      log('Erreur createBooking', error: e);
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
      log('Erreur getBookingsByPhone', error: e);
      return [];
    }
  }

  static Future<List<Trip>> getDriverTripsByPhone(String phone) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/drivers/phone/$phone/trips'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Trip.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      log('Erreur getDriverTripsByPhone', error: e);
      return [];
    }
  }

  static Future<TripTracking?> trackTrip(String tripNumber) async {
    try {
      final cleanTripNumber = Uri.encodeComponent(tripNumber.trim());
      final response = await http.get(
        Uri.parse('$baseUrl/trips/track/$cleanTripNumber'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body =
            jsonDecode(utf8.decode(response.bodyBytes));
        return TripTracking.fromJson(body);
      }
      return null;
    } catch (e) {
      log('Erreur trackTrip', error: e);
      return null;
    }
  }

  static Future<TripTracking?> updateTripLocation({
    required String tripNumber,
    required double latitude,
    required double longitude,
    double? progressPercentage,
  }) async {
    try {
      final cleanTripNumber = Uri.encodeComponent(tripNumber.trim());
      final response = await http.put(
        Uri.parse('$baseUrl/trips/track/$cleanTripNumber/location'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'currentLatitude': latitude,
          'currentLongitude': longitude,
          if (progressPercentage != null)
            'progressPercentage': progressPercentage,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body =
            jsonDecode(utf8.decode(response.bodyBytes));
        return TripTracking.fromJson(body);
      }
      return null;
    } catch (e) {
      log('Erreur updateTripLocation', error: e);
      return null;
    }
  }
}
