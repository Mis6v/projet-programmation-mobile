import 'package:get/get.dart';


class SearchTripController extends GetxController {

  var departureCity = 'Nouakchott'.obs;
  var destinationCity = 'Aleg'.obs;

  var selectedDate = DateTime.now().obs;

  var passengerCount = 1.obs;

  var selectedSeats = <dynamic>[].obs;

  void setDeparture(String city) {

    if (city == destinationCity.value) {

      Get.snackbar(
        'Erreur',
        'Choisissez une ville différente',
      );

      return;
    }

    departureCity.value = city;
  }

  void setDestination(String city) {

    if (city == departureCity.value) {

      Get.snackbar(
        'Erreur',
        'Choisissez une ville différente',
      );

      return;
    }

    destinationCity.value = city;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void setSeats(List<dynamic> seats) {

    selectedSeats.value = seats;

    passengerCount.value = seats.length;
  }
}