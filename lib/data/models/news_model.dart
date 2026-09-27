import 'source_model.dart';

/// نموذج بيانات جدول news المتوافق مع مخطط Supabase و Hive
class NewsModel {
  final String id;
  final String? sourceId;
  final String? userId;
  final String title;
  final String content;
  final String? imageUrl;
  final String category;
  final String region;
  final String importance; // urgent, important, normal
  final bool verified;
  final String verifyStatus; // verified, pending, suspicious
  final String status; // published, draft, pending_review
  final int viewsCount;
  final DateTime? publishedAt;
  final DateTime? createdAt;

  // حقول مساعدة للواجهة
  final SourceModel? source;
  final List<SourceModel>? additionalSources;
  final bool isSaved;

  NewsModel({
    required this.id,
    this.sourceId,
    this.userId,
    required this.title,
    required this.content,
    this.imageUrl,
    this.category = 'general',
    this.region = 'الكل',
    this.importance = 'normal',
    this.verified = false,
    this.verifyStatus = 'pending',
    this.status = 'published',
    this.viewsCount = 0,
    this.publishedAt,
    this.createdAt,
    this.source,
    this.additionalSources,
    this.isSaved = false,
  });

  /// تحويل من JSON قادم من Supabase
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id']?.toString() ?? '',
      sourceId: json['source_id']?.toString(),
      userId: json['user_id']?.toString(),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      category: json['category'] ?? 'general',
      region: json['region'] ?? 'الكل',
      importance: json['importance'] ?? 'normal',
      verified: json['verified'] == true,
      verifyStatus: json['verify_status'] ?? 'pending',
      status: json['status'] ?? 'published',
      viewsCount: json['views_count'] is int
          ? json['views_count']
          : int.tryParse(json['views_count']?.toString() ?? '0') ?? 0,
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      source: json['sources'] != null
          ? SourceModel.fromJson(json['sources'])
          : null,
    );
  }

  get summary => null;

  /// تحويل إلى JSON للتخزين أو الإرسال
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source_id': sourceId,
      'user_id': userId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'category': category,
      'region': region,
      'importance': importance,
      'verified': verified,
      'verify_status': verifyStatus,
      'status': status,
      'views_count': viewsCount,
      'published_at': publishedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// نسخة معدلة من الكائن
  NewsModel copyWith({
    String? id,
    String? sourceId,
    String? userId,
    String? title,
    String? content,
    String? imageUrl,
    String? category,
    String? region,
    String? importance,
    bool? verified,
    String? verifyStatus,
    String? status,
    int? viewsCount,
    DateTime? publishedAt,
    DateTime? createdAt,
    SourceModel? source,
    List<SourceModel>? additionalSources,
    bool? isSaved,
  }) {
    return NewsModel(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      region: region ?? this.region,
      importance: importance ?? this.importance,
      verified: verified ?? this.verified,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      status: status ?? this.status,
      viewsCount: viewsCount ?? this.viewsCount,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      source: source ?? this.source,
      additionalSources: additionalSources ?? this.additionalSources,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
