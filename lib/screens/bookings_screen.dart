import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../controllers/booking_controller.dart';
import 'service/api_service.dart';

class BookingsScreen extends StatelessWidget {
  final String phone;

  BookingsScreen({
    super.key,
    required this.phone,
  });

  final BookingController controller = Get.put(BookingController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadBookings(phone);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes billets"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final confirmedBookings = controller.confirmedBookings;

        if (confirmedBookings.isEmpty) {
          return const Center(
            child: Text("Aucun billet trouvé"),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: confirmedBookings.length,
          itemBuilder: (context, index) {
            final booking = confirmedBookings[index];
            final trip = booking['trip'];

            return Card(
              child: ListTile(
                title: Text(
                  "${trip['departureCity']} → ${trip['destinationCity']}",
                ),
                subtitle: Text(
                  "Départ : ${trip['departureTime']}\n"
                      "Places : ${booking['seatNumbers']}",
                ),
              ),
            );
          },
        );
      }),
    );
  }
}