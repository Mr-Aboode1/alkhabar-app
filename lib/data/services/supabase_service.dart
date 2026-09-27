import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/api_endpoints.dart';

/// خدمة الاتصال بـ Supabase مع مراعاة سياسات الأمان RLS
class SupabaseService {
  SupabaseClient get client => Supabase.instance.client;

  /// فحص الاتصال بالخادم
  Future<bool> checkConnection() async {
    try {
      final response =
          await client.from(ApiEndpoints.tableSources).select('id').limit(1);
      return response.isNotEmpty;
    } catch (e) {
      debugPrint('Supabase Connection Check: $e');
      return false;
    }
  }

  /// جلب الأخبار المنشورة والمؤكدة للزائرين (anon RLS)
  /// جلب الأخبار (المنشورة وأخبار البوت)
  /// جلب كافة المنشورات بلا استثناء (المؤكدة وغير المؤكدة وأخبار البوت)
  Future<List<Map<String, dynamic>>> fetchPublishedNews({
    int limit = 25,
    int offset = 0,
    String? category,
    String? region,
    String? importance,
    String? verifyStatus,
    List<String>? sourceIds,
  }) async {
    // 1. إعادة جلب الاستعلام الشامل (بما في ذلك image_url والمصادر sources لتعود الصور والبيانات)
    var filterBuilder = client.from(ApiEndpoints.tableNews).select('''
        id,
        source_id,
        title,
        content,
        image_url,
        category,
        region,
        importance,
        verify_status,
        status,
        views_count,
        published_at,
        created_at,
        sources (
          id,
          name,
          platform,
          reliability,
          category
        )
      ''');

    // طباعة للمراقبة في التيرمنال
    debugPrint(
        '🔍 Filtering database by -> Region: $region, Category: $category');

    // 2. تصفية التصنيف (Category) بشكل مرن
    if (category != null &&
        category.trim().isNotEmpty &&
        category != 'all' &&
        category != 'الكل') {
      filterBuilder = filterBuilder.eq('category', category.trim());
    }

    // 3. تصفية المنطقة/المحافظة (Region) بشكل مرن
    if (region != null &&
        region.trim().isNotEmpty &&
        region != 'الكل' &&
        region != 'all') {
      filterBuilder = filterBuilder.eq('region', region.trim());
    }

    if (importance != null && importance != 'all') {
      filterBuilder = filterBuilder.eq('importance', importance);
    }

    if (verifyStatus != null &&
        verifyStatus != 'all' &&
        verifyStatus != 'الكل') {
      filterBuilder = filterBuilder.eq('verify_status', verifyStatus);
    }

    if (sourceIds != null && sourceIds.isNotEmpty) {
      filterBuilder = filterBuilder.inFilter('source_id', sourceIds);
    }

    // 4. الترتيب والتحميل اللانهائي
    final response = await filterBuilder
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return List<Map<String, dynamic>>.from(response);
  }

  /// جلب المصادر النشطة
  Future<List<Map<String, dynamic>>> fetchActiveSources() async {
    final response = await client
        .from(ApiEndpoints.tableSources)
        .select(
            'id, name, platform, username, url, type, reliability, category, is_active, created_at')
        .eq('is_active', true)
        .order('reliability', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// زيادة عدد المشاهدات لخبر معين
  Future<void> incrementNewsViews(String newsId) async {
    try {
      await client.rpc('increment_news_views', params: {'news_id': newsId});
    } catch (e) {
      try {
        await client
            .from(ApiEndpoints.tableNews)
            .update({'views_count': 1}).eq('id', newsId);
      } catch (_) {}
    }
  }

  /// البحث في الأخبار بالمطابقة مع العنوان والمحتوى
  Future<List<Map<String, dynamic>>> searchNews(String searchQuery) async {
    final response = await client
        .from(ApiEndpoints.tableNews)
        .select('''
        id, source_id, title, content, image_url, category, region,
        importance, verify_status, status, views_count, published_at,
        sources (id, name, platform, reliability)
      ''')
        // حذفنا قيد status = published لكي يبحث في كل المنشورات كما طلبت
        .or('title.ilike.%$searchQuery%,content.ilike.%$searchQuery%')
        .order('created_at', ascending: false) // الترتيب حسب الأحدث
        .limit(30);

    return List<Map<String, dynamic>>.from(response);
  }

  /// تسجيل مستخدم جديد باستخدام البريد وكلمة المرور
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: data, // يمكن استخدامه لتخزين اسم المستخدم أو بيانات إضافية
      );
      return response;
    } catch (e) {
      debugPrint('Supabase SignUp Error: $e');
      rethrow;
    }
  }

  /// تسجيل الدخول بالبريد وكلمة المرور
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      debugPrint('Supabase SignIn Error: $e');
      rethrow;
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      debugPrint('Supabase SignOut Error: $e');
    }
  }

  /// الحصول على بيانات المستخدم الحالي
  User? get currentUser => client.auth.currentUser;

  /// التحقق مما إذا كان المستخدم مسجل الدخول أم لا
  bool get isAuthenticated => client.auth.currentUser != null;

  /// تحديث بيانات المستخدم (مثل تغيير كلمة المرور أو الاسم)
  Future<UserResponse> updateUser(UserAttributes attributes) async {
    return await client.auth.updateUser(attributes);
  }

  /// إرسال رابط إعادة تعيين كلمة المرور
  Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }
}
