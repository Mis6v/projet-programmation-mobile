import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Votre voyage a été retardé'),
          ),
          ListTile(
            title: Text('Voyage annulé temporairement'),
          ),
          ListTile(
            title: Text('Nouveau horaire disponible'),
          ),
        ],
      ),
    );
  }
}
