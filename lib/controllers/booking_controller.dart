import 'package:get/get.dart';
import 'package:transport_app/screens/service/api_service.dart';

class BookingController extends GetxController {
  var bookings = <dynamic>[].obs;
  var isLoading = true.obs;

  Future<void> loadBookings(String phone) async {
    try {
      isLoading.value = true;
      final data = await ApiService.getBookingsByPhone(phone);
      bookings.value = data;
    } finally {
      isLoading.value = false;
    }
  }

  List<dynamic> get confirmedBookings => bookings.where((b) => b['status'].toString().toUpperCase() == "CONFIRMED").toList();
}
