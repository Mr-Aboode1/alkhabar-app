class Validators {
  /// التحقق من رقم الهاتف اليمني (يبدأ بـ 77 أو 73 أو 71 أو 70 ويتكون من 9 أرقام)
  static bool isValidYemeniPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'\s+|-'), '');
    final yemenPhoneRegex = RegExp(r'^(?:\+?967)?(7[01378]\d{7})$');
    return yemenPhoneRegex.hasMatch(cleanPhone);
  }

  /// التحقق من صحة رابط ويب
  static bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }
}
