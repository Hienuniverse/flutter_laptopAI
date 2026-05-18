class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;

  const UserModel({required this.id, required this.name, required this.email, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        role: json['role']?.toString() ?? 'user',
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email, 'role': role};
}
