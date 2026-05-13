import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transport_app/screens/Screens/home%20screen/home_screen.dart';
import 'package:transport_app/theme/app_theme.dart';
import 'package:transport_app/screens/Screens/search%20screen/parent%20screen/search_screen.dart';
import 'package:transport_app/screens/Screens/bookings%20screen/parent%20screen/bookings_screen.dart';
import 'package:transport_app/screens/Screens/profile%20screen/parent%20screen/profile_screen.dart';
import 'package:transport_app/screens/Screens/login%20screen/Loginscreen.dart';
import 'package:transport_app/controllers/navigation_controller.dart';

void main() => runApp(const TransportApp());

class TransportApp extends StatelessWidget {
  const TransportApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Esselam Transport',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}

class MainNavigation extends StatelessWidget {
  final String phone;
  MainNavigation({super.key, required this.phone});
  final NavigationController navCtrl = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      SearchScreen(),
      BookingsScreen(phone: phone),
      const ProfileScreen()
    ];
    return Scaffold(
      body: Obx(() =>
          IndexedStack(index: navCtrl.selectedIndex.value, children: screens)),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: navCtrl.selectedIndex.value,
            onTap: navCtrl.changeIndex,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.house), label: 'Accueil'),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.magnifyingGlass),
                  label: 'Recherche'),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.ticket), label: 'Mes billets'),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.user), label: 'Profil'),
            ],
          )),
    );
  }
}
