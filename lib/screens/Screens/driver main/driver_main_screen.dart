import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transport_app/screens/Screens/driver%20home/driver_home_screen.dart';
import 'package:transport_app/screens/Screens/my%20recorded%20trips/my_recorded_trips_screen.dart';
import 'package:transport_app/screens/Screens/profile%20screen/parent%20screen/profile_screen.dart';

class DriverMainScreen extends StatefulWidget {
  final String phone;

  const DriverMainScreen({
    super.key,
    required this.phone,
  });

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  int _selectedIndex = 0;

  void _changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DriverHomeScreen(
        phone: widget.phone,
        onViewTrips: () => _changeIndex(1),
      ),
      MyRecordedTripsScreen(phone: widget.phone),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _changeIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.route),
            label: 'Mes trajets',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
