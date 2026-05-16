import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:transport_app/screens/shared/role_selection_screen.dart';
import 'package:transport_app/theme/app_theme.dart';

import 'edit_profile_screen.dart';
import 'notification_screen.dart';
import 'payment_screen.dart';
import 'support_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Moustapha taleb";
  String email = "tafataleb21@email.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildProfileMenu(context),
            const SizedBox(height: 32),
            _buildLogoutButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 60, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildMenuItem(FontAwesomeIcons.userPen, 'Modifier le profil',
              () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditProfileScreen(
                  currentName: name,
                  currentEmail: email,
                ),
              ),
            );

            if (result != null) {
              setState(() {
                name = result['name'];
                email = result['email'];
              });
            }
          }),
          _buildMenuItem(FontAwesomeIcons.creditCard, 'Moyens de paiement', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PaymentScreen()));
          }),
          _buildMenuItem(FontAwesomeIcons.bell, 'Notifications', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NotificationScreen()));
          }),
          _buildMenuItem(FontAwesomeIcons.circleQuestion, 'Aide & Support', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SupportScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 18, color: AppTheme.primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
        onPressed: () => Get.offAll(() => const RoleSelectionScreen()),
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text('Déconnexion', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
