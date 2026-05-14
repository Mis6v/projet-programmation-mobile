import 'package:get/get.dart';
import '../utils/distance_helper.dart';

class PriceController extends GetxController {

  var price = 0.0.obs;

  void calculatePrice({
    required double totalDistance,
    required double userDistance,
    required double fullPrice,
  }) {
    price.value = DistanceHelper.calculatePrice(
      totalDistance,
      userDistance,
      fullPrice,
    );
  }
}