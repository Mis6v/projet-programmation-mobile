import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aide & Support')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Pour toute aide, contactez-nous :',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Email: EsselamTransport@gmail.com'),
            Text('WhatsApp: 42382182'),
          ],
        ),
      ),
    );
  }
}
