import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../models/booking.dart';
import '../models/driver.dart';
import '../models/trip.dart';
import '../models/trip_tracking.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:9090/api';
  static const String authBaseUrl = 'http://localhost:9090/auth';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  static dynamic _decode(http.Response response) {
    if (response.body.isEmpty) return null;
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  static bool _isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static Future<String> login(String telephone, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$authBaseUrl/login'),
        headers: _headers,
        body: jsonEncode({'telephone': telephone, 'code': code}),
      );
      return response.body.trim();
    } catch (e) {
      log('Erreur login', error: e);
      return 'SERVER_ERROR';
    }
  }

  static Future<String> register(String telephone, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$authBaseUrl/register'),
        headers: _headers,
        body: jsonEncode({'telephone': telephone, 'code': code}),
      );
      return response.body.trim();
    } catch (e) {
      log('Erreur register', error: e);
      return 'SERVER_ERROR';
    }
  }

  static Future<List<Trip>> getTrips() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trips'));
      if (_isSuccess(response)) {
        final body = _decode(response) as List<dynamic>;
        return body.map((item) => Trip.fromJson(item)).toList();
      }
    } catch (e) {
      log('Erreur getTrips', error: e);
    }
    return [];
  }

  static Future<List<Trip>> getAllTrips() => getTrips();

  static Future<List<Trip>> searchTrips(
    String from,
    String to,
    DateTime date,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/trips/search').replace(
        queryParameters: {
          'from': from,
          'to': to,
          'date': date.toIso8601String(),
        },
      );
      final response = await http.get(uri);
      if (_isSuccess(response)) {
        final body = _decode(response) as List<dynamic>;
        return body.map((item) => Trip.fromJson(item)).toList();
      }
    } catch (e) {
      log('Erreur searchTrips', error: e);
    }
    return [];
  }

  static Future<Trip?> getTripById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trips/$id'));
      if (_isSuccess(response)) return Trip.fromJson(_decode(response));
    } catch (e) {
      log('Erreur getTripById', error: e);
    }
    return null;
  }

  static Future<TripTracking?> trackTrip(String tripNumber) async {
    try {
      final cleanTripNumber = Uri.encodeComponent(tripNumber.trim());
      final response = await http.get(
        Uri.parse('$baseUrl/trips/track/$cleanTripNumber'),
      );
      if (_isSuccess(response)) return TripTracking.fromJson(_decode(response));
    } catch (e) {
      log('Erreur trackTrip', error: e);
    }
    return null;
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
        headers: _headers,
        body: jsonEncode({
          'currentLatitude': latitude,
          'currentLongitude': longitude,
          if (progressPercentage != null)
            'progressPercentage': progressPercentage,
        }),
      );
      if (_isSuccess(response)) return TripTracking.fromJson(_decode(response));
    } catch (e) {
      log('Erreur updateTripLocation', error: e);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> generateShareLink(
    String tripNumber,
  ) async {
    try {
      final cleanTripNumber = Uri.encodeComponent(tripNumber.trim());
      final response = await http.post(
        Uri.parse('$baseUrl/trips/track/$cleanTripNumber/share'),
      );
      if (_isSuccess(response)) return _decode(response);
    } catch (e) {
      log('Erreur generateShareLink', error: e);
    }
    return null;
  }

  static Future<TripTracking?> getPublicTracking(String token) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/trips/public/$token'));
      if (_isSuccess(response)) return TripTracking.fromJson(_decode(response));
    } catch (e) {
      log('Erreur getPublicTracking', error: e);
    }
    return null;
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
        headers: _headers,
        body: jsonEncode({
          'tripId': tripId,
          'passengerName': name,
          'passengerPhone': passengerPhone,
          'seatNumbers': seatNumbers,
        }),
      );
      return _isSuccess(response);
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
      if (_isSuccess(response)) return _decode(response) as List<dynamic>;
    } catch (e) {
      log('Erreur getBookingsByPhone', error: e);
    }
    return [];
  }

  static Future<List<Booking>> getBookingModelsByPhone(String phone) async {
    final bookings = await getBookingsByPhone(phone);
    return bookings
        .whereType<Map<String, dynamic>>()
        .map(Booking.fromJson)
        .toList();
  }

  static Future<Booking?> getBookingById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bookings/$id'));
      if (_isSuccess(response)) return Booking.fromJson(_decode(response));
    } catch (e) {
      log('Erreur getBookingById', error: e);
    }
    return null;
  }

  static Future<List<Driver>> getDrivers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/drivers'));
      if (_isSuccess(response)) {
        final body = _decode(response) as List<dynamic>;
        return body.map((item) => Driver.fromJson(item)).toList();
      }
    } catch (e) {
      log('Erreur getDrivers', error: e);
    }
    return [];
  }

  static Future<Driver?> getDriverByPhone(String phone) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/drivers/phone/$phone'));
      if (_isSuccess(response)) return Driver.fromJson(_decode(response));
    } catch (e) {
      log('Erreur getDriverByPhone', error: e);
    }
    return null;
  }

  static Future<List<Trip>> getDriverTripsByPhone(String phone) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/drivers/phone/$phone/trips'),
      );
      if (_isSuccess(response)) {
        final body = _decode(response) as List<dynamic>;
        return body.map((item) => Trip.fromJson(item)).toList();
      }
    } catch (e) {
      log('Erreur getDriverTripsByPhone', error: e);
    }
    return [];
  }

  static Future<List<Trip>> getDriverTrips(String driverId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/drivers/$driverId/trips'));
      if (_isSuccess(response)) {
        final body = _decode(response) as List<dynamic>;
        return body.map((item) => Trip.fromJson(item)).toList();
      }
    } catch (e) {
      log('Erreur getDriverTrips', error: e);
    }
    return [];
  }

  static Future<List<Driver>> getAdminDrivers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admin/drivers'));
      if (_isSuccess(response)) {
        final body = _decode(response) as List<dynamic>;
        return body.map((item) => Driver.fromJson(item)).toList();
      }
    } catch (e) {
      log('Erreur getAdminDrivers', error: e);
    }
    return [];
  }

  static Future<Driver> createAdminDriver(DriverRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/drivers'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );
    if (!_isSuccess(response)) throw Exception('Driver create failed');
    return Driver.fromJson(_decode(response));
  }

  static Future<Driver> updateAdminDriver(
    String id,
    DriverRequest request,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/drivers/$id'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );
    if (!_isSuccess(response)) throw Exception('Driver update failed');
    return Driver.fromJson(_decode(response));
  }

  static Future<void> deleteAdminDriver(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/admin/drivers/$id'));
    if (!_isSuccess(response)) throw Exception('Driver delete failed');
  }

  static Future<List<Trip>> getAdminDriverTrips(String id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/admin/drivers/$id/trips'));
      if (_isSuccess(response)) {
        final body = _decode(response) as List<dynamic>;
        return body.map((item) => Trip.fromJson(item)).toList();
      }
    } catch (e) {
      log('Erreur getAdminDriverTrips', error: e);
    }
    return [];
  }

  static Future<List<Trip>> getAdminTrips() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admin/trips'));
      if (_isSuccess(response)) {
        final body = _decode(response) as List<dynamic>;
        return body.map((item) => Trip.fromJson(item)).toList();
      }
    } catch (e) {
      log('Erreur getAdminTrips', error: e);
    }
    return [];
  }

  static Future<Trip> createAdminTrip(TripRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/trips'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );
    if (!_isSuccess(response)) throw Exception('Trip create failed');
    return Trip.fromJson(_decode(response));
  }

  static Future<Trip> updateAdminTrip(String id, TripRequest request) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/trips/$id'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );
    if (!_isSuccess(response)) throw Exception('Trip update failed');
    return Trip.fromJson(_decode(response));
  }

  static Future<Trip> startTrip(Trip trip) {
    return updateAdminTrip(
      trip.id,
      TripRequest(
        tripNumber: trip.tripNumber ?? '',
        driverId: trip.driver?.id,
        departureCity: trip.departureCity,
        destinationCity: trip.destinationCity,
        departureTime: trip.departureTime,
        arrivalTime: trip.arrivalTime,
        price: trip.price,
        transportType: trip.transportType,
        availableSeats: trip.availableSeats,
        companyName: trip.companyName,
        status: 'IN_PROGRESS',
        progressPercentage: trip.progressPercentage ?? 0,
        departureLatitude: trip.departureLatitude ?? 0,
        departureLongitude: trip.departureLongitude ?? 0,
        destinationLatitude: trip.destinationLatitude ?? 0,
        destinationLongitude: trip.destinationLongitude ?? 0,
        currentLatitude: trip.currentLatitude ?? trip.departureLatitude ?? 0,
        currentLongitude: trip.currentLongitude ?? trip.departureLongitude ?? 0,
      ),
    );
  }

  static Future<void> deleteAdminTrip(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/admin/trips/$id'));
    if (!_isSuccess(response)) throw Exception('Trip delete failed');
  }

  static Future<Trip> assignDriverToTrip(String tripId, String driverId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/trips/$tripId/driver/$driverId'),
    );
    if (!_isSuccess(response)) throw Exception('Driver assign failed');
    return Trip.fromJson(_decode(response));
  }

  static Future<Trip> removeDriverFromTrip(String tripId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/trips/$tripId/driver'),
    );
    if (!_isSuccess(response)) throw Exception('Driver remove failed');
    return Trip.fromJson(_decode(response));
  }
}
