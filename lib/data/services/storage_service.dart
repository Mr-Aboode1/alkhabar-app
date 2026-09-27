import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/news_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// إدارة التخزين المحلي السريع وميزة تصفح الأخبار دون إنترنت عبر Hive
class StorageService {
  late Box _offlineNewsBox;
  late Box _bookmarksBox;
  late Box _searchHistoryBox;
  late Box _userPrefsBox;
  late Box _favoriteFiltersBox;

  Future<void> init() async {
    _offlineNewsBox = await Hive.openBox(ApiEndpoints.boxOfflineNews);
    _bookmarksBox = await Hive.openBox(ApiEndpoints.boxBookmarks);
    _searchHistoryBox = await Hive.openBox(ApiEndpoints.boxSearchHistory);
    _userPrefsBox = await Hive.openBox(ApiEndpoints.boxUserPreferences);
    _favoriteFiltersBox = await Hive.openBox(ApiEndpoints.boxFavoriteFilters);
  }

  // --- 1. تخزين آخر 50 خبر للأوفلاين ---
  Future<void> saveOfflineNews(List<NewsModel> newsList) async {
    final toSave = newsList.take(50).toList();
    final jsonList = toSave.map((news) => news.toJson()).toList();
    await _offlineNewsBox.put('latest_50_news', jsonList);
  }

  List<NewsModel> getOfflineNews() {
    final rawData = _offlineNewsBox.get('latest_50_news');
    if (rawData == null || rawData is! List) return [];
    return rawData
        .map((item) => NewsModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  // --- 2. الأخبار المحفوظة في المفضلة (Bookmarks) ---
  Future<void> toggleBookmark(NewsModel news) async {
    if (_bookmarksBox.containsKey(news.id)) {
      await _bookmarksBox.delete(news.id);
    } else {
      await _bookmarksBox.put(news.id, news.toJson());
    }
  }

  bool isBookmarked(String newsId) {
    return _bookmarksBox.containsKey(newsId);
  }

  List<NewsModel> getBookmarkedNews() {
    final List<NewsModel> list = [];
    for (var key in _bookmarksBox.keys) {
      final data = _bookmarksBox.get(key);
      if (data != null) {
        list.add(NewsModel.fromJson(Map<String, dynamic>.from(data)));
      }
    }
    return list;
  }

  // --- 3. سجل البحث ---
  Future<void> addSearchQuery(String query) async {
    if (query.trim().isEmpty) return;
    List<String> history = getSearchHistory();
    history.remove(query.trim());
    history.insert(0, query.trim());
    if (history.length > 10) history = history.sublist(0, 10);
    await _searchHistoryBox.put('queries', history);
  }

  List<String> getSearchHistory() {
    final list = _searchHistoryBox.get('queries');
    if (list is List) return List<String>.from(list);
    return [
      'أسعار الصرف صنعاء',
      'طريق تعز',
      'أسعار البنزين عدن',
      'أمطار حضرموت'
    ];
  }

  Future<void> clearSearchHistory() async {
    await _searchHistoryBox.delete('queries');
  }

  // --- 4. المصادر المتابعة ---
  Future<void> toggleFollowSource(String sourceId) async {
    List<String> followed = getFollowedSources();
    if (followed.contains(sourceId)) {
      followed.remove(sourceId);
    } else {
      followed.add(sourceId);
    }
    await _userPrefsBox.put('followed_sources', followed);
  }

  List<String> getFollowedSources() {
    final list = _userPrefsBox.get('followed_sources');
    if (list is List) return List<String>.from(list);
    return [];
  }

  // --- 5. مسح الكاش بالكامل ---
  Future<void> clearAllCache() async {
    await _offlineNewsBox.clear();
    await _searchHistoryBox.clear();
  }
}
