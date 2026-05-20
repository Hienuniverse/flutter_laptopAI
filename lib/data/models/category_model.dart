class CategoryModel {
  final int id;
  final String name;
  final String description;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: _toInt(json['id'] ?? json['MaDanhMuc'] ?? json['categoryId']),
      name: (json['name'] ?? json['TenDanhMuc'] ?? json['categoryName'] ?? '')
          .toString(),
      description: (json['description'] ?? json['MoTa'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}