import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moyens de paiement')),
      body: const Center(
        child: Text(
          'Paiement via Bankily uniquement',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
