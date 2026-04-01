import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final box = GetStorage();
  var userName = 'User'.obs;
  var themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    final isDark = box.read('isDark');
    if (isDark != null) {
      themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    }
    userName.value = box.read('userName') ?? 'Ayush';
  }

  void toggleTheme() {
    final isDark = themeMode.value == ThemeMode.dark;
    themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;
    box.write('isDark', !isDark);
    Get.changeThemeMode(themeMode.value);
  }

  void updateUserName(String name) {
    userName.value = name;
    box.write('userName', name);
  }
}
