class LaptopModel {
  final int id;
  final String name;
  final String brand;
  final String category;
  final String image;
  final double price;
  final String cpu;
  final String ram;
  final String storage;
  final String gpu;
  final String screen;
  final String description;
  final int stock;
  final int aiScore; // 🔥 THÊM 1: Khai báo biến aiScore

  LaptopModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.image,
    required this.price,
    required this.cpu,
    required this.ram,
    required this.storage,
    required this.gpu,
    required this.screen,
    required this.description,
    required this.stock,
    required this.aiScore, // 🔥 THÊM 2: Thêm vào Constructor bắt buộc
  });

  factory LaptopModel.fromJson(Map<String, dynamic> json) {
    return LaptopModel(
      id: _toInt(json['id'] ?? json['MaLaptop'] ?? json['MaSP']),
      name: (json['name'] ?? json['TenLaptop'] ?? json['TenSP'] ?? '').toString(),
      brand: (json['brand'] ?? json['ThuongHieu'] ?? json['Hang'] ?? '').toString(),
      category: (json['category'] ?? json['DanhMuc'] ?? json['TenDanhMuc'] ?? '').toString(),
      image: (json['image'] ?? json['HinhAnh'] ?? json['Anh'] ?? '').toString(),
      price: _toDouble(json['price'] ?? json['Gia'] ?? json['DonGia']),
      cpu: (json['cpu'] ?? json['CPU'] ?? '').toString(),
      ram: (json['ram'] ?? json['RAM'] ?? '').toString(),
      storage: (json['storage'] ?? json['SSD'] ?? json['BoNho'] ?? '').toString(),
      gpu: (json['gpu'] ?? json['GPU'] ?? '').toString(),
      screen: (json['screen'] ?? json['ManHinh'] ?? '').toString(),
      description: (json['description'] ?? json['MoTa'] ?? '').toString(),
      stock: _toInt(json['stock'] ?? json['SoLuong'] ?? json['TonKho']),
      // 🔥 THÊM 3: Map dữ liệu từ backend (Hỗ trợ cả trường hợp viết hoa viết thường từ SQL trả về)
      aiScore: _toInt(json['aiScore'] ?? json['AIScore'] ?? json['diemAI'] ?? 90),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'image': image,
      'price': price,
      'cpu': cpu,
      'ram': ram,
      'storage': storage,
      'gpu': gpu,
      'screen': screen,
      'description': description,
      'stock': stock,
      'aiScore': aiScore, // 🔥 THÊM 4: Thêm vào hàm xuất chuỗi JSON
    };
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}