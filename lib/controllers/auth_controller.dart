import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/services/supabase_service.dart';
import '../main.dart'; // للوصول إلى AppRoutes

class AuthController extends GetxController {
  SupabaseService get _authService => Get.find<SupabaseService>();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isRememberMeChecked = false.obs;

  // --- 1. دالة تسجيل الدخول باستخدام اسم المستخدم ---
  Future<void> login(String username, String password) async {
    try {
      isLoading.value = true;
      final cleanUsername = username.trim();
      final cleanPassword = password.trim();

      if (cleanUsername.isEmpty || cleanPassword.isEmpty) {
        Get.snackbar("تنبيه", "الرجاء إدخال اسم المستخدم وكلمة المرور");
        return;
      }

      // البحث عن البريد الإلكتروني المرتبط باسم المستخدم من جدول profiles
      final userData = await Supabase.instance.client
          .from('profiles')
          .select('email')
          .eq('full_name', cleanUsername)
          .maybeSingle();

      if (userData == null) {
        Get.snackbar("خطأ", "اسم المستخدم هذا غير موجود",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return;
      }

      final String userEmail = userData['email'];

      // تسجيل الدخول باستخدام البريد الذي وجدناه
      final response = await _authService.signIn(
        email: userEmail,
        password: cleanPassword,
      );

      if (response.session != null) {
        // حفظ البيانات إذا كان خيار "تذكرني" مفعلاً
        _saveUserCredentials(cleanUsername, cleanPassword);

        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar("فشل الدخول", "اسم المستخدم أو كلمة المرور غير صحيحة",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- 2. إنشاء حساب جديد والدخول المباشر ---
  Future<void> register(String email, String password, String name) async {
    try {
      isLoading.value = true;

      // إنشاء الحساب في Supabase
      final response = await _authService.signUp(
          email: email.trim(),
          password: password.trim(),
          data: {'full_name': name.trim()});

      if (response.user != null) {
        // تسجيل الدخول تلقائياً فور نجاح التسجيل
        await _authService.signIn(
            email: email.trim(), password: password.trim());

        Get.snackbar("مرحباً بك", "تم إنشاء الحساب بنجاح",
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white);
        _saveUserCredentials(name.trim(), password.trim());
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      String errorMsg = "فشل إنشاء الحساب، يرجى المحاولة لاحقاً";
      if (e.toString().contains("user_already_exists")) {
        errorMsg = "هذا البريد الإلكتروني مسجل بالفعل";
      }
      Get.snackbar("خطأ", errorMsg,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- 3. تسجيل الخروج ---
  Future<void> logout() async {
    try {
      await _authService.signOut();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar("خطأ", "فشل تسجيل الخروج");
    }
  }

  // --- 4. وظائف "تذكرني" ---
  void _saveUserCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', isRememberMeChecked.value);
    if (isRememberMeChecked.value) {
      await prefs.setString('saved_username', username);
      await prefs.setString('saved_password', password);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_username');
      await prefs.remove('saved_password');
    }
  }

  Future<Map<String, String>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString('saved_username') ?? '',
      'password': prefs.getString('saved_password') ?? '',
    };
  }
}
