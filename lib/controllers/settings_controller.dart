import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final RxBool isDarkMode = false.obs;
  final RxBool isDataSaver = false.obs;
  final RxBool notificationsEnabled = true.obs;
  final RxDouble fontSizeScale = 1.0.obs; // 0.85, 1.0, 1.25

  @override
  void onInit() {
    super.onInit();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('is_dark_mode') ?? false;
    isDataSaver.value = prefs.getBool('is_data_saver') ?? false;
    notificationsEnabled.value = prefs.getBool('notifications_enabled') ?? true;
    fontSizeScale.value = prefs.getDouble('font_size_scale') ?? 1.0;
  }

  Future<void> toggleDarkMode(bool val) async {
    isDarkMode.value = val;
    Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', val);
  }

  Future<void> toggleDataSaver(bool val) async {
    isDataSaver.value = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_data_saver', val);
  }

  Future<void> toggleNotifications(bool val) async {
    notificationsEnabled.value = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', val);
  }

  Future<void> setFontSize(double scale) async {
    fontSizeScale.value = scale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_size_scale', scale);
  }

  Future<void> clearCache() async {
    await _storageService.clearAllCache();
    Get.snackbar(
      'تم بنجاح',
      'تم مسح التخزين المؤقت وتحرير المساحة',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF28A745),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}
