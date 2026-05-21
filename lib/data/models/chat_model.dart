class ChatModel {
  final int? maChat;
  final int? maTK;
  final String? maPhienChat;
  final String cauHoi;
  final String aiTraLoi;
  final String? thoiGian;

  ChatModel({
    this.maChat,
    this.maTK,
    this.maPhienChat,
    required this.cauHoi,
    required this.aiTraLoi,
    this.thoiGian,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      maChat: json['MaChat'] ?? json['maChat'],
      maTK: json['MaTK'] ?? json['maTK'],
      maPhienChat: json['MaPhienChat'] ?? json['maPhienChat'],
      cauHoi: json['CauHoi'] ?? json['cauHoi'] ?? '',
      aiTraLoi: json['AI_TraLoi'] ?? json['ai_TraLoi'] ?? '',
      thoiGian: json['ThoiGian'] ?? json['thoiGian'],
    );
  }
}