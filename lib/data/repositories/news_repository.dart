import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/news_model.dart';
import '../services/storage_service.dart';
import '../services/supabase_service.dart';

class NewsRepository {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  final StorageService _storageService = Get.find<StorageService>();

  /// جلب الأخبار مع دعم العمل في وضع عدم الاتصال (Offline First)
  Future<List<NewsModel>> getNews({
    int limit = 20,
    int offset = 0,
    String? category,
    String? region,
    String? importance,
    String? verifyStatus,
    List<String>? sourceIds,
  }) async {
    try {
      final data = await _supabaseService.fetchPublishedNews(
        limit: limit,
        offset: offset,
        category: category,
        region: region,
        importance: importance,
        verifyStatus: verifyStatus,
        sourceIds: sourceIds,
      );

      // طباعة عدد السجلات الخام القادمة من قاعدة البيانات في التيرمنال:
      debugPrint(
          '🔥 [SUPABASE RAW COUNT]: ${data.length} records returned from DB');

      final List<NewsModel> newsList = [];
      for (var item in data) {
        try {
          newsList.add(NewsModel.fromJson(item));
        } catch (modelError) {
          debugPrint(
              '❌ [NEWS MODEL FAILED]: Error parsing news "${item['title']}": $modelError');
        }
      }

      debugPrint(
          '✅ [NEWS PARSED SUCCESS]: ${newsList.length} items parsed successfully');

      // إذا كانت الصفحة الأولى، يتم حفظ الأخبار في Hive
      if (offset == 0 && newsList.isNotEmpty) {
        await _storageService.saveOfflineNews(newsList);
      }

      return newsList;
    } catch (e) {
      debugPrint('❌ [GET NEWS ERROR]: $e');
      if (offset == 0) {
        final cached = _storageService.getOfflineNews();
        if (cached.isNotEmpty) return cached;
      }
      rethrow;
    }
  }

  /// البحث
  Future<List<NewsModel>> search(String query) async {
    final data = await _supabaseService.searchNews(query);
    return data.map((item) => NewsModel.fromJson(item)).toList();
  }

  /// جلب الأخبار المشابهة
  Future<List<NewsModel>> getSimilarNews(
      {required String category,
      required String region,
      required String currentId}) async {
    try {
      final data = await _supabaseService.fetchPublishedNews(
          limit: 5, category: category, region: region);
      return data
          .map((item) => NewsModel.fromJson(item))
          .where((item) => item.id != currentId)
          .toList();
    } catch (_) {
      return [];
    }
  }
}
