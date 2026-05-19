class CategoryModel {
  final String id;
  final String name;

  const CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
  );
}
