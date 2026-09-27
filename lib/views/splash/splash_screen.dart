import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart'; // للتأكد من الوصول لـ AppRoutes

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    // الانتظار لمدة ثانيتين ليعطي انطباع شاشة البداية وعرض الشعار
    await Future.delayed(const Duration(seconds: 2));

    // الفحص الحقيقي: هل توجد جلسة نشطة للمستخدم؟
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // مستخدم مسجل دخول مسبقاً -> اذهب للرئيسية
      Get.offAllNamed(AppRoutes.home);
    } else {
      // مستخدم جديد أو سجل خروجه -> اذهب لصفحة تسجيل الدخول
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0F172A), // لون داكن فخم يوافق التصميم الجديد
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // شعار متحرك أو أيقونة ذكية
            const Icon(
              Icons.auto_awesome_mosaic_rounded,
              size: 80,
              color: Color(0xFF6366F1),
            ),
            const SizedBox(height: 24),
            Text(
              "الخبر اليمني",
              style: GoogleFonts.cairo(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "مصداقية الخبر في مكان واحد",
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
