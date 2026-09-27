import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobile_app/views/auth/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/login_screen.dart';
import 'controllers/auth_controller.dart';

// Constants
import 'core/constants/api_endpoints.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';

// Services
import 'data/services/supabase_service.dart';
import 'data/services/storage_service.dart';

// Repositories
import 'data/repositories/news_repository.dart';
import 'data/repositories/source_repository.dart';

// Controllers
import 'controllers/news_controller.dart';
import 'controllers/source_controller.dart';
import 'controllers/filter_controller.dart';
import 'controllers/settings_controller.dart';

// Views
import 'views/splash/splash_screen.dart';
import 'views/home/home_screen.dart';
import 'views/news_detail/news_detail_screen.dart';
import 'views/statistics/statistics_screen.dart';
import 'views/sources/sources_screen.dart';
import 'views/search/search_screen.dart';
import 'views/filter/filter_screen.dart';
import 'views/settings/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ضبط أشرطة النظام
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  try {
    await dotenv.load(fileName: "assets/secrets.env");
    debugPrint("✅ تم تحميل المفاتيح بنجاح!");
  } catch (e) {
    debugPrint("❌ لم يتم العثور على الملف: $e");
  }
  // 1. تهيئة Supabase
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '');
  print("URL from env: ${dotenv.env['SUPABASE_URL']}");
  print("Key from env: ${dotenv.env['SUPABASE_ANON_KEY']}");
  // 2. تهيئة الخدمات والمتحكمات الأساسية
  await initServices();

  runApp(const AlkhabarApp());
}

Future<void> initServices() async {
  // 1. تهيئة محرك Hive لهواتف أندرويد (هذا السطر إلزامي 100% ليتمكن من إنشاء الصناديق على الهاتف)
  await Hive.initFlutter();

  // 2. الآن ستنجح دالة init() في فتح الصناديق الخمسة فوراً دون أي خطأ
  final storageService = StorageService();
  await storageService.init();
  Get.put<StorageService>(storageService, permanent: true);
  Get.put<AuthController>(AuthController(), permanent: true);
  // 3. باقي الخدمات
  Get.put<SupabaseService>(SupabaseService(), permanent: true);
  Get.put<NewsRepository>(NewsRepository(), permanent: true);
  Get.put<SourceRepository>(SourceRepository(), permanent: true);
  Get.put<SettingsController>(SettingsController(), permanent: true);
  Get.put<FilterController>(FilterController(), permanent: true);
  Get.put<NewsController>(NewsController(), permanent: true);
  Get.put<SourceController>(SourceController(), permanent: true);
}

class AlkhabarApp extends StatelessWidget {
  const AlkhabarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      fallbackLocale: const Locale('ar'),

      // ثيم احترافي ومباشر متوافق مع ألوان مشروعك
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Cairo',
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent, // تم تعديلها إلى accent
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0F172A),
          titleTextStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),

      // شاشة البداية
      initialRoute: AppRoutes.login,

      // مسارات التنقل
      getPages: [
        GetPage(
          name: AppRoutes.splash,
          page: () => const SplashScreen(),
        ),
        GetPage(name: AppRoutes.login, page: () => LoginScreen()),
        GetPage(
          name: AppRoutes.home,
          page: () => const HomeScreen(),
        ),
        GetPage(name: AppRoutes.register, page: () => SignUpScreen()),
        GetPage(
          name: AppRoutes.newsDetail,
          // حل خطأ: The named parameter 'news' is required
          // نقوم باستقبال الخبر من Get.arguments وتمريره مباشرة إلى الشاشة
          page: () => NewsDetailScreen(news: Get.arguments),
        ),
        GetPage(
          name: AppRoutes.statistics,
          page: () => const StatisticsScreen(),
        ),
        GetPage(
          name: AppRoutes.sources,
          page: () => const SourcesScreen(),
        ),
        GetPage(
          name: AppRoutes.search,
          page: () => const SearchScreen(),
        ),
        GetPage(
          name: AppRoutes.filter,
          page: () => const FilterScreen(),
        ),
        GetPage(
          name: AppRoutes.settings,
          page: () => const SettingsScreen(),
        ),
      ],
    );
  }
}

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String newsDetail = '/news-detail';
  static const String statistics = '/statistics';
  static const String sources = '/sources';
  static const String search = '/search';
  static const String filter = '/filter';
  static const String settings = '/settings';
  static const String login = '/login';
  static const String register = '/signup';
}
