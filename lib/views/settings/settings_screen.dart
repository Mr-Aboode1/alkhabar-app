import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // استدعاء سوبابيس لقراءة بيانات الحساب
import '../../controllers/settings_controller.dart';
import '../../controllers/auth_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء المتحكمات
    final settingsController = Get.find<SettingsController>();
    final authController = Get.find<AuthController>();

    // جلب بيانات المستخدم الحالي المسجل في Supabase بشكل حقيقي
    final currentUser = Supabase.instance.client.auth.currentUser;
    final String realName =
        currentUser?.userMetadata?['full_name'] ?? 'مستخدم الحساب';
    final String realEmail = currentUser?.email ?? 'لا يوجد بريد إلكتروني';

    // تعريف الألوان المتناسقة مع الهوية الداكنة للتطبيق
    const Color primaryColor = Color(0xFF6366F1); // Indigo
    const Color cardColor = Color(0xFF1E293B); // Slate 800

    return Scaffold(
      // ✅ جعل الخلفية شفافة لتأخذ لون الـ HomeScreen الداكن الموحد بدون تضارب
      backgroundColor: Colors.transparent,

      // ✅ تم حذف الـ AppBar من هنا لأن الـ HomeScreen يعرضه الآن ديناميكياً لتجنب التكرار

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- قسم البروفايل يقرأ البيانات الحقيقية الآن ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.7)]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person_rounded,
                        size: 36, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          realName, // ✅ الاسم الحقيقي للمستخدم من قاعدة البيانات
                          style: GoogleFonts.cairo(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          realEmail, // ✅ الإيميل الحقيقي للمستخدم
                          style: GoogleFonts.cairo(
                              color: Colors.white70, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            _buildSectionTitle("تفضيلات التطبيق"),

            // --- بطاقة الإعدادات (Toggles) ---
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  Obx(() => _buildSettingSwitch(
                        title: "الوضع الليلي",
                        icon: Icons.dark_mode_rounded,
                        value: settingsController.isDarkMode.value,
                        onChanged: (val) =>
                            settingsController.toggleDarkMode(val),
                      )),
                  _buildDivider(),
                  Obx(() => _buildSettingSwitch(
                        title: "توفير البيانات",
                        icon: Icons.data_usage_rounded,
                        value: settingsController.isDataSaver.value,
                        onChanged: (val) =>
                            settingsController.toggleDataSaver(val),
                      )),
                  _buildDivider(),
                  Obx(() => _buildSettingSwitch(
                        title: "الإشعارات",
                        icon: Icons.notifications_active_rounded,
                        value: settingsController.notificationsEnabled.value,
                        onChanged: (val) =>
                            settingsController.toggleNotifications(val),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 25),
            _buildSectionTitle("النظام والدعم"),

            // --- بطاقة الإجراءات تعمل بشكل حقيقي ---
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  _buildActionTile(
                    title: "مسح التخزين المؤقت",
                    icon: Icons.cleaning_services_rounded,
                    color: Colors.orangeAccent,
                    onTap: () => settingsController.clearCache(),
                  ),
                  _buildDivider(),
                  _buildActionTile(
                    title: "حول التطبيق",
                    icon: Icons.info_outline_rounded,
                    color: Colors.blueAccent,
                    onTap: () {
                      _showAboutAppDialog(
                          context); // ✅ تفعيل زر حول التطبيق بنوافذ منبثقة
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // --- زر تسجيل الخروج المفعل ---
            InkWell(
              onTap: () {
                _showLogoutDialog(context, authController);
              },
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout_rounded,
                        color: Colors.redAccent, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "تسجيل الخروج",
                      style: GoogleFonts.cairo(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.cairo(
            color: Colors.white38, fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingSwitch({
    required String title,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6366F1), size: 22),
      title: Text(title,
          style: GoogleFonts.cairo(color: Colors.white, fontSize: 14)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF6366F1),
        activeTrackColor: const Color(0xFF6366F1).withOpacity(0.3),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 22),
      title: Text(title,
          style: GoogleFonts.cairo(color: Colors.white, fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          color: Colors.white10, size: 12),
    );
  }

  Widget _buildDivider() {
    return Divider(
        color: Colors.white.withOpacity(0.05), height: 1, indent: 50);
  }

  // ✅ نافذة منبثقة تفاعلية وحقيقية لـ "حول التطبيق" متناسقة مع التصميم الداكن
  void _showAboutAppDialog(BuildContext context) {
    Get.defaultDialog(
      backgroundColor: const Color(0xFF1E293B), // Slate 800
      title: "حول التطبيق",
      titleStyle: GoogleFonts.cairo(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const Icon(Icons.newspaper_rounded,
                color: Color(0xFF6366F1), size: 50),
            const SizedBox(height: 15),
            Text(
              "تطبيق الخبر اليقين",
              style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            const SizedBox(height: 5),
            Text(
              "الإصدار v1.0.0\n\nمنصة إخبارية متكاملة تقدم الأخبار العاجلة والمؤكدة لحظة بلحظة وبمصداقية تامة.\n\nتم التطوير باستخدام Flutter & Supabase",
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(color: Colors.white60, fontSize: 13),
            ),
          ],
        ),
      ),
      textCancel: "إغلاق",
      cancelTextColor: Colors.white70,
      buttonColor: const Color(0xFF6366F1),
    );
  }

  // حوار تأكيد الخروج المتناسق
  void _showLogoutDialog(BuildContext context, AuthController authController) {
    Get.defaultDialog(
      backgroundColor: const Color(0xFF1E293B),
      title: "تسجيل الخروج",
      titleStyle: GoogleFonts.cairo(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      middleText: "هل أنت متأكد أنك تريد مغادرة التطبيق؟",
      middleTextStyle: GoogleFonts.cairo(color: Colors.white70, fontSize: 14),
      textConfirm: "نعم، خروج",
      textCancel: "تراجع",
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.white70,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        authController.logout();
      },
    );
  }
}
