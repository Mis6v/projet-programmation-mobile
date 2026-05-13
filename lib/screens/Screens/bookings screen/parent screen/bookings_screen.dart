import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transport_app/theme/app_theme.dart';
import '../../../service/api_service.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  List<dynamic> bookings = [];
  bool loading = true;

  final String phone = "22222222"; // remplace par user connecté

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  void loadBookings() async {
    bookings = await ApiService.getBookingsByPhone(phone);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = bookings
        .where((b) => b['status'] == "CONFIRMED")
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Mes Billets")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: upcoming.length,
        itemBuilder: (context, i) {
          final b = upcoming[i];
          final trip = b['trip'];

          return Card(
            child: ListTile(
              title: Text(
                "${trip['departureCity']} → ${trip['destinationCity']}",
              ),
              subtitle: Text(
                "Départ: ${trip['departureTime']}\nPlaces: ${b['seatNumbers']}",
              ),
            ),
          );
        },
      ),
    );
  }
}