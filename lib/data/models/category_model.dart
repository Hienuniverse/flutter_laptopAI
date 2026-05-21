class CategoryModel {
  final int? maDM;
  final String tenDM;
  final String? moTa;
  final String? slug;
  final String icon;
  final String colorClass;

  CategoryModel({
    this.maDM,
    required this.tenDM,
    this.moTa,
    this.slug,
    this.icon = 'FolderTree',
    this.colorClass = 'cyan',
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      maDM: json['MaDM'] ?? json['maDM'],
      tenDM: json['TenDM'] ?? json['tenDM'] ?? '',
      moTa: json['MoTa'] ?? json['moTa'],
      slug: json['Slug'] ?? json['slug'],
      icon: json['Icon'] ?? json['icon'] ?? 'FolderTree',
      colorClass: json['ColorClass'] ?? json['colorClass'] ?? 'cyan',
    );
  }
}