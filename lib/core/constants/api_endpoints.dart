/// إعدادات الاتصال وجداول قاعدة بيانات Supabase
class ApiEndpoints {
  // رابط ومفتاح Supabase (استبدلها ببيانات مشروعك الخاصة)
  static const String supabaseUrl = 'https://bqroboskifelkvhylapq.supabase.co';

  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJxcm9ib3NraWZlbGt2aHlsYXBxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc0MDc3OTEsImV4cCI6MjEwMjk4Mzc5MX0.brDz4Gonc8aOpSKHNtH792mrGqju4wNKs-i3JGkSYE0';

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
