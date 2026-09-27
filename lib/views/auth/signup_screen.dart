import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/auth_controller.dart';
import '../../main.dart'; // للوصول إلى AppRoutes

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  // استدعاء الـ AuthController المحقون مسبقاً في الـ main
  final AuthController controller = Get.find<AuthController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // متغير محلي لإظهار وإخفاء كلمة المرور
  final RxBool _isPasswordHidden = true.obs;

  @override
  Widget build(BuildContext context) {
    // الألوان - تم إزالة const من الألوان التي قد تسبب مشاكل في بعض الإصدارات
    final Color primaryColor = const Color(0xFF6366F1);
    final Color bgColor = const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // زر العودة للخلف - تم تصحيح الأيقونة وإزالة const المسببة للخطأ
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 22),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 30),

              // أيقونة الصفحة
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: Icon(Icons.person_add_alt_1_outlined,
                    color: primaryColor, size: 32),
              ),

              const SizedBox(height: 24),

              Text(
                "إنشاء حساب جديد",
                style: GoogleFonts.cairo(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "انضم إلينا لتخصيص تجربتك الإخبارية ومتابعة الأحداث أولاً بأول",
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),

              const SizedBox(height: 40),

              // حقل الاسم الكامل
              _buildField(
                controller: nameController,
                hint: "الاسم الكامل",
                icon: Icons.person_outline_rounded,
              ),

              const SizedBox(height: 20),

              // حقل البريد الإلكتروني
              _buildField(
                controller: emailController,
                hint: "البريد الإلكتروني",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // حقل كلمة المرور
              Obx(() => _buildField(
                    controller: passwordController,
                    hint: "كلمة المرور",
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    obscureText: _isPasswordHidden.value,
                    onIconTap: () => _isPasswordHidden.toggle(),
                  )),

              const SizedBox(height: 40),

              // زر إنشاء الحساب
              Obx(() => InkWell(
                    onTap: controller.isLoading.value
                        ? null
                        : () {
                            if (nameController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              Get.snackbar("تنبيه", "الرجاء ملء جميع الحقول",
                                  backgroundColor:
                                      Colors.orangeAccent.withOpacity(0.8),
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM);
                              return;
                            }
                            controller.register(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                nameController.text.trim());
                          },
                    child: Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [primaryColor, const Color(0xFF8B5CF6)]),
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
                                "تسجيل الحساب",
                                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  )),

              const SizedBox(height: 30),

              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.cairo(
                          color: Colors.white60, fontSize: 14),
                      children: [
                        const TextSpan(text: "لديك حساب بالفعل؟ "),
                        TextSpan(
                          text: "تسجيل الدخول",
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
    TextInputType keyboardType = TextInputType.text,
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
        keyboardType: keyboardType,
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
