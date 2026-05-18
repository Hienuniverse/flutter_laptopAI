class Validators {
  Validators._();

  static String? requiredText(String? value, {String message = 'Vui lòng nhập thông tin'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Vui lòng nhập email';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(text)) return 'Email không hợp lệ';
    return null;
  }
}
