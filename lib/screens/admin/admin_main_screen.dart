import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:transport_app/screens/admin/admin_dashboard_screen.dart';
import 'package:transport_app/screens/admin/admin_drivers_screen.dart';
import 'package:transport_app/screens/admin/admin_trips_screen.dart';
import 'package:transport_app/screens/shared/role_selection_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const AdminDashboardScreen(),
      const AdminDriversScreen(),
      const AdminTripsScreen(),
      _AdminProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartLine),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.idCard),
            label: 'Drivers',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.route),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userShield),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _AdminProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(FontAwesomeIcons.userShield, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Session admin locale',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      Get.offAll(() => const RoleSelectionScreen()),
                  icon: const Icon(FontAwesomeIcons.rightFromBracket),
                  label: const Text('DECONNEXION'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
