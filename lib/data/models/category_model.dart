class CategoryModel {
  final int? maDM;
  final String tenDM;
  final String? moTa;
  final String? slug;
  final String icon;
  final String colorClass;
  final bool trangThai;

  CategoryModel({
    this.maDM,
    required this.tenDM,
    this.moTa,
    this.slug,
    this.icon = 'FolderTree',
    this.colorClass = 'cyan',
    this.trangThai = true,
  });

  int? get id => maDM;
  String get name => tenDM;
  String get description => moTa ?? '';

  factory CategoryModel.fromJson(Map json) {
    return CategoryModel(
      maDM: json['MaDM'] ?? json['maDM'] ?? json['madm'],
      tenDM: json['TenDM'] ?? json['tenDM'] ?? json['tendm'] ?? '',
      moTa: json['MoTa'] ?? json['moTa'] ?? json['mota'],
      slug: json['Slug'] ?? json['slug'],
      icon: json['Icon'] ?? json['icon'] ?? 'FolderTree',
      colorClass: json['ColorClass'] ?? json['colorClass'] ?? 'cyan',
      trangThai: json['TrangThai'] == true ||
          json['trangThai'] == true ||
          json['trangthai'] == true ||
          json['trangthai'] == 1 ||
          json['TrangThai'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (maDM != null) 'madm': maDM,
      'tendm': tenDM,
      'mota': moTa,
      'slug': slug,
      'icon': icon,
      'colorclass': colorClass,
      'trangthai': trangThai,
    };
  }
}