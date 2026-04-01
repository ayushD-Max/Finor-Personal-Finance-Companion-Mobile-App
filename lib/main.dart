import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'services/database_service.dart';
import 'controllers/transaction_controller.dart';
import 'controllers/goal_controller.dart';
import 'controllers/settings_controller.dart';
import 'screens/main_nav_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage
  await GetStorage.init();
  
  // Initialize database
  await DatabaseService.instance.database;
  
  // Register controllers
  Get.put(SettingsController());
  Get.put(TransactionController());
  Get.put(GoalController());
  
  runApp(const FinoraApp());
}

class FinoraApp extends StatelessWidget {
  const FinoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCtrl = Get.find<SettingsController>();

    return Obx(() => GetMaterialApp(
      title: 'Finora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsCtrl.themeMode.value,
      home: const MainNavScreen(),
      defaultTransition: Transition.fadeIn,
    ));
  }
}
