import 'package:flutter/foundation.dart';

class AdminProduct {
  final String id;
  final String name;
  final String brand;
  final String cpu;
  final String ram;
  final String storage;
  final String gpu;
  final double price;
  final int stock;

  const AdminProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.cpu,
    required this.ram,
    required this.storage,
    required this.gpu,
    required this.price,
    required this.stock,
  });

  AdminProduct copyWith({
    String? id,
    String? name,
    String? brand,
    String? cpu,
    String? ram,
    String? storage,
    String? gpu,
    double? price,
    int? stock,
  }) {
    return AdminProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      cpu: cpu ?? this.cpu,
      ram: ram ?? this.ram,
      storage: storage ?? this.storage,
      gpu: gpu ?? this.gpu,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }
}

class AdminProductController extends ChangeNotifier {
  final List<AdminProduct> _products = [
    const AdminProduct(
      id: 'LP001',
      name: 'Asus Vivobook 15',
      brand: 'Asus',
      cpu: 'Intel Core i5',
      ram: '8GB',
      storage: '512GB SSD',
      gpu: 'Intel Iris Xe',
      price: 15900000,
      stock: 12,
    ),
    const AdminProduct(
      id: 'LP002',
      name: 'Acer Aspire 7',
      brand: 'Acer',
      cpu: 'AMD Ryzen 5',
      ram: '8GB',
      storage: '512GB SSD',
      gpu: 'GTX 1650',
      price: 18900000,
      stock: 5,
    ),
    const AdminProduct(
      id: 'LP003',
      name: 'Lenovo Legion 5',
      brand: 'Lenovo',
      cpu: 'AMD Ryzen 7',
      ram: '16GB',
      storage: '1TB SSD',
      gpu: 'RTX 3060',
      price: 28900000,
      stock: 3,
    ),
    const AdminProduct(
      id: 'LP004',
      name: 'MacBook Air M2',
      brand: 'Apple',
      cpu: 'Apple M2',
      ram: '8GB',
      storage: '256GB SSD',
      gpu: 'Apple GPU',
      price: 26900000,
      stock: 8,
    ),
  ];

  String _keyword = '';

  String get keyword => _keyword;

  List<AdminProduct> get products {
    if (_keyword.trim().isEmpty) {
      return List.unmodifiable(_products);
    }

    final lowerKeyword = _keyword.toLowerCase();

    return _products.where((product) {
      return product.name.toLowerCase().contains(lowerKeyword) ||
          product.brand.toLowerCase().contains(lowerKeyword) ||
          product.cpu.toLowerCase().contains(lowerKeyword);
    }).toList();
  }

  void searchProduct(String keyword) {
    _keyword = keyword;
    notifyListeners();
  }

  void addProduct(AdminProduct product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(AdminProduct product) {
    final index = _products.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  String generateProductId() {
    final nextNumber = _products.length + 1;
    return 'LP${nextNumber.toString().padLeft(3, '0')}';
  }

  String formatCurrency(double value) {
    return '${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )} đ';
  }
}   