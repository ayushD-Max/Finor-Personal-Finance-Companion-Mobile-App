import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../controllers/settings_controller.dart';
import '../utils/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sCtrl = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ASTRAL PROFILE'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // PROFILE IMAGE BLOW-UP (FROM IMAGE 1)
            FadeInUp(
              child: Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primaryColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: const Icon(Icons.person, size: 64, color: AppTheme.primaryColor),
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: context.theme.scaffoldBackgroundColor, width: 3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: Column(
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        sCtrl.userName.value,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.secondaryColor, width: 0.5),
                        ),
                        child: const Text(
                          'AURA PRO',
                          style: TextStyle(color: AppTheme.secondaryColor, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ayush.deshmukh@finora.io',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // STATS ROW (FROM IMAGE 1)
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Row(
                children: [
                  _buildStatItem('MEMBER SINCE', '2023', Colors.cyan),
                  const SizedBox(width: 12),
                  _buildStatItem('TIER', 'Astral', Colors.purple),
                  const SizedBox(width: 12),
                  _buildStatItem('TRUST SCORE', '98%', Colors.teal),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // SETTINGS LIST
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(Icons.person_outline, 'Personal Information'),
                    _buildDivider(),
                    _buildSettingsTile(Icons.lock_outline, 'Security & Privacy'),
                    _buildDivider(),
                    _buildSettingsTile(Icons.link_outlined, 'Linked Accounts'),
                    _buildDivider(),
                    _buildSettingsTile(Icons.star_outline, 'Subscription Plan'),
                    _buildDivider(),
                    _buildSettingsTile(Icons.notifications_none, 'Notification Preferences'),
                    _buildDivider(),
                    // THEME TOGGLE
                    Obx(() => ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.dark_mode_outlined),
                      ),
                      title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: Switch.adaptive(
                        value: sCtrl.themeMode.value == ThemeMode.dark,
                        onChanged: (_) => sCtrl.toggleTheme(),
                        activeColor: AppTheme.primaryColor,
                      ),
                    )),
                    _buildDivider(),
                    _buildSettingsTile(Icons.help_outline, 'Support Center'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // LOG OUT
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout, color: AppTheme.errorColor),
                  label: const Text('LOG OUT', style: TextStyle(color: AppTheme.errorColor, fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.errorColor.withOpacity(0.05),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey[500])),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 64, color: Colors.grey.withOpacity(0.1));
  }
}
