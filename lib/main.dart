import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transport_app/controllers/navigation_controller.dart';
import 'package:transport_app/screens/shared/role_selection_screen.dart';
import 'package:transport_app/screens/user/bookings/bookings_screen.dart';
import 'package:transport_app/screens/user/home/home_screen.dart';
import 'package:transport_app/screens/user/profile/profile_screen.dart';
import 'package:transport_app/screens/user/search/search_screen.dart';
import 'package:transport_app/theme/app_theme.dart';

void main() => runApp(const TransportApp());

class TransportApp extends StatelessWidget {
  const TransportApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Esselam Transport',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RoleSelectionScreen(),
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
