import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/trip.dart';

class ConfirmationScreen extends StatelessWidget {
  final Trip trip;
  const ConfirmationScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmation')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            Text("Votre voyage de ${trip.departureCity} à ${trip.destinationCity} est confirmé !"),
          ],
        ),
      ),
    );
  }
}