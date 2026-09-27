/// نموذج بيانات جدول sources المتوافق مع Supabase
class SourceModel {
  final String id;
  final String name;
  final String platform; // telegram, twitter, website, agency
  final String? username;
  final String? url;
  final String type; // official, news_outlet, independent, citizen
  final int reliability; // نسبة مئوية 0 - 100
  final String category;
  final bool isActive;
  final DateTime? createdAt;
  final bool isFollowing;

  SourceModel({
    required this.id,
    required this.name,
    this.platform = 'telegram',
    this.username,
    this.url,
    this.type = 'news_outlet',
    this.reliability = 85,
    this.category = 'general',
    this.isActive = true,
    this.createdAt,
    this.isFollowing = false,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'مصدر إخباري',
      platform: json['platform'] ?? 'telegram',
      username: json['username'],
      url: json['url'],
      type: json['type'] ?? 'news_outlet',
      reliability: json['reliability'] is int
          ? json['reliability']
          : int.tryParse(json['reliability']?.toString() ?? '80') ?? 80,
      category: json['category'] ?? 'general',
      isActive: json['is_active'] == true || json['is_active'] == 1,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'platform': platform,
      'username': username,
      'url': url,
      'type': type,
      'reliability': reliability,
      'category': category,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  SourceModel copyWith({
    String? id,
    String? name,
    String? platform,
    String? username,
    String? url,
    String? type,
    int? reliability,
    String? category,
    bool? isActive,
    DateTime? createdAt,
    bool? isFollowing,
  }) {
    return SourceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      username: username ?? this.username,
      url: url ?? this.url,
      type: type ?? this.type,
      reliability: reliability ?? this.reliability,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
