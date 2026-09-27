import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var creds = await controller.getSavedCredentials();
      if (creds['username']!.isNotEmpty) {
        usernameController.text = creds['username']!;
        passwordController.text = creds['password']!;
        controller.isRememberMeChecked.value = true;
      }
    });
    const Color primaryColor = Color(0xFF6366F1);
    const Color bgColor = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              // أيقونة التطبيق باستخدام Icons الأصلية
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: const Icon(Icons.auto_awesome_mosaic_rounded,
                    color: primaryColor, size: 32),
              ),
              const SizedBox(height: 24),
              Text(
                "مرحباً بك في\nالخبر اليمني",
                style: GoogleFonts.cairo(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 48),

              // حقل البريد
              _buildField(
                controller: usernameController,
                hint: "اسم المستخدم",
                icon: Icons.person_pin_outlined,
              ),
              const SizedBox(height: 20),

              // حقل كلمة المرور
              Obx(() => _buildField(
                    controller: passwordController,
                    hint: "كلمة المرور",
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    obscureText: !controller.isPasswordVisible.value,
                    onIconTap: () => controller.isPasswordVisible.toggle(),
                  )),
              Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.isRememberMeChecked.value,
                        onChanged: (val) =>
                            controller.isRememberMeChecked.value = val!,
                        activeColor: const Color(0xFF6366F1),
                        side: const BorderSide(color: Colors.white38),
                      ),
                      Text("تذكرني",
                          style: GoogleFonts.cairo(
                              color: Colors.white70, fontSize: 14)),
                    ],
                  )),
              const SizedBox(height: 20),

              // زر الدخول
              Obx(() => InkWell(
                    onTap: controller.isLoading.value
                        ? null
                        : () => controller.login(
                            usernameController.text, passwordController.text),
                    child: Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [primaryColor, Color(0xFF8B5CF6)]),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                "تسجيل الدخول",
                                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  )),

              const SizedBox(height: 40),

              Center(
                child: TextButton(
                  onPressed: () => Get.toNamed('/signup'),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.cairo(
                          color: Colors.white60, fontSize: 14),
                      children: [
                        const TextSpan(text: "ليس لديك حساب؟ "),
                        TextSpan(
                          text: "أنشئ حساباً مجانياً",
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onIconTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.white38, size: 20),
          hintText: hint,
          hintStyle: GoogleFonts.cairo(color: Colors.white24, fontSize: 14),
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white38,
                      size: 20),
                  onPressed: onIconTap,
                )
              : null,
        ),
      ),
    );
  }
}
