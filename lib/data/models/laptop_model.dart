class LaptopModel {
  final String id;
  final String name;
  final String brand;
  final String cpu;
  final String ram;
  final String storage;
  final double price;
  final String imageUrl;
  final double aiScore;

  const LaptopModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.cpu,
    required this.ram,
    required this.storage,
    required this.price,
    this.imageUrl = '',
    this.aiScore = 0,
  });

  factory LaptopModel.fromJson(Map<String, dynamic> json) => LaptopModel(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        brand: json['brand']?.toString() ?? '',
        cpu: json['cpu']?.toString() ?? '',
        ram: json['ram']?.toString() ?? '',
        storage: json['storage']?.toString() ?? '',
        price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
        imageUrl: json['imageUrl']?.toString() ?? '',
        aiScore: double.tryParse(json['aiScore']?.toString() ?? '0') ?? 0,
      );
}
