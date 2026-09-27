/// إعدادات الاتصال وجداول قاعدة بيانات Supabase
///
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get url => dotenv.env['SUPABASE_URL'] ?? '';
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // أسماء الجداول في Supabase
  static const String tableNews = 'news';
  static const String tableSources = 'sources';
  static const String tableUsers = 'users';
  static const String tableNotifications = 'notifications';

  // أسماء صناديق Hive للتخزين المحلي
  static const String boxOfflineNews = 'offline_news_box';
  static const String boxBookmarks = 'bookmarks_box';
  static const String boxSearchHistory = 'search_history_box';
  static const String boxUserPreferences = 'user_prefs_box';
  static const String boxFavoriteFilters = 'favorite_filters_box';
}
