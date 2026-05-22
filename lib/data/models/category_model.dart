class CategoryModel {
  final int? maDM;
  final String tenDM;
  final String? moTa;
  final String? slug;
  final String icon;
  final String colorClass;
  final bool trangThai;
  final String? ngayTao;

  const CategoryModel({
    this.maDM,
    required this.tenDM,
    this.moTa,
    this.slug,
    this.icon = 'FolderTree',
    this.colorClass = 'cyan',
    this.trangThai = true,
    this.ngayTao,
  });

  int? get id => maDM;
  String get name => tenDM;
  String get description => moTa ?? '';

  factory CategoryModel.fromJson(Map json) {
    return CategoryModel(
      maDM: _toInt(json['madm'] ?? json['maDM'] ?? json['MaDM']),
      tenDM: (json['tendm'] ?? json['tenDM'] ?? json['TenDM'] ?? '').toString(),
      moTa:
          json['mota']?.toString() ??
          json['moTa']?.toString() ??
          json['MoTa']?.toString(),
      slug: json['slug']?.toString() ?? json['Slug']?.toString(),
      icon: (json['icon'] ?? json['Icon'] ?? 'FolderTree').toString(),
      colorClass:
          (json['colorclass'] ??
                  json['colorClass'] ??
                  json['ColorClass'] ??
                  'cyan')
              .toString(),
      trangThai: _toBool(
        json['trangthai'] ?? json['trangThai'] ?? json['TrangThai'],
      ),
      ngayTao: json['ngaytao']?.toString() ?? json['ngayTao']?.toString(),
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

  static int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString());
  }

  static bool _toBool(dynamic value) {
    if (value == null) {
      return true;
    }

    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    final text = value.toString().toLowerCase();

    return text == 'true' || text == '1';
  }
}
